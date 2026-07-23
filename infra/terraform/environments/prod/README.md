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
reach it without a private endpoint. This does not make blob data public:
containers will be private and every data request must be authorized. Containers,
retention, CORS, and runtime data-plane RBAC are deliberately deferred to
separate increments.

CI validation uses `terraform init -backend=false`. Authenticated local checks
must use the dedicated `~/.azure-ordinus` Azure CLI profile and the intended
subscription. Production changes are applied only through the protected GitHub
workflow, not from a local CLI session.
