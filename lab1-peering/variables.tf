variable "location" {
  type        = string
  description = "The Azure Region to deploy resources"
  default     = "eastasia"
}

variable "resource_group_name" {
  type        = string
  description = "The name of the Resource Group for Lab 1"
  default     = "rg-lab1"
}

variable "admin_username" {
  type        = string
  description = "The admin username for the Virtual Machines"
  default     = "azureuser"
}

variable "admin_password" {
  type        = string
  description = "The admin password for the Virtual Machines"
  default     = "AzureP@ssw0rd123!"
}
