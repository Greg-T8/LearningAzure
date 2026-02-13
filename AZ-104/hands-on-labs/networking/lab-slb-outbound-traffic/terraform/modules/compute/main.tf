# -------------------------------------------------------------------------
# Program: modules/compute/main.tf
# Description: Windows VMs with NICs and backend pool associations
# Context: AZ-104 Lab - Configure Standard Load Balancer outbound traffic and IP allocation
# Author: Greg Tate
# Date: 2026-02-13
# -------------------------------------------------------------------------

# VM configuration map defining per-VM settings
locals {
  vms = {
    "01" = {
      public_ip_id       = var.vm_pip_id
      join_outbound_pool = false
    }
    "02" = {
      public_ip_id       = null
      join_outbound_pool = true
    }
    "03" = {
      public_ip_id       = null
      join_outbound_pool = true
    }
  }

  admin_username = "azureadmin"
}

# Generate random suffix for admin password
resource "random_integer" "password_suffix" {
  min = 1000
  max = 9999
}

# Build admin password from random suffix
locals {
  admin_password = "AzureLab${random_integer.password_suffix.result}!"
}

# Network interfaces for each VM
resource "azurerm_network_interface" "vm" {
  for_each = local.vms

  name                = "nic-vm-web-${each.key}"
  location            = var.location
  resource_group_name = var.resource_group_name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = var.subnet_id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = each.value.public_ip_id
  }

  tags = var.tags
}

# Windows VMs for web front-end
resource "azurerm_windows_virtual_machine" "vm" {
  for_each = local.vms

  name                = "vm-web-${each.key}"
  location            = var.location
  resource_group_name = var.resource_group_name
  size                = "Standard_B2s"
  admin_username      = local.admin_username
  admin_password      = local.admin_password

  network_interface_ids = [azurerm_network_interface.vm[each.key].id]

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "MicrosoftWindowsServer"
    offer     = "WindowsServer"
    sku       = "2022-datacenter-azure-edition"
    version   = "latest"
  }

  tags = var.tags
}

# Associate all VM NICs with inbound backend pool
resource "azurerm_network_interface_backend_address_pool_association" "inbound" {
  for_each = local.vms

  network_interface_id    = azurerm_network_interface.vm[each.key].id
  ip_configuration_name   = "internal"
  backend_address_pool_id = var.inbound_pool_id
}

# Associate VM02 and VM03 NICs with outbound backend pool (VM01 excluded - has instance PIP)
resource "azurerm_network_interface_backend_address_pool_association" "outbound" {
  for_each = { for k, v in local.vms : k => v if v.join_outbound_pool }

  network_interface_id    = azurerm_network_interface.vm[each.key].id
  ip_configuration_name   = "internal"
  backend_address_pool_id = var.outbound_pool_id
}

# Install IIS on all VMs for web application hosting
resource "azurerm_virtual_machine_extension" "iis" {
  for_each = local.vms

  name                 = "install-iis"
  virtual_machine_id   = azurerm_windows_virtual_machine.vm[each.key].id
  publisher            = "Microsoft.Compute"
  type                 = "CustomScriptExtension"
  type_handler_version = "1.10"

  settings = jsonencode({
    commandToExecute = "powershell -ExecutionPolicy Unrestricted Install-WindowsFeature -Name Web-Server -IncludeManagementTools"
  })

  tags = var.tags
}

# Auto-shutdown schedule for cost management (7:00 PM EST daily)
resource "azurerm_dev_test_global_vm_shutdown_schedule" "shutdown" {
  for_each = local.vms

  virtual_machine_id    = azurerm_windows_virtual_machine.vm[each.key].id
  location              = var.location
  enabled               = true
  daily_recurrence_time = "1900"
  timezone              = "Eastern Standard Time"

  notification_settings {
    enabled = false
  }

  tags = var.tags
}
