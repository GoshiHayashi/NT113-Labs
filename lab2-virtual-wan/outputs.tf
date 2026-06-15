output "vm_a_public_ip" {
  value       = module.vm_a.public_ip
  description = "Public IP address of VM-A"
}

output "vm_a_private_ip" {
  value       = module.vm_a.private_ip
  description = "Private IP address of VM-A"
}

output "vm_b_public_ip" {
  value       = module.vm_b.public_ip
  description = "Public IP address of VM-B"
}

output "vm_b_private_ip" {
  value       = module.vm_b.private_ip
  description = "Private IP address of VM-B"
}

output "vm_c_public_ip" {
  value       = module.vm_c.public_ip
  description = "Public IP address of VM-C"
}

output "vm_c_private_ip" {
  value       = module.vm_c.private_ip
  description = "Private IP address of VM-C"
}

output "ssh_command_vm_a" {
  value       = "ssh ${var.admin_username}@${module.vm_a.public_ip}"
  description = "SSH command to connect to VM-A"
}

output "ssh_command_vm_b" {
  value       = "ssh ${var.admin_username}@${module.vm_b.public_ip}"
  description = "SSH command to connect to VM-B"
}

output "ssh_command_vm_c" {
  value       = "ssh ${var.admin_username}@${module.vm_c.public_ip}"
  description = "SSH command to connect to VM-C"
}
