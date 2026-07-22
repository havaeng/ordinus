output "resource_group_name" {
  description = "Name of the resource group containing Terraform state."
  value       = azurerm_resource_group.tfstate.name
}

output "storage_account_name" {
  description = "Name of the Storage Account containing Terraform state."
  value       = azurerm_storage_account.tfstate.name
}

output "container_name" {
  description = "Name of the blob container containing Terraform state files."
  value       = azurerm_storage_container.tfstate.name
}

