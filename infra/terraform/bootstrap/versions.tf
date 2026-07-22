terraform {
  required_version = "~> 1.14.0"

  backend "azurerm" {
    resource_group_name  = "rg-ordinus-tfstate"
    storage_account_name = "stordinustfstate696163"
    container_name       = "tfstate"
    key                  = "bootstrap.tfstate"
    use_azuread_auth     = true
  }

  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 4.0"
    }
  }
}
