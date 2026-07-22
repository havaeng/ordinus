# Ordinus production infrastructure

This root module uses the AzureRM backend at `prod.tfstate`, separate from the
bootstrap root's `bootstrap.tfstate`. The state container uses Microsoft Entra
ID authentication; Storage Account keys are not used.

The root currently defines only `rg-ordinus-prod`. A verified plan contains one
create action for that resource group and no changes or destroys. Do not apply
the production root until GitHub OIDC identities, least-privilege RBAC, a
pull-request plan workflow, and a protected apply workflow are in place.

CI validation uses `terraform init -backend=false`. Authenticated local checks
must use the dedicated `~/.azure-ordinus` Azure CLI profile and the intended
subscription.

