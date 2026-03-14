# -------------------------------------------------------------------------
# Program: main.tf
# Description: Deploy Azure Monitor alert rule with action group notifications
# Context: AZ-104 hands-on lab - Alert Notification Rate Limits (Microsoft Azure Administrator)
# Author: Greg Tate
# -------------------------------------------------------------------------
# This lab demonstrates Azure Monitor alert notification rate limits by
# creating an alert that fires every minute with email, voice, and SMS actions.
# -------------------------------------------------------------------------

# Generate random suffix for globally unique names
resource "random_string" "suffix" {
  length  = 6
  special = false
  upper   = false
}

# Local variables for naming and tagging
locals {
  resource_group_name = "az104-${var.domain}-${var.topic}-tf"

  common_tags = {
    Environment      = "Lab"
    Project          = "AZ-104"
    Domain           = title(var.domain)
    Purpose          = "Alert Notification Rate Limits"
    Owner            = var.owner
    DateCreated      = formatdate("YYYY-MM-DD", timestamp())
    DeploymentMethod = "Terraform"
  }
}

# Resource Group
resource "azurerm_resource_group" "lab" {
  name     = local.resource_group_name
  location = var.location
  tags     = local.common_tags
}

# Virtual Network (required for VM)
resource "azurerm_virtual_network" "lab" {
  name                = "vnet-lab"
  address_space       = ["10.0.0.0/16"]
  location            = azurerm_resource_group.lab.location
  resource_group_name = azurerm_resource_group.lab.name
  tags                = local.common_tags
}

# Subnet
resource "azurerm_subnet" "lab" {
  name                 = "subnet-lab"
  resource_group_name  = azurerm_resource_group.lab.name
  virtual_network_name = azurerm_virtual_network.lab.name
  address_prefixes     = ["10.0.1.0/24"]
}

# Network Interface
resource "azurerm_network_interface" "lab" {
  name                = "nic-vm-lab"
  location            = azurerm_resource_group.lab.location
  resource_group_name = azurerm_resource_group.lab.name
  tags                = local.common_tags

  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.lab.id
    private_ip_address_allocation = "Dynamic"
  }
}

# Simple VM to generate metrics for alerting
resource "azurerm_linux_virtual_machine" "lab" {
  name                            = "vm-alert-lab-${random_string.suffix.result}"
  resource_group_name             = azurerm_resource_group.lab.name
  location                        = azurerm_resource_group.lab.location
  size                            = "Standard_B1s"
  admin_username                  = "azureuser"
  admin_password                  = "P@ssw0rd1234!"
  disable_password_authentication = false
  tags                            = local.common_tags

  network_interface_ids = [
    azurerm_network_interface.lab.id,
  ]

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

# Action Group with email, voice, and SMS notifications
resource "azurerm_monitor_action_group" "alert_notifications" {
  name                = "ag-alert-notifications"
  resource_group_name = azurerm_resource_group.lab.name
  short_name          = "AlertNotif"
  tags                = local.common_tags

  # Email notification
  email_receiver {
    name                    = "email-notification"
    email_address           = var.email_address
    use_common_alert_schema = true
  }

  # SMS notification
  sms_receiver {
    name         = "sms-notification"
    country_code = var.sms_country_code
    phone_number = var.sms_phone_number
  }

  # Voice notification
  voice_receiver {
    name         = "voice-notification"
    country_code = var.voice_country_code
    phone_number = var.voice_phone_number
  }
}

# Metric Alert Rule - fires frequently to demonstrate rate limiting
# This alert fires when CPU percentage is greater than 0 (effectively always)
resource "azurerm_monitor_metric_alert" "alert1" {
  name                = "Alert1"
  resource_group_name = azurerm_resource_group.lab.name
  scopes              = [azurerm_linux_virtual_machine.lab.id]
  description         = "Alert that fires every minute to demonstrate notification rate limits"
  severity            = 3
  frequency           = "PT1M"
  window_size         = "PT1M"
  tags                = local.common_tags

  # Criteria that will fire frequently
  criteria {
    metric_namespace = "Microsoft.Compute/virtualMachines"
    metric_name      = "Percentage CPU"
    aggregation      = "Average"
    operator         = "GreaterThanOrEqual"
    threshold        = 0
  }

  action {
    action_group_id = azurerm_monitor_action_group.alert_notifications.id
  }
}
