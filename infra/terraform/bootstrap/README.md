# Terraform state bootstrap

This root module creates the Azure resources needed before remote Terraform
state can be enabled:

- a dedicated resource group;
- a Standard LRS Storage Account;
- a private blob container;
- blob versioning and 30-day soft delete;
- a Storage Blob Data Contributor assignment for the bootstrap administrator;
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
