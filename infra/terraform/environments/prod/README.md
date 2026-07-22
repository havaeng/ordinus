# Ordinus production infrastructure

This root module uses the AzureRM backend at `prod.tfstate`, separate from the
bootstrap root's `bootstrap.tfstate`. The state container uses Microsoft Entra
ID authentication; Storage Account keys are not used.

The root currently defines only `rg-ordinus-prod`. Its first protected GitHub
apply completed successfully. The resource group is tracked in `prod.tfstate`,
and the subsequent plan contains no changes or destroys.

CI validation uses `terraform init -backend=false`. Authenticated local checks
must use the dedicated `~/.azure-ordinus` Azure CLI profile and the intended
subscription. Production changes are applied only through the protected GitHub
workflow, not from a local CLI session.
