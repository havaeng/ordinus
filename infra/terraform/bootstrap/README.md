# Terraform state bootstrap

This root module creates the Azure resources needed before remote Terraform
state can be enabled:

- a dedicated resource group;
- a Standard LRS Storage Account;
- a private blob container;
- blob versioning and 30-day soft delete;
- a `CanNotDelete` management lock on the Storage Account.

Shared-key authentication is disabled. Local administration and future CI
workflows will use Microsoft Entra ID. Public network access remains enabled
because GitHub-hosted runners do not have a stable private connection to the
Azure virtual network; the container is still private and requires an
authenticated, authorized identity.

## Why this starts with local state

The remote backend cannot be used before its Storage Account exists. The first
bootstrap apply therefore uses local state. Immediately afterwards, that state
will be migrated into the new backend under a separate `bootstrap.tfstate` key.
The production root module will use `prod.tfstate` in the same container.

No apply is part of this iteration. Before the bootstrap is run, the proposed
resources and the globally unique Storage Account name must be reviewed.

