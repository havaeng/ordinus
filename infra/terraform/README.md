# Ordinus infrastructure

Terraform configuration is introduced in small, reviewable iterations. Ordinus
is the backend and infrastructure name; Medalj.com refers to the public website
and frontend. The existing frontend resource group `rg-medalj-dev` and its live
Static Web App are not managed by this backend configuration.

## Current iteration

The bootstrap root has created the protected Azure Storage backend and migrated
its state to `bootstrap.tfstate`. The production root still defines only a new
resource group and has not been applied. CI checks formatting and validates both
root modules, but does not yet authenticate to Azure or run a plan.

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
bootstrap root in CI. For authenticated local bootstrap checks, use the
dedicated Azure CLI profile and initialize the configured remote backend.

Do not apply the production root yet. Its remote backend, GitHub OIDC
identities, permissions, plan workflow, and protected apply workflow must be
added and reviewed first.

`terraform.tfvars.example` documents suggested production values. A real
`terraform.tfvars` file is intentionally ignored because environment-specific
values should be supplied by CI later.

The complete sequence of small infrastructure increments is documented in
[`ROADMAP.md`](ROADMAP.md).
