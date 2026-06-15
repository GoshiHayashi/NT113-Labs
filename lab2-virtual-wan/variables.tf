variable "location" {
  type        = string
  description = "The Azure Region to deploy resources"
  default     = "southeastasia"
}

variable "resource_group_name" {
  type        = string
  description = "The name of the Resource Group for Lab 2"
  default     = "rg-lab2"
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
