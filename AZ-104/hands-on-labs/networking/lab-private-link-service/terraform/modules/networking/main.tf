# -------------------------------------------------------------------------
# Program: modules/networking/main.tf
# Description: Provider VNet, Consumer VNet, subnets, and NSG resources
# Context: AZ-104 Lab - Azure Private Link Service network policies
# Author: Greg Tate
# Date: 2026-02-26
# -------------------------------------------------------------------------

# Provider virtual network (service provider side)
resource "azurerm_virtual_network" "provider" {
  name                = "vnet-provider"
  location            = var.location
  resource_group_name = var.resource_group_name
  address_space       = ["10.1.0.0/16"]
  tags                = var.tags
}

# Backend subnet for VM workloads
resource "azurerm_subnet" "backend" {
  name                 = "snet-backend"
  resource_group_name  = var.resource_group_name
  virtual_network_name = azurerm_virtual_network.provider.name
  address_prefixes     = ["10.1.1.0/24"]
}

# Private Link Service subnet with network policies disabled
resource "azurerm_subnet" "pls" {
  name                 = "snet-pls"
  resource_group_name  = var.resource_group_name
  virtual_network_name = azurerm_virtual_network.provider.name
  address_prefixes     = ["10.1.4.0/24"]

  private_link_service_network_policies_enabled = false
}

# Consumer virtual network (service consumer side)
resource "azurerm_virtual_network" "consumer" {
  name                = "vnet-consumer"
  location            = var.location
  resource_group_name = var.resource_group_name
  address_space       = ["10.2.0.0/16"]
  tags                = var.tags
}

# Private Endpoint subnet in consumer VNet
resource "azurerm_subnet" "pe" {
  name                 = "snet-pe"
  resource_group_name  = var.resource_group_name
  virtual_network_name = azurerm_virtual_network.consumer.name
  address_prefixes     = ["10.2.1.0/24"]
}

# Network security group for backend subnet (demonstrates ACL filtering)
resource "azurerm_network_security_group" "backend" {
  name                = "nsg-backend"
  location            = var.location
  resource_group_name = var.resource_group_name
  tags                = var.tags

  # Allow HTTP inbound for web application
  security_rule {
    name                       = "Allow-HTTP"
    priority                   = 100
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "80"
    source_address_prefix      = "VirtualNetwork"
    destination_address_prefix = "*"
  }

  # Allow SSH inbound from VNet (for Bastion connectivity)
  security_rule {
    name                       = "Allow-SSH"
    priority                   = 110
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "22"
    source_address_prefix      = "VirtualNetwork"
    destination_address_prefix = "*"
  }
}

# Associate NSG with backend subnet
resource "azurerm_subnet_network_security_group_association" "backend" {
  subnet_id                 = azurerm_subnet.backend.id
  network_security_group_id = azurerm_network_security_group.backend.id
}
