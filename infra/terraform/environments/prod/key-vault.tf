data "azurerm_client_config" "current" {}

resource "azurerm_key_vault" "application" {
  name                = var.key_vault_name
  resource_group_name = azurerm_resource_group.this.name
  location            = azurerm_resource_group.this.location
  tenant_id           = data.azurerm_client_config.current.tenant_id
  sku_name            = "standard"

  rbac_authorization_enabled      = true
  public_network_access_enabled   = true
  purge_protection_enabled        = true
  soft_delete_retention_days      = 30
  enabled_for_deployment          = false
  enabled_for_disk_encryption     = false
  enabled_for_template_deployment = false

  tags = merge(var.tags, {
    purpose = "application-secrets"
  })
}
