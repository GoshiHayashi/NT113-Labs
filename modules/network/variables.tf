variable "resource_group_name" {
  type        = string
  description = "Name of the resource group"
}

variable "location" {
  type        = string
  description = "Azure region"
}

variable "vnet_name" {
  type        = string
  description = "Name of the Virtual Network"
}

variable "address_space" {
  type        = list(string)
  description = "Address space for the VNet"
}

variable "subnet_name" {
  type        = string
  description = "Name of the Subnet"
}

variable "subnet_prefix" {
  type        = list(string)
  description = "Address prefix for the subnet"
}

variable "nsg_name" {
  type        = string
  description = "Name of the Network Security Group"
}

variable "route_table_name" {
  type        = string
  description = "Name of the Route Table (optional)"
  default     = ""
}

variable "custom_routes" {
  type = list(object({
    name           = string
    address_prefix = string
    next_hop_type  = string
  }))
  description = "List of custom routes to add to the Route Table"
  default     = []
}
