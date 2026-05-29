# -------------------------------------------------------------------------
# Program: main.tf
# Description: Virtual network, subnet, NSG, and NICs for metrics batch API lab
# Context: AZ-104 Lab - Azure Monitor Metrics Batch API (Microsoft Azure Administrator)
# Author: Greg Tate
# Date: 2026-02-20
# -------------------------------------------------------------------------

# Virtual network for lab VMs
resource "azurerm_virtual_network" "this" {
  name                = "vnet-${var.topic}"
  location            = var.location
  resource_group_name = var.resource_group_name
  address_space       = ["10.0.0.0/16"]
  tags                = var.common_tags
}

# Subnet for VM NICs
resource "azurerm_subnet" "this" {
  name                 = "snet-${var.topic}"
  resource_group_name  = var.resource_group_name
  virtual_network_name = azurerm_virtual_network.this.name
  address_prefixes     = ["10.0.1.0/24"]
}

# Network security group with default deny inbound
resource "azurerm_network_security_group" "this" {
  name                = "nsg-${var.topic}"
  location            = var.location
  resource_group_name = var.resource_group_name
  tags                = var.common_tags
}

# Associate NSG to subnet
resource "azurerm_subnet_network_security_group_association" "this" {
  subnet_id                 = azurerm_subnet.this.id
  network_security_group_id = azurerm_network_security_group.this.id
}

# Network interfaces for each VM
resource "azurerm_network_interface" "this" {
  count               = var.vm_count
  name                = "nic-${var.topic}-${format("%03d", count.index + 1)}"
  location            = var.location
  resource_group_name = var.resource_group_name
  tags                = var.common_tags

  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.this.id
    private_ip_address_allocation = "Dynamic"
  }
}
