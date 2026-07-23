data "azurerm_subscription" "current" {}

locals {
  production_resource_group_id = "${data.azurerm_subscription.current.id}/resourceGroups/${var.production_resource_group_name}"
}

resource "azurerm_role_definition" "production_resource_group_creator" {
  name        = "Ordinus Production Resource Group Creator"
  scope       = data.azurerm_subscription.current.id
  description = "Allows the Ordinus production workflow to read and create resource groups, but not delete them or manage their contents."

  permissions {
    actions = [
      "Microsoft.Resources/subscriptions/read",
      "Microsoft.Resources/subscriptions/locations/read",
      "Microsoft.Resources/subscriptions/resourceGroups/read",
      "Microsoft.Resources/subscriptions/resourceGroups/write",
    ]
    not_actions = []
  }

  assignable_scopes = [
    data.azurerm_subscription.current.id,
  ]
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

resource "azurerm_role_assignment" "github_apply_resource_group_creator" {
  scope              = data.azurerm_subscription.current.id
  role_definition_id = azurerm_role_definition.production_resource_group_creator.role_definition_resource_id
  principal_id       = azurerm_user_assigned_identity.github_apply.principal_id
  principal_type     = "ServicePrincipal"
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
