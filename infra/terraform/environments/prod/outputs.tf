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

output "application_storage_account_id" {
  description = "Resource ID of the Storage Account used for Ordinus application blobs."
  value       = azurerm_storage_account.application.id
}

output "application_storage_account_name" {
  description = "Name of the Storage Account used for Ordinus application blobs."
  value       = azurerm_storage_account.application.name
}

output "application_blob_endpoint" {
  description = "Primary Blob endpoint of the Ordinus application Storage Account."
  value       = azurerm_storage_account.application.primary_blob_endpoint
}

output "image_container_names" {
  description = "Names of the private containers for submitted and published images."
  value = {
    submissions = azurerm_storage_container.image_submissions.name
    published   = azurerm_storage_container.published_images.name
  }
}

output "container_registry_id" {
  description = "Resource ID of the Azure Container Registry used for Ordinus backend images."
  value       = azurerm_container_registry.application.id
}

output "container_registry_name" {
  description = "Name of the Azure Container Registry used for Ordinus backend images."
  value       = azurerm_container_registry.application.name
}

output "container_registry_login_server" {
  description = "Login server of the Azure Container Registry used for Ordinus backend images."
  value       = azurerm_container_registry.application.login_server
}
