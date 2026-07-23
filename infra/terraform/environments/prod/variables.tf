variable "resource_group_name" {
  description = "Name of the resource group that will contain the Ordinus production backend."
  type        = string
}

variable "location" {
  description = "Azure region for the production environment."
  type        = string
  default     = "swedencentral"
}

variable "application_storage_account_name" {
  description = "Globally unique name of the Storage Account used for Ordinus application blobs."
  type        = string
  default     = "stordinusprod696163"

  validation {
    condition     = can(regex("^[a-z0-9]{3,24}$", var.application_storage_account_name))
    error_message = "The application Storage Account name must contain 3-24 lowercase letters or digits."
  }
}

variable "container_registry_name" {
  description = "Globally unique name of the Azure Container Registry used for Ordinus backend images."
  type        = string
  default     = "acrordinusprod696163"

  validation {
    condition     = can(regex("^[a-z0-9]{5,50}$", var.container_registry_name))
    error_message = "The Container Registry name must contain 5-50 lowercase letters or digits."
  }
}

variable "monthly_budget_amount" {
  description = "Monthly cost budget for the Ordinus production resource group, in the subscription billing currency."
  type        = number
  default     = 300

  validation {
    condition     = var.monthly_budget_amount > 0
    error_message = "The monthly budget amount must be greater than zero."
  }
}

variable "budget_start_date" {
  description = "First day of the month when the production budget starts, as an RFC3339 timestamp."
  type        = string
  default     = "2026-08-01T00:00:00Z"

  validation {
    condition     = can(regex("^\\d{4}-\\d{2}-01T00:00:00Z$", var.budget_start_date))
    error_message = "The budget start date must be the first day of a month in the form YYYY-MM-01T00:00:00Z."
  }
}

variable "budget_contact_emails" {
  description = "Email addresses that receive Ordinus production budget notifications."
  type        = list(string)
  default     = ["info@medalj.com"]

  validation {
    condition = (
      length(var.budget_contact_emails) > 0 &&
      alltrue([
        for email in var.budget_contact_emails :
        can(regex("^[^@\\s]+@[^@\\s]+\\.[^@\\s]+$", email))
      ])
    )
    error_message = "At least one valid budget notification email address is required."
  }
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
