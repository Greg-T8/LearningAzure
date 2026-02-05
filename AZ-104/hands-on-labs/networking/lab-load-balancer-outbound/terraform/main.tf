# -------------------------------------------------------------------------
# Program: main.tf
# Description: Core infrastructure for the load balancer outbound lab
# Context: AZ-104 Lab - Load balancer outbound traffic
# Author: Greg Tate
# Date: 2026-02-05
# -------------------------------------------------------------------------

# Local values for naming and tags
locals {
  resource_group_name = "az104-${var.domain}-${var.topic}-tf"
  common_tags = {
    Environment      = "Lab"
    Project          = "AZ-104"
    Domain           = title(var.domain)
    Purpose          = replace(title(replace(var.topic, "-", " ")), "  ", " ")
    Owner            = var.owner
    DateCreated      = formatdate("YYYY-MM-DD", timestamp())
    DeploymentMethod = "Terraform"
  }
  vm_instances = {
    vm01 = {
      name          = "vm-web-01"
      computer_name = "vm01"
      nic_name      = "nic-vm-01"
      has_public_ip = true
    }
    vm02 = {
      name          = "vm-web-02"
      computer_name = "vm02"
      nic_name      = "nic-vm-02"
      has_public_ip = false
    }
    vm03 = {
      name          = "vm-web-03"
      computer_name = "vm03"
      nic_name      = "nic-vm-03"
      has_public_ip = false
    }
  }
}

# Resource group for all lab resources
resource "azurerm_resource_group" "lab" {
  name     = local.resource_group_name
  location = var.location
  tags     = local.common_tags
}

# Virtual network for the web tier
resource "azurerm_virtual_network" "lab" {
  name                = "vnet-lb"
  location            = azurerm_resource_group.lab.location
  resource_group_name = azurerm_resource_group.lab.name
  address_space       = ["10.10.0.0/16"]
  tags                = local.common_tags
}

# Subnet for the web tier
resource "azurerm_subnet" "web" {
  name                 = "snet-web"
  resource_group_name  = azurerm_resource_group.lab.name
  virtual_network_name = azurerm_virtual_network.lab.name
  address_prefixes     = ["10.10.1.0/24"]
}

# Network security group for VM access
resource "azurerm_network_security_group" "web" {
  name                = "nsg-web"
  location            = azurerm_resource_group.lab.location
  resource_group_name = azurerm_resource_group.lab.name
  tags                = local.common_tags
}

# Allow RDP to the web tier
resource "azurerm_network_security_rule" "rdp" {
  name                        = "allow-rdp"
  priority                    = 100
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "Tcp"
  source_port_range           = "*"
  destination_port_range      = "3389"
  source_address_prefix       = var.allowed_rdp_cidr
  destination_address_prefix  = "*"
  resource_group_name         = azurerm_resource_group.lab.name
  network_security_group_name = azurerm_network_security_group.web.name
}

# Allow load balancer health probes and traffic
resource "azurerm_network_security_rule" "lb" {
  name                        = "allow-lb"
  priority                    = 110
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "Tcp"
  source_port_range           = "*"
  destination_port_range      = "80"
  source_address_prefix       = "AzureLoadBalancer"
  destination_address_prefix  = "*"
  resource_group_name         = azurerm_resource_group.lab.name
  network_security_group_name = azurerm_network_security_group.web.name
}

# Associate NSG to the web subnet
resource "azurerm_subnet_network_security_group_association" "web" {
  subnet_id                 = azurerm_subnet.web.id
  network_security_group_id = azurerm_network_security_group.web.id
}

# Public IP for VM01
resource "azurerm_public_ip" "vm01" {
  name                = "pip-vm01"
  location            = azurerm_resource_group.lab.location
  resource_group_name = azurerm_resource_group.lab.name
  allocation_method   = "Static"
  sku                 = "Standard"
  tags                = local.common_tags
}

# Public IP for load balancer frontend IP02
resource "azurerm_public_ip" "lb_02" {
  name                = "pip-lb-02"
  location            = azurerm_resource_group.lab.location
  resource_group_name = azurerm_resource_group.lab.name
  allocation_method   = "Static"
  sku                 = "Standard"
  tags                = local.common_tags
}

# Public IP for load balancer frontend IP03
resource "azurerm_public_ip" "lb_03" {
  name                = "pip-lb-03"
  location            = azurerm_resource_group.lab.location
  resource_group_name = azurerm_resource_group.lab.name
  allocation_method   = "Static"
  sku                 = "Standard"
  tags                = local.common_tags
}

