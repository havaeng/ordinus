output "resource_group_id" {
  description = "Resource ID of the production resource group."
  value       = azurerm_resource_group.this.id
}

output "resource_group_name" {
  description = "Name of the production resource group."
  value       = azurerm_resource_group.this.name
}

output "monthly_budget_id" {
  description = "ID of the monthly Ordinus production resource-group budget."
  value       = azurerm_consumption_budget_resource_group.monthly.id
}
