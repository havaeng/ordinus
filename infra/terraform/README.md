# Ordinus infrastructure

Terraform configuration is introduced in small, reviewable iterations. Ordinus
is the backend and infrastructure name; Medalj.com refers to the public website
and frontend. The existing frontend resource group `rg-medalj-dev` and its live
Static Web App are not managed by this backend configuration.

## Current iteration

The bootstrap root has created the protected Azure Storage backend, migrated its
state to `bootstrap.tfstate`, and provisioned separate GitHub OIDC identities for
plan and apply. The protected GitHub environments `production-plan` and
`production` hold their environment-specific Azure IDs; no client secrets are
used. The production root is connected to the separate `prod.tfstate` key. Its
verified plan contains only the new production resource group and has not been
applied.

Pull requests that change the production Terraform root run
`.github/workflows/terraform-plan.yml`. The plan job uses the protected
`production-plan` environment and Terraform's native GitHub OIDC support. It is
limited to pull requests whose source branch belongs to this repository, reads
the remote state without locking it, and cannot apply changes. A reviewer must
approve the GitHub environment before the job receives its OIDC token. The job
creates or updates one collapsible plan comment in the pull request conversation
and links back to the complete workflow log.

Production apply is a separate, manually dispatched workflow in
`.github/workflows/terraform-apply.yml`. It runs only from `main`, waits for the
protected `production` environment approval, creates a fresh plan with state
locking enabled, and applies that exact saved plan. Concurrency allows only one
production apply to run at a time and never cancels an apply already in
progress.

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

Do not apply the production root locally. Merge and review the protected apply
workflow first; its initial manual run is a separate roadmap increment.

`terraform.tfvars.example` documents suggested production values. A real
`terraform.tfvars` file is intentionally ignored because environment-specific
values should be supplied by CI later.

The complete sequence of small infrastructure increments is documented in
[`ROADMAP.md`](ROADMAP.md).