# Standard load balancer with two public frontends
resource "azurerm_lb" "lab" {
  name                = "lb-public"
  location            = azurerm_resource_group.lab.location
  resource_group_name = azurerm_resource_group.lab.name
  sku                 = "Standard"
  tags                = local.common_tags

  # Frontend IP configuration for IP02
  frontend_ip_configuration {
    name                 = "fe-ip02"
    public_ip_address_id = azurerm_public_ip.lb_02.id
  }

  # Frontend IP configuration for IP03
  frontend_ip_configuration {
    name                 = "fe-ip03"
    public_ip_address_id = azurerm_public_ip.lb_03.id
  }
}

# Backend pool for the web VMs
resource "azurerm_lb_backend_address_pool" "web" {
  name            = "bep-web"
  loadbalancer_id = azurerm_lb.lab.id
}

# Health probe for TCP 80
resource "azurerm_lb_probe" "http" {
  name            = "probe-http"
  loadbalancer_id = azurerm_lb.lab.id
  protocol        = "Tcp"
  port            = 80
}

# Load balancing rule for TCP traffic on IP02
resource "azurerm_lb_rule" "tcp" {
  name                           = "rule-tcp-80"
  loadbalancer_id                = azurerm_lb.lab.id
  protocol                       = "Tcp"
  frontend_port                  = 80
  backend_port                   = 80
  frontend_ip_configuration_name = "fe-ip02"
  backend_address_pool_ids       = [azurerm_lb_backend_address_pool.web.id]
  probe_id                       = azurerm_lb_probe.http.id
}

# Outbound rule using IP02 for SNAT
resource "azurerm_lb_outbound_rule" "outbound_ip02" {
  name                    = "outbound-ip02"
  loadbalancer_id         = azurerm_lb.lab.id
  protocol                = "All"
  backend_address_pool_id = azurerm_lb_backend_address_pool.web.id
  frontend_ip_configuration {
    name = "fe-ip02"
  }
}

# Outbound rule using IP03 for SNAT
resource "azurerm_lb_outbound_rule" "outbound_ip03" {
  name                    = "outbound-ip03"
  loadbalancer_id         = azurerm_lb.lab.id
  protocol                = "All"
  backend_address_pool_id = azurerm_lb_backend_address_pool.web.id
  frontend_ip_configuration {
    name = "fe-ip03"
  }
}

# Network interfaces for the web VMs
resource "azurerm_network_interface" "vm" {
  for_each            = local.vm_instances
  name                = each.value.nic_name
  location            = azurerm_resource_group.lab.location
  resource_group_name = azurerm_resource_group.lab.name
  tags                = local.common_tags

  # NIC IP configuration
  ip_configuration {
    name                          = "ipconfig-${each.key}"
    subnet_id                     = azurerm_subnet.web.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = each.value.has_public_ip ? azurerm_public_ip.vm01.id : null
  }
}

# Associate NICs with the load balancer backend pool
resource "azurerm_network_interface_backend_address_pool_association" "web" {
  for_each                = local.vm_instances
  network_interface_id    = azurerm_network_interface.vm[each.key].id
  ip_configuration_name   = "ipconfig-${each.key}"
  backend_address_pool_id = azurerm_lb_backend_address_pool.web.id
}

# Windows virtual machines for the web tier
resource "azurerm_windows_virtual_machine" "web" {
  for_each            = local.vm_instances
  name                = each.value.name
  computer_name       = each.value.computer_name
  location            = azurerm_resource_group.lab.location
  resource_group_name = azurerm_resource_group.lab.name
  size                = var.vm_size
  admin_username      = var.admin_username
  admin_password      = var.admin_password
  tags                = local.common_tags

  # VM network interface attachment
  network_interface_ids = [azurerm_network_interface.vm[each.key].id]

  # OS disk settings
  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  # Windows image selection
  source_image_reference {
    publisher = "MicrosoftWindowsServer"
    offer     = "WindowsServer"
    sku       = "2019-Datacenter"
    version   = "latest"
  }
}

# Install IIS for load balancer health checks
resource "azurerm_virtual_machine_extension" "iis" {
  for_each             = local.vm_instances
  name                 = "ext-iis-${each.key}"
  virtual_machine_id   = azurerm_windows_virtual_machine.web[each.key].id
  publisher            = "Microsoft.Compute"
  type                 = "CustomScriptExtension"
  type_handler_version = "1.10"
  tags                 = local.common_tags

  # Install IIS for load balancer health checks
  settings = jsonencode({
    commandToExecute = "powershell -ExecutionPolicy Bypass -Command \"Install-WindowsFeature -Name Web-Server\""
  })
}
