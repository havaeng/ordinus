output "resource_group_id" {
  description = "Resource ID of the production resource group."
  value       = azurerm_resource_group.this.id
}

output "resource_group_name" {
  description = "Name of the production resource group."
  value       = azurerm_resource_group.this.name
}
