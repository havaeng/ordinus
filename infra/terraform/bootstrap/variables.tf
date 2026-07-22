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
