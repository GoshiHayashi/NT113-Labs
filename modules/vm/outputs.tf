output "vm_id" {
  value       = azurerm_linux_virtual_machine.vm.id
  description = "The Resource ID of the Virtual Machine"
}

output "public_ip" {
  value       = azurerm_public_ip.pip.ip_address
  description = "The Public IP address of the Virtual Machine"
}

output "private_ip" {
  value       = azurerm_linux_virtual_machine.vm.private_ip_address
  description = "The Private IP address of the Virtual Machine"
}
