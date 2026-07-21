variable "subscription_id" {
  type        = string
  description = "Azure subscription ID."
}

variable "location" {
  type        = string
  description = "Azure region."
  default     = "swedencentral"
}

variable "postgres_admin_username" {
  type        = string
  description = "PostgreSQL administrator username."
  default     = "medaljadmin"
}

variable "postgres_admin_password" {
  type        = string
  description = "PostgreSQL administrator password."
  sensitive   = true
}
