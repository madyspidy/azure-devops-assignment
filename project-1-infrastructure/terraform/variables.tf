variable "location" {
  description = "The Azure region where resources will be deployed."
  type        = string
  default     = "Central India"
}

variable "project_name" {
  description = "The name of the project."
  type        = string
  default     = "8byte_assignment"
}

variable "vm_admin_password" {
  description = "Administrator password for the Linux VM"
  type        = string
  sensitive   = true
}

variable "db_admin_password" {
  description = "Administrator password for PostgreSQL"
  type        = string
  sensitive   = true
}