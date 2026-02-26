# -------------------------------------------------------------------------
# Program: modules/compute/main.tf
# Description: Linux VM with nginx web server and Bastion Developer SKU
# Context: AZ-104 Lab - Azure Private Link Service network policies
# Author: Greg Tate
# Date: 2026-02-26
# -------------------------------------------------------------------------

# Local values for compute configuration
locals {
  admin_username = "azureadmin"

  cloud_init = <<-EOF
    #cloud-config
    package_update: true
    packages:
      - nginx
    runcmd:
      - [ bash, -lc, 'mkdir -p /var/www/html' ]
      - [ bash, -lc, 'echo "<h1>Hello from $(hostname)</h1><p>Private IP: $(hostname -I | awk ''{print $1}'')</p><p>Private Link Service backend</p>" > /var/www/html/index.html' ]
      - [ systemctl, enable, nginx ]
      - [ systemctl, restart, nginx ]
  EOF
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

# Network interface for the backend VM
resource "azurerm_network_interface" "vm" {
  name                = "nic-vm-web"
  location            = var.location
  resource_group_name = var.resource_group_name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = var.backend_subnet_id
    private_ip_address_allocation = "Dynamic"
  }

  tags = var.tags
}

# Linux VM running nginx as the backend web service
resource "azurerm_linux_virtual_machine" "vm" {
  name                            = "vm-web"
  location                        = var.location
  resource_group_name             = var.resource_group_name
  size                            = "Standard_B2s"
  admin_username                  = local.admin_username
  admin_password                  = local.admin_password
  disable_password_authentication = false
  custom_data                     = base64encode(local.cloud_init)

  network_interface_ids = [azurerm_network_interface.vm.id]

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "ubuntu-24_04-lts"
    sku       = "server"
    version   = "latest"
  }

  tags = var.tags
}

# Associate VM NIC with load balancer backend pool
resource "azurerm_network_interface_backend_address_pool_association" "vm" {
  network_interface_id    = azurerm_network_interface.vm.id
  ip_configuration_name   = "internal"
  backend_address_pool_id = var.backend_pool_id
}

# Auto-shutdown schedule for cost control
resource "azurerm_dev_test_global_vm_shutdown_schedule" "vm" {
  virtual_machine_id = azurerm_linux_virtual_machine.vm.id
  location           = var.location
  enabled            = true

  daily_recurrence_time = "0800"
  timezone              = "Central Standard Time"

  notification_settings {
    enabled = false
  }

  tags = var.tags
}

# Azure Bastion Developer SKU for secure VM access
resource "azurerm_bastion_host" "main" {
  name                = "bastion-private-link"
  location            = var.location
  resource_group_name = var.resource_group_name
  sku                 = "Developer"
  virtual_network_id  = var.provider_vnet_id

  tags = var.tags
}
