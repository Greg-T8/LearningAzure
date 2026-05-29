# -------------------------------------------------------------------------
# Program: main.tf
# Description: Linux VMs and auto-shutdown schedules for metrics batch API lab
# Context: AZ-104 Lab - Azure Monitor Metrics Batch API (Microsoft Azure Administrator)
# Author: Greg Tate
# Date: 2026-02-20
# -------------------------------------------------------------------------

# Generate lab-safe admin password
resource "random_password" "admin" {
  length           = 16
  special          = true
  override_special = "!@#$%"
}

# Linux VMs for metric generation
resource "azurerm_linux_virtual_machine" "this" {
  count                           = var.vm_count
  name                            = "vm-${var.topic}-${format("%03d", count.index + 1)}"
  resource_group_name             = var.resource_group_name
  location                        = var.location
  size                            = "Standard_B1s"
  admin_username                  = "azureuser"
  admin_password                  = random_password.admin.result
  disable_password_authentication = false
  tags                            = var.common_tags

  network_interface_ids = [var.nic_ids[count.index]]

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "0001-com-ubuntu-server-jammy"
    sku       = "22_04-lts"
    version   = "latest"
  }
}

# Auto-shutdown schedule (8:00 AM Central Time)
resource "azurerm_dev_test_global_vm_shutdown_schedule" "this" {
  count              = var.vm_count
  virtual_machine_id = azurerm_linux_virtual_machine.this[count.index].id
  location           = var.location
  enabled            = true

  daily_recurrence_time = "0800"
  timezone              = "Central Standard Time"

  notification_settings {
    enabled = false
  }
}
