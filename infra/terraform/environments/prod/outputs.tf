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

output "backend_runtime_identity_id" {
  description = "Resource ID of the user-assigned identity used by the Ordinus backend runtime."
  value       = azurerm_user_assigned_identity.backend_runtime.id
}

output "backend_runtime_identity_client_id" {
  description = "Client ID of the user-assigned identity used by the Ordinus backend runtime."
  value       = azurerm_user_assigned_identity.backend_runtime.client_id
}

output "backend_runtime_identity_principal_id" {
  description = "Principal ID used when assigning Azure roles to the Ordinus backend runtime."
  value       = azurerm_user_assigned_identity.backend_runtime.principal_id
}

output "key_vault_id" {
  description = "Resource ID of the Key Vault used for Ordinus backend secrets."
  value       = azurerm_key_vault.application.id
}

output "key_vault_name" {
  description = "Name of the Key Vault used for Ordinus backend secrets."
  value       = azurerm_key_vault.application.name
}

output "key_vault_uri" {
  description = "Data-plane URI of the Key Vault used for Ordinus backend secrets."
  value       = azurerm_key_vault.application.vault_uri
}
