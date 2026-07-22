# Ordinus infrastructure

Terraform configuration is introduced in small, reviewable iterations. Ordinus
is the backend and infrastructure name; Medalj.com refers to the public website
and frontend. The existing frontend resource group `rg-medalj-dev` and its live
Static Web App are not managed by this backend configuration.

## Current iteration

The production root module still defines only a new resource group. The
`bootstrap` root module now defines the protected Storage Account and container
that will hold remote Terraform state. CI checks formatting and validates both
root modules, but does not authenticate to Azure, run a plan, or apply changes.

```text
infra/terraform/
├── bootstrap/
├── environments/
│   └── prod/
└── ROADMAP.md
```

## Local checks

```bash
terraform -chdir=infra/terraform/environments/prod init -backend=false
terraform -chdir=infra/terraform/environments/prod fmt -check
terraform -chdir=infra/terraform/environments/prod validate
```

Run the same three commands with `infra/terraform/bootstrap` to check the
bootstrap root locally.

Do not run `terraform apply` for the Azure subscription yet. Remote state,
GitHub OIDC authentication, permissions, and the apply workflow will be added
and reviewed before the first apply.

`terraform.tfvars.example` documents suggested production values. A real
`terraform.tfvars` file is intentionally ignored because environment-specific
values should be supplied by CI later.

The complete sequence of small infrastructure increments is documented in
[`ROADMAP.md`](ROADMAP.md).
