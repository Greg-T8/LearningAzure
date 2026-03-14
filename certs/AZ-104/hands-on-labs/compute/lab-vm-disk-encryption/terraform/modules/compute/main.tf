# -------------------------------------------------------------------------
# Program: main.tf (compute module)
# Description: VNet, Subnet, NIC, and Windows VM for disk encryption lab
# Context: AZ-104 Lab - VM Disk Encryption with Key Vault
# Author: Greg Tate
# Date: 2026-02-22
# -------------------------------------------------------------------------

# Virtual network for the VM
resource "azurerm_virtual_network" "lab" {
  name                = "vnet-${var.topic}"
  location            = var.location
  resource_group_name = var.resource_group_name
  address_space       = ["10.0.0.0/16"]
  tags                = var.tags
}

# Subnet for the VM
resource "azurerm_subnet" "vm" {
  name                 = "snet-vm"
  resource_group_name  = var.resource_group_name
  virtual_network_name = azurerm_virtual_network.lab.name
  address_prefixes     = ["10.0.1.0/24"]
}

# Network interface (no public IP — access via Bastion or Cloud Shell)
resource "azurerm_network_interface" "vm" {
  name                = "nic-${var.topic}"
  location            = var.location
  resource_group_name = var.resource_group_name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.vm.id
    private_ip_address_allocation = "Dynamic"
  }

  tags = var.tags
}

# Generate a secure admin password
resource "random_password" "admin" {
  length           = 16
  special          = true
  override_special = "!@#$%"
}

# Windows VM for disk encryption testing
resource "azurerm_windows_virtual_machine" "lab" {
  name                = "vm-disk-enc"
  location            = var.location
  resource_group_name = var.resource_group_name
  size                = "Standard_B2s"
  admin_username      = "azureadmin"
  admin_password      = random_password.admin.result

  network_interface_ids = [
    azurerm_network_interface.vm.id,
  ]

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "MicrosoftWindowsServer"
    offer     = "WindowsServer"
    sku       = "2022-datacenter-g2"
    version   = "latest"
  }

  tags = var.tags
}

# Auto-shutdown schedule per Governance-Lab.md §3.4
resource "azurerm_dev_test_global_vm_shutdown_schedule" "lab" {
  virtual_machine_id = azurerm_windows_virtual_machine.lab.id
  location           = var.location
  enabled            = true

  daily_recurrence_time = "0800"
  timezone              = "Central Standard Time"

  notification_settings {
    enabled = false
  }

  tags = var.tags
}
