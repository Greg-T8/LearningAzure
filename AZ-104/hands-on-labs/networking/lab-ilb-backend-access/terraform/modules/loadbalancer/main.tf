# -------------------------------------------------------------------------
# Program: modules/loadbalancer/main.tf
# Description: Internal Standard Load Balancer with backend pool and rules
# Context: AZ-104 Lab - Troubleshoot Internal Load Balancer backend VM access
# Author: Greg Tate
# Date: 2026-02-16
# -------------------------------------------------------------------------

# Internal Standard Load Balancer with private frontend IP
resource "azurerm_lb" "internal" {
  name                = "lb-internal"
  location            = var.location
  resource_group_name = var.resource_group_name
  sku                 = "Standard"

  # Private frontend IP on the backend subnet
  frontend_ip_configuration {
    name                          = "frontend-internal"
    subnet_id                     = var.backend_subnet_id
    private_ip_address_allocation = "Static"
    private_ip_address            = "10.0.1.10"
  }

  tags = var.tags
}

# Backend address pool for web server VMs
resource "azurerm_lb_backend_address_pool" "backend" {
  name            = "pool-backend"
  loadbalancer_id = azurerm_lb.internal.id
}

# Health probe for TCP port 80
resource "azurerm_lb_probe" "tcp" {
  name                = "probe-tcp-80"
  loadbalancer_id     = azurerm_lb.internal.id
  protocol            = "Tcp"
  port                = 80
  interval_in_seconds = 5
  number_of_probes    = 2
}

# Load balancing rule for HTTP traffic
resource "azurerm_lb_rule" "http" {
  name                           = "rule-http-80"
  loadbalancer_id                = azurerm_lb.internal.id
  protocol                       = "Tcp"
  frontend_port                  = 80
  backend_port                   = 80
  frontend_ip_configuration_name = "frontend-internal"
  backend_address_pool_ids       = [azurerm_lb_backend_address_pool.backend.id]
  probe_id                       = azurerm_lb_probe.tcp.id
  idle_timeout_in_minutes        = 4
}
