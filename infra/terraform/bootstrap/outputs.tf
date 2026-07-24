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

output "github_plan_client_id" {
  description = "Client ID used by the GitHub production plan workflow."
  value       = azurerm_user_assigned_identity.github_plan.client_id
}

output "github_apply_client_id" {
  description = "Client ID used by the GitHub production apply workflow."
  value       = azurerm_user_assigned_identity.github_apply.client_id
}

output "github_image_publisher_client_id" {
  description = "Client ID used by the GitHub backend image publishing workflow."
  value       = azurerm_user_assigned_identity.github_image_publisher.client_id
}

output "tenant_id" {
  description = "Azure tenant ID used by GitHub OIDC authentication."
  value       = azurerm_user_assigned_identity.github_apply.tenant_id
}

output "subscription_id" {
  description = "Azure subscription ID targeted by the infrastructure workflows."
  value       = data.azurerm_subscription.current.subscription_id
}
