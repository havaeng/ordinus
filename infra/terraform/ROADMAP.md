# Infrastructure roadmap

Each increment should be a small pull request with an observable result and a
clear rollback path. Expensive services are introduced only when the deployment
pipeline that consumes them is ready.

## Terraform platform

1. **Production scaffold (complete)** — Terraform structure, version pinning,
   formatting, and validation without Azure access.
2. **State bootstrap (complete)** — Define protected Azure Storage resources for
   remote state.
3. **Run and migrate bootstrap state (complete)** — Apply bootstrap once with a
   personal Azure CLI session, then migrate its local state to
   `bootstrap.tfstate`.
4. **Production backend (complete)** — Configure the production root to use
   `prod.tfstate` and verify remote locking without changing production
   resources.
5. **GitHub OIDC identities and RBAC (complete)** — Create separate plan and apply
   identities. The plan identity is read-only; the apply identity receives only
   the permissions needed for the production resource group and state.
6. **Pull-request plan (complete)** — Run and publish `terraform plan` on
   infrastructure pull requests. Never apply pull-request code.
7. **Protected production apply (complete)** — Re-plan after merge and apply
   through a protected GitHub `production` environment with concurrency control.
8. **First production apply (complete)** — Create only `rg-ordinus-prod` and
   verify that Terraform state, locking, OIDC, plan, and apply all work end to
   end.
9. **Scope apply identity to production (next)** — Replace the temporary
   subscription-level resource-group creator assignment with Contributor scoped
   only to `rg-ordinus-prod`, so future resources can be managed inside the group
   without broader subscription permissions.

## Cost and shared services

10. **Cost guardrails** — Add an Azure budget and alerts. A budget reports spend;
   it does not impose a hard spending cap.
11. **Application Blob Storage** — Create the medal-image Storage Account and
    private containers, including retention, CORS, and upload constraints.
12. **Container Registry** — Create a Basic Azure Container Registry with admin
    credentials disabled.
13. **Backend image CI** — Test and build the Spring Boot image, authenticate by
    OIDC, and push immutable image tags to ACR. Do not deploy yet.
14. **Key Vault and runtime identity** — Create a user-assigned managed identity,
    Key Vault, and narrowly scoped access for runtime secrets and Blob Storage.

## Runtime and data

15. **Container Apps foundation** — Add Log Analytics and a Container Apps
    Environment using a cost-conscious configuration.
16. **PostgreSQL** — Add the smallest suitable PostgreSQL Flexible Server,
    database, networking, backups, and credentials in Key Vault. Review the
    projected recurring cost before apply.
17. **Container App** — Deploy the backend with health probes, resource limits,
    scale-to-zero where compatible, the `azure` Spring profile, managed identity,
    and no public secrets in Terraform variables.
18. **Backend deployment workflow** — Promote a tested ACR image to the Container
    App independently of Terraform infrastructure changes.
19. **End-to-end verification** — Exercise Actuator, Liquibase, PostgreSQL, Blob
    Storage, logs, restart behavior, and rollback.

## Migration and later capabilities

20. **Frontend migration assessment** — Inventory the existing Medalj.com Static
    Web App, custom domain, DNS, and GitHub deployment configuration. Keep its
    lifecycle separate from the Ordinus backend.
21. **Formalize frontend infrastructure** — Move the Static Web App to a
    dedicated frontend resource group such as `rg-medalj-prod`, verify DNS and
    deployment, then import it into separately scoped Terraform state without
    replacement.
22. **Entra External ID** — Add frontend/API registrations, token validation, and
    the Admin app role after deployment is stable.
23. **Community features** — Add users, moderation, uploads, comments, and “Mina
    medaljer” in independently deployable increments.
