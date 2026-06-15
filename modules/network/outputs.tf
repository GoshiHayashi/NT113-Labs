output "vnet_id" {
  value       = azurerm_virtual_network.vnet.id
  description = "The Resource ID of the Virtual Network"
}

output "vnet_name" {
  value       = azurerm_virtual_network.vnet.name
  description = "The Name of the Virtual Network"
}

output "subnet_id" {
  value       = azurerm_subnet.subnet.id
  description = "The Resource ID of the Subnet"
}

output "nsg_id" {
  value       = azurerm_network_security_group.nsg.id
  description = "The Resource ID of the Network Security Group"
}

output "nsg_name" {
  value       = azurerm_network_security_group.nsg.name
  description = "The Name of the Network Security Group"
}
