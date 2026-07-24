resource "azurerm_user_assigned_identity" "github_plan" {
  name                = "id-ordinus-terraform-plan"
  resource_group_name = azurerm_resource_group.tfstate.name
  location            = azurerm_resource_group.tfstate.location
  tags = merge(var.tags, {
    purpose = "github-oidc"
  })
}

resource "azurerm_user_assigned_identity" "github_apply" {
  name                = "id-ordinus-terraform-apply"
  resource_group_name = azurerm_resource_group.tfstate.name
  location            = azurerm_resource_group.tfstate.location
  tags = merge(var.tags, {
    purpose = "github-oidc"
  })
}

resource "azurerm_user_assigned_identity" "github_image_publisher" {
  name                = "id-ordinus-backend-image-publisher"
  resource_group_name = azurerm_resource_group.tfstate.name
  location            = azurerm_resource_group.tfstate.location
  tags = merge(var.tags, {
    purpose = "github-oidc-image-publisher"
  })
}

resource "azurerm_federated_identity_credential" "github_plan" {
  name                      = "fic-github-production-plan"
  user_assigned_identity_id = azurerm_user_assigned_identity.github_plan.id
  audience                  = ["api://AzureADTokenExchange"]
  issuer                    = "https://token.actions.githubusercontent.com"
  subject                   = "repo:${var.github_repository}:environment:${var.github_plan_environment}"
}

resource "azurerm_federated_identity_credential" "github_apply" {
  name                      = "fic-github-production-apply"
  user_assigned_identity_id = azurerm_user_assigned_identity.github_apply.id
  audience                  = ["api://AzureADTokenExchange"]
  issuer                    = "https://token.actions.githubusercontent.com"
  subject                   = "repo:${var.github_repository}:environment:${var.github_apply_environment}"
}

resource "azurerm_federated_identity_credential" "github_image_publisher" {
  name                      = "fic-github-production-images"
  user_assigned_identity_id = azurerm_user_assigned_identity.github_image_publisher.id
  audience                  = ["api://AzureADTokenExchange"]
  issuer                    = "https://token.actions.githubusercontent.com"
  subject                   = "repo:${var.github_repository}:environment:${var.github_image_environment}"
}
