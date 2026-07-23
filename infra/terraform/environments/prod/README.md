# Ordinus production infrastructure

This root module uses the AzureRM backend at `prod.tfstate`, separate from the
bootstrap root's `bootstrap.tfstate`. The state container uses Microsoft Entra
ID authentication; Storage Account keys are not used.

The root defines `rg-ordinus-prod` and a monthly resource-group budget. The
budget defaults to 300 SEK and notifies `info@medalj.com` at 50, 75, 90, and
100 percent of actual spend, plus 100 percent of forecasted spend. It reports
cost but does not stop or disable Azure resources. The protected production
workflow has applied the budget, and a subsequent plan confirmed no drift.

The existing `budget-medalj` budget belongs to the legacy frontend resource
group `rg-medalj-dev` and remains outside this production backend root.

The application Storage Account foundation uses Standard LRS in Sweden Central.
Anonymous blob access, Shared Key authorization, local users, and cross-tenant
replication are disabled. Microsoft Entra ID is the default authorization path,
and HTTPS with TLS 1.2 or newer is required. The protected production workflow
has applied the account, and a subsequent plan confirmed no drift.

The public network endpoint remains enabled so future Azure-hosted runtimes can
reach it without a private endpoint. This does not make blob data public. The
`image-submissions` container isolates unreviewed uploads from the
`published-images` container, and both deny anonymous access. Blob versioning
and 30-day soft-delete retention for blobs and containers provide a limited
recovery window. Retained versions and deleted data continue to consume storage
until they expire. The protected production workflow has applied these settings,
and a subsequent plan confirmed no drift.

Initial uploads will pass through the authenticated Ordinus API, so no Blob
Storage CORS rule or upload SAS is configured. Runtime data-plane RBAC remains a
separate increment. Until the API and its managed identity are configured,
creating the containers does not grant application users permission to upload
or read images. See
[`ADR 0001`](../../../../docs/architecture/decisions/0001-image-uploads-through-api.md).

CI validation uses `terraform init -backend=false`. Authenticated local checks
must use the dedicated `~/.azure-ordinus` Azure CLI profile and the intended
subscription. Production changes are applied only through the protected GitHub
workflow, not from a local CLI session.
