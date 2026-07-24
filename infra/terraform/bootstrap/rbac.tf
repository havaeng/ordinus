data "azurerm_subscription" "current" {}

locals {
  production_resource_group_id     = "${data.azurerm_subscription.current.id}/resourceGroups/${var.production_resource_group_name}"
  production_container_registry_id = "${local.production_resource_group_id}/providers/Microsoft.ContainerRegistry/registries/${var.production_container_registry_name}"
}

resource "azurerm_role_assignment" "github_plan_subscription_reader" {
  scope                = data.azurerm_subscription.current.id
  role_definition_name = "Reader"
  principal_id         = azurerm_user_assigned_identity.github_plan.principal_id
  principal_type       = "ServicePrincipal"
}

resource "azurerm_role_assignment" "github_plan_state_reader" {
  scope                = azurerm_storage_account.tfstate.id
  role_definition_name = "Storage Blob Data Reader"
  principal_id         = azurerm_user_assigned_identity.github_plan.principal_id
  principal_type       = "ServicePrincipal"
}

resource "azurerm_role_assignment" "github_apply_production_contributor" {
  scope                = local.production_resource_group_id
  role_definition_name = "Contributor"
  principal_id         = azurerm_user_assigned_identity.github_apply.principal_id
  principal_type       = "ServicePrincipal"
}

resource "azurerm_role_assignment" "github_apply_state_contributor" {
  scope                = azurerm_storage_account.tfstate.id
  role_definition_name = "Storage Blob Data Contributor"
  principal_id         = azurerm_user_assigned_identity.github_apply.principal_id
  principal_type       = "ServicePrincipal"
}

resource "azurerm_role_assignment" "github_image_publisher_acr_push" {
  scope                = local.production_container_registry_id
  role_definition_name = "AcrPush"
  principal_id         = azurerm_user_assigned_identity.github_image_publisher.principal_id
  principal_type       = "ServicePrincipal"
}
