# -------------------------------------------------------------------------
# Program: modules/compute/main.tf
# Description: Linux VMs with NICs, backend pool associations, and cloud-init
# Context: AZ-104 Lab - Troubleshoot Internal Load Balancer backend VM access
# Author: Greg Tate
# Date: 2026-02-16
# -------------------------------------------------------------------------

# Backend VM configuration map
locals {
  backend_vms = {
    "01" = { pip_id = var.pip_backend_01_id }
    "02" = { pip_id = var.pip_backend_02_id }
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

# Cloud-init for backend web server VMs
locals {
  backend_cloud_init = <<-CLOUDINIT
    #cloud-config
    package_update: true
    packages:
      - nginx
    runcmd:
      - echo "<h1>Hello from $(hostname)</h1><p>Private IP: $(hostname -I | awk '{print $1}')</p>" > /var/www/html/index.html
      - systemctl enable nginx
      - systemctl restart nginx
  CLOUDINIT

  # Cloud-init for Nginx reverse proxy VM pointing to ILB frontend
  proxy_cloud_init = <<-CLOUDINIT
    #cloud-config
    package_update: true
    packages:
      - nginx
    write_files:
      - path: /etc/nginx/sites-available/default
        content: |
          server {
              listen 80;
              server_name _;
              location / {
                  proxy_pass http://${var.ilb_frontend_ip};
                  proxy_set_header Host $host;
                  proxy_set_header X-Real-IP $remote_addr;
                  proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
              }
          }
    runcmd:
      - systemctl enable nginx
      - systemctl restart nginx
  CLOUDINIT
}

# -------------------------------------------------------------------
# Backend VMs (web servers behind the Internal Load Balancer)
# -------------------------------------------------------------------

# Network interfaces for backend VMs
resource "azurerm_network_interface" "backend" {
  for_each = local.backend_vms

  name                = "nic-backend-${each.key}"
  location            = var.location
  resource_group_name = var.resource_group_name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = var.backend_subnet_id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = each.value.pip_id
  }

  tags = var.tags
}

# Ubuntu Linux VMs for backend web servers
resource "azurerm_linux_virtual_machine" "backend" {
  for_each = local.backend_vms

  name                            = "vm-backend-${each.key}"
  location                        = var.location
  resource_group_name             = var.resource_group_name
  size                            = "Standard_B2s"
  admin_username                  = local.admin_username
  admin_password                  = local.admin_password
  disable_password_authentication = false
  custom_data                     = base64encode(local.backend_cloud_init)

  network_interface_ids = [azurerm_network_interface.backend[each.key].id]

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "0001-com-ubuntu-server-jammy"
    sku       = "22_04-lts-gen2"
    version   = "latest"
  }

  tags = var.tags
}

# Associate backend VM NICs with ILB backend pool
resource "azurerm_network_interface_backend_address_pool_association" "backend" {
  for_each = local.backend_vms

  network_interface_id    = azurerm_network_interface.backend[each.key].id
  ip_configuration_name   = "internal"
  backend_address_pool_id = var.backend_pool_id
}

# Auto-shutdown schedule for backend VMs (7:00 PM EST daily)
resource "azurerm_dev_test_global_vm_shutdown_schedule" "backend" {
  for_each = local.backend_vms

  virtual_machine_id    = azurerm_linux_virtual_machine.backend[each.key].id
  location              = var.location
  enabled               = true
  daily_recurrence_time = "1900"
  timezone              = "Eastern Standard Time"

  notification_settings {
    enabled = false
  }

  tags = var.tags
}

# -------------------------------------------------------------------
# Proxy VM (Nginx reverse proxy - demonstrates the solution)
# -------------------------------------------------------------------

# Network interface for proxy VM with static private IP
resource "azurerm_network_interface" "proxy" {
  name                = "nic-proxy-01"
  location            = var.location
  resource_group_name = var.resource_group_name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = var.proxy_subnet_id
    private_ip_address_allocation = "Static"
    private_ip_address            = "10.0.2.10"
    public_ip_address_id          = var.pip_proxy_01_id
  }

  tags = var.tags
}

# Ubuntu Linux VM for Nginx reverse proxy
resource "azurerm_linux_virtual_machine" "proxy" {
  name                            = "vm-proxy-01"
  location                        = var.location
  resource_group_name             = var.resource_group_name
  size                            = "Standard_B2s"
  admin_username                  = local.admin_username
  admin_password                  = local.admin_password
  disable_password_authentication = false
  custom_data                     = base64encode(local.proxy_cloud_init)

  network_interface_ids = [azurerm_network_interface.proxy.id]

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "0001-com-ubuntu-server-jammy"
    sku       = "22_04-lts-gen2"
    version   = "latest"
  }

  tags = var.tags
}

# Auto-shutdown schedule for proxy VM (7:00 PM EST daily)
resource "azurerm_dev_test_global_vm_shutdown_schedule" "proxy" {
  virtual_machine_id    = azurerm_linux_virtual_machine.proxy.id
  location              = var.location
  enabled               = true
  daily_recurrence_time = "1900"
  timezone              = "Eastern Standard Time"

  notification_settings {
    enabled = false
  }

  tags = var.tags
}
