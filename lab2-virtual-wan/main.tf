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

# 2. Virtual WAN & Hub
resource "azurerm_virtual_wan" "vwan" {
  name                = "vwan-lab2"
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location
  type                = "Standard"
}

resource "azurerm_virtual_hub" "hub" {
  name                = "hub-lab2"
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location
  virtual_wan_id      = azurerm_virtual_wan.vwan.id
  address_prefix      = "192.168.0.0/23"
  sku                 = "Standard"
}

resource "azurerm_virtual_hub_route_table" "rt" {
  name           = "rt-vhub-lab2"
  virtual_hub_id = azurerm_virtual_hub.hub.id

  labels = ["default"]
}

# 3. Networks
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

module "network_c" {
  source              = "../modules/network"
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location
  vnet_name           = "VNet-C"
  address_space       = ["10.2.0.0/16"]
  subnet_name         = "Subnet-C"
  subnet_prefix       = ["10.2.0.0/24"]
  nsg_name            = "NSG-C"
  route_table_name    = "RT-SubnetC"
}

# 4. VMs
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

module "vm_c" {
  source              = "../modules/vm"
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location
  subnet_id           = module.network_c.subnet_id
  vm_name             = "VM-C"
  pip_name            = "PIP-VM-C"
  nic_name            = "NIC-VM-C"
  admin_username      = var.admin_username
  admin_password      = var.admin_password
}

# 5. Virtual Hub Connections
resource "azurerm_virtual_hub_connection" "conn_a" {
  name                      = "conn-VNet-A"
  virtual_hub_id            = azurerm_virtual_hub.hub.id
  remote_virtual_network_id = module.network_a.vnet_id

  routing {
    associated_route_table_id = azurerm_virtual_hub_route_table.rt.id

    propagated_route_table {
      route_table_ids = [azurerm_virtual_hub_route_table.rt.id]
      labels          = ["default"]
    }
  }

  depends_on = [
    azurerm_virtual_hub_route_table.rt
  ]
}

resource "azurerm_virtual_hub_connection" "conn_b" {
  name                      = "conn-VNet-B"
  virtual_hub_id            = azurerm_virtual_hub.hub.id
  remote_virtual_network_id = module.network_b.vnet_id

  routing {
    associated_route_table_id = azurerm_virtual_hub_route_table.rt.id

    propagated_route_table {
      route_table_ids = [azurerm_virtual_hub_route_table.rt.id]
      labels          = ["default"]
    }
  }

  depends_on = [
    azurerm_virtual_hub_route_table.rt
  ]
}
resource "azurerm_virtual_hub_connection" "conn_c" {
  name                      = "conn-VNet-C"
  virtual_hub_id            = azurerm_virtual_hub.hub.id
  remote_virtual_network_id = module.network_c.vnet_id

  routing {
    associated_route_table_id = azurerm_virtual_hub_route_table.rt.id

    propagated_route_table {
      route_table_ids = [azurerm_virtual_hub_route_table.rt.id]
      labels          = ["default"]
    }
  }

  depends_on = [
    azurerm_virtual_hub_route_table.rt
  ]
}