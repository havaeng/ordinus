variable "resource_group_name" {
  description = "Name of the resource group dedicated to Terraform state."
  type        = string
  default     = "rg-ordinus-tfstate"
}

variable "storage_account_name" {
  description = "Globally unique name of the Storage Account used for Terraform state."
  type        = string

  validation {
    condition     = can(regex("^[a-z0-9]{3,24}$", var.storage_account_name))
    error_message = "The storage account name must contain 3-24 lowercase letters or digits."
  }
}

variable "state_administrator_principal_id" {
  description = "Object ID of the Entra user allowed to administer Terraform state blobs."
  type        = string
}

variable "github_repository" {
  description = "GitHub repository allowed to request Azure OIDC tokens, in owner/name format."
  type        = string
  default     = "havaeng/ordinus"
}

variable "github_plan_environment" {
  description = "Protected GitHub environment used by the production plan workflow."
  type        = string
  default     = "production-plan"
}

variable "github_apply_environment" {
  description = "Protected GitHub environment used by the production apply workflow."
  type        = string
  default     = "production"
}

variable "production_resource_group_name" {
  description = "Name of the existing production resource group managed by the apply identity."
  type        = string
  default     = "rg-ordinus-prod"
}

variable "container_name" {
  description = "Name of the private blob container used for Terraform state files."
  type        = string
  default     = "tfstate"
}

variable "location" {
  description = "Azure region for the Terraform state resources."
  type        = string
  default     = "swedencentral"
}

variable "tags" {
  description = "Tags applied to the Terraform state resources."
  type        = map(string)
  default = {
    environment = "shared"
    managed-by  = "terraform"
    project     = "ordinus"
    purpose     = "terraform-state"
  }
}
