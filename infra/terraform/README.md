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
first protected apply created `rg-ordinus-prod`; a subsequent state refresh and
plan confirmed that the deployed infrastructure matches the configuration with
no changes.

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

Do not apply the production root locally. Use the protected GitHub workflow for
all production changes. The apply identity has Contributor scoped only to
`rg-ordinus-prod` plus separate write access to Terraform state; its temporary
subscription-level permission has been removed.

Cost guardrails are scoped independently: the existing frontend budget remains
on `rg-medalj-dev`, while the production root defines a separate monthly budget
and notifications for `rg-ordinus-prod`.

Application Blob Storage is introduced in smaller increments. The secured
Storage Account, separate private containers for submitted and published
images, Blob versioning, and 30-day soft-delete retention are applied and
verified.

Initial image uploads will pass through the authenticated Ordinus API. Direct
browser uploads, Blob CORS, and SAS are intentionally omitted. The decision,
required abuse controls, and criteria for revisiting direct upload are recorded
in [`ADR 0001`](../../docs/architecture/decisions/0001-image-uploads-through-api.md).
Runtime data-plane access remains a separate reviewed change.

The current increment adds only a private Basic Azure Container Registry for
backend images. Its local admin account is disabled. The public network endpoint
remains enabled so GitHub-hosted runners and future Azure Container Apps can
reach it, but clients must authenticate and receive explicit registry
authorization. Image push/pull role assignments and image lifecycle automation
are deliberately deferred until their respective consumers exist.

`terraform.tfvars.example` documents suggested production values. A real
`terraform.tfvars` file is intentionally ignored because environment-specific
values should be supplied by CI later.

The complete sequence of small infrastructure increments is documented in
[`ROADMAP.md`](ROADMAP.md).
