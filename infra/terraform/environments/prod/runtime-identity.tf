resource "azurerm_user_assigned_identity" "backend_runtime" {
  name                = "id-ordinus-backend-runtime"
  resource_group_name = azurerm_resource_group.this.name
  location            = azurerm_resource_group.this.location

  tags = merge(var.tags, {
    purpose = "backend-runtime"
  })
}
