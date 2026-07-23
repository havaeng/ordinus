resource "azurerm_container_registry" "application" {
  name                = var.container_registry_name
  resource_group_name = azurerm_resource_group.this.name
  location            = azurerm_resource_group.this.location

  sku                           = "Basic"
  admin_enabled                 = false
  public_network_access_enabled = true

  tags = merge(var.tags, {
    purpose = "backend-container-images"
  })
}
