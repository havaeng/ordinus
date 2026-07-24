# Terraform state bootstrap

This root module creates the Azure resources needed before remote Terraform
state can be enabled:

- a dedicated resource group;
- a Standard LRS Storage Account;
- a private blob container;
- blob versioning and 30-day soft delete;
- a Storage Blob Data Contributor assignment for the bootstrap administrator;
- separate user-assigned identities for GitHub plan and apply workflows;
- environment-bound GitHub OIDC federation without client secrets;
- read-only Azure and state access for the plan identity;
- state write access and Contributor scoped only to the existing production
  resource group for the apply identity;
- a separate image publisher identity with `AcrPush` scoped only to the
  production Container Registry;
- a `CanNotDelete` management lock on the Storage Account.

Shared-key authentication is disabled. Local administration and future CI
workflows will use Microsoft Entra ID. Public network access remains enabled
because GitHub-hosted runners do not have a stable private connection to the
Azure virtual network; the container is still private and requires an
authenticated, authorized identity.

## Why this starts with local state

The remote backend cannot be used before its Storage Account exists. The first
bootstrap apply therefore used local state. That state is now stored in the new
backend under the separate `bootstrap.tfstate` key. The production root module
will use `prod.tfstate` in the same container.

The backend authenticates to the Blob data plane with Microsoft Entra ID. Local
commands use the dedicated `~/.azure-ordinus` Azure CLI profile; future CI
workflows will use workload identity federation instead of account keys.

## GitHub environments

The federated credentials trust these exact GitHub OIDC subjects:

- `repo:havaeng/ordinus:environment:production-plan`
- `repo:havaeng/ordinus:environment:production`
- `repo:havaeng/ordinus:environment:production-images`

The plan and apply GitHub environments have required reviewers.
`production-plan` permits pull-request refs, while `production` is restricted
to the `main` branch. Each environment defines `AZURE_CLIENT_ID`,
`AZURE_TENANT_ID`, and `AZURE_SUBSCRIPTION_ID` as non-secret environment
variables. The plan identity can read Azure resources and Terraform state but
cannot modify either. The apply identity can update state and, through
Contributor, manage resources inside `rg-ordinus-prod`. It has no
subscription-level role assignment and Contributor cannot manage Azure RBAC.

`production-images` is restricted to `main` but does not require a reviewer,
because publishing an immutable image does not deploy it. It defines the same
three non-secret Azure ID variables. Its dedicated identity has only `AcrPush`
on `acrordinusprod696163`; it cannot change infrastructure, read Terraform
state, or access other Azure resources.
