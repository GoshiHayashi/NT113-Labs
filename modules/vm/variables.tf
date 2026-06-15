variable "resource_group_name" {
  type        = string
  description = "Name of the resource group"
}

variable "location" {
  type        = string
  description = "Azure region"
}

variable "subnet_id" {
  type        = string
  description = "The Resource ID of the subnet where the VM's NIC will reside"
}

variable "vm_name" {
  type        = string
  description = "Name of the Virtual Machine"
}

variable "pip_name" {
  type        = string
  description = "Name of the Public IP resource"
}

variable "nic_name" {
  type        = string
  description = "Name of the Network Interface resource"
}

variable "admin_username" {
  type        = string
  description = "The admin username for the Virtual Machine"
  default     = "azureuser"
}

variable "admin_password" {
  type        = string
  description = "The admin password for the Virtual Machine"
  default     = "AzureP@ssw0rd123!"
}

variable "vm_size" {
  type        = string
  description = "The size of the Virtual Machine"
  default     = "Standard_B1s"
}
