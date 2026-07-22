# Medalj.com infrastructure

Terraform configuration is introduced in small, reviewable iterations. The
existing `rg-medalj-dev` resource group and its live Static Web App are not
managed by this configuration yet.

## Current iteration

The `environments/prod` root module defines only a new production resource
group. CI checks
formatting and validates the configuration, but does not authenticate to Azure,
run a plan, or apply changes.

```text
infra/terraform/
└── environments/
    └── prod/
        ├── main.tf
        ├── outputs.tf
        ├── providers.tf
        ├── terraform.tfvars.example
        ├── variables.tf
        └── versions.tf
```

## Local checks

```bash
terraform -chdir=infra/terraform/environments/prod init -backend=false
terraform -chdir=infra/terraform/environments/prod fmt -check
terraform -chdir=infra/terraform/environments/prod validate
```

Do not run `terraform apply` for the Azure subscription yet. Remote state,
GitHub OIDC authentication, permissions, and the apply workflow will be added
and reviewed before the first apply.

`terraform.tfvars.example` documents suggested development values. A real
`terraform.tfvars` file is intentionally ignored because environment-specific
values should be supplied by CI later.

## Planned next iterations

1. Bootstrap a separate, protected Azure Storage backend for Terraform state.
2. Create a least-privilege deployment identity with GitHub OIDC federation.
3. Add a pull-request workflow that runs `terraform plan` without applying.
4. Add a protected GitHub environment and an apply workflow for `main`.
5. Apply the first plan, containing only the new production resource group.
6. Add one Azure service at a time, beginning with low-risk shared resources.
