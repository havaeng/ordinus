variable "resource_group_name" {
  description = "Name of the resource group that will contain the Ordinus production backend."
  type        = string
}

variable "location" {
  description = "Azure region for the production environment."
  type        = string
  default     = "swedencentral"
}

variable "tags" {
  description = "Tags applied to resources in the production environment."
  type        = map(string)
  default = {
    environment = "prod"
    managed-by  = "terraform"
    project     = "ordinus"
  }
}
