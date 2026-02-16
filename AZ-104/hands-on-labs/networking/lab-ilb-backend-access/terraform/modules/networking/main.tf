# -------------------------------------------------------------------------
# Program: modules/networking/main.tf
# Description: VNet, Subnets, NSGs, and Public IP resources
# Context: AZ-104 Lab - Troubleshoot Internal Load Balancer backend VM access
# Author: Greg Tate
# Date: 2026-02-16
# -------------------------------------------------------------------------

# Virtual network for load balancer lab
resource "azurerm_virtual_network" "main" {
  name                = "vnet-ilb-backend"
  location            = var.location
  resource_group_name = var.resource_group_name
  address_space       = ["10.0.0.0/16"]
  tags                = var.tags
}

# Subnet for backend VMs behind the ILB
resource "azurerm_subnet" "backend" {
  name                 = "snet-backend"
  resource_group_name  = var.resource_group_name
  virtual_network_name = azurerm_virtual_network.main.name
  address_prefixes     = ["10.0.1.0/24"]
}

# Subnet for the Nginx reverse proxy VM
resource "azurerm_subnet" "proxy" {
  name                 = "snet-proxy"
  resource_group_name  = var.resource_group_name
  virtual_network_name = azurerm_virtual_network.main.name
  address_prefixes     = ["10.0.2.0/24"]
}

# Network security group for backend subnet
resource "azurerm_network_security_group" "backend" {
  name                = "nsg-backend"
  location            = var.location
  resource_group_name = var.resource_group_name
  tags                = var.tags

  # Allow SSH inbound for management
  security_rule {
    name                       = "Allow-SSH"
    priority                   = 100
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "22"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }

  # Allow HTTP inbound for web traffic and health probes
  security_rule {
    name                       = "Allow-HTTP"
    priority                   = 110
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "80"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }
}

# Network security group for proxy subnet
resource "azurerm_network_security_group" "proxy" {
  name                = "nsg-proxy"
  location            = var.location
  resource_group_name = var.resource_group_name
  tags                = var.tags

  # Allow SSH inbound for management
  security_rule {
    name                       = "Allow-SSH"
    priority                   = 100
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "22"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }

  # Allow HTTP inbound from VNet for proxy traffic
  security_rule {
    name                       = "Allow-HTTP"
    priority                   = 110
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "80"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }
}

# Associate NSG with backend subnet
resource "azurerm_subnet_network_security_group_association" "backend" {
  subnet_id                 = azurerm_subnet.backend.id
  network_security_group_id = azurerm_network_security_group.backend.id
}

# Associate NSG with proxy subnet
resource "azurerm_subnet_network_security_group_association" "proxy" {
  subnet_id                 = azurerm_subnet.proxy.id
  network_security_group_id = azurerm_network_security_group.proxy.id
}

# Public IP for vm-backend-01 (SSH management access)
resource "azurerm_public_ip" "backend_01" {
  name                = "pip-backend-01"
  location            = var.location
  resource_group_name = var.resource_group_name
  allocation_method   = "Static"
  sku                 = "Standard"
  tags                = var.tags
}

# Public IP for vm-backend-02 (SSH management access)
resource "azurerm_public_ip" "backend_02" {
  name                = "pip-backend-02"
  location            = var.location
  resource_group_name = var.resource_group_name
  allocation_method   = "Static"
  sku                 = "Standard"
  tags                = var.tags
}

# Public IP for vm-proxy-01 (SSH management access)
resource "azurerm_public_ip" "proxy_01" {
  name                = "pip-proxy-01"
  location            = var.location
  resource_group_name = var.resource_group_name
  allocation_method   = "Static"
  sku                 = "Standard"
  tags                = var.tags
}
