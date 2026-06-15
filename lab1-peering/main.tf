terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.0"
    }
  }
}

provider "azurerm" {
  skip_provider_registration = true
  subscription_id            = "7205434b-cd26-4e71-a450-7e0539fde09e"
  features {}
}

# 1. Resource Group
resource "azurerm_resource_group" "rg" {
  name     = var.resource_group_name
  location = var.location
}

# 2. Networks
module "network_a" {
  source              = "../modules/network"
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location
  vnet_name           = "VNet-A"
  address_space       = ["10.0.0.0/16"]
  subnet_name         = "Subnet-A"
  subnet_prefix       = ["10.0.0.0/24"]
  nsg_name            = "NSG-A"
  route_table_name    = "RT-SubnetA"
}

module "network_b" {
  source              = "../modules/network"
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location
  vnet_name           = "VNet-B"
  address_space       = ["10.1.0.0/16"]
  subnet_name         = "Subnet-B"
  subnet_prefix       = ["10.1.0.0/24"]
  nsg_name            = "NSG-B"
  route_table_name    = "RT-SubnetB"
}

# 3. VMs
module "vm_a" {
  source              = "../modules/vm"
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location
  subnet_id           = module.network_a.subnet_id
  vm_name             = "VM-A"
  pip_name            = "PIP-VM-A"
  nic_name            = "NIC-VM-A"
  admin_username      = var.admin_username
  admin_password      = var.admin_password
}

module "vm_b" {
  source              = "../modules/vm"
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location
  subnet_id           = module.network_b.subnet_id
  vm_name             = "VM-B"
  pip_name            = "PIP-VM-B"
  nic_name            = "NIC-VM-B"
  admin_username      = var.admin_username
  admin_password      = var.admin_password
}

# 4. VNet Peering (Both ways)
resource "azurerm_virtual_network_peering" "peering_a_to_b" {
  name                         = "Peering-A-to-B"
  resource_group_name          = azurerm_resource_group.rg.name
  virtual_network_name         = module.network_a.vnet_name
  remote_virtual_network_id    = module.network_b.vnet_id
  allow_virtual_network_access = true
  allow_forwarded_traffic      = true
}

resource "azurerm_virtual_network_peering" "peering_b_to_a" {
  name                         = "Peering-B-to-A"
  resource_group_name          = azurerm_resource_group.rg.name
  virtual_network_name         = module.network_b.vnet_name
  remote_virtual_network_id    = module.network_a.vnet_id
  allow_virtual_network_access = true
  allow_forwarded_traffic      = true
}
