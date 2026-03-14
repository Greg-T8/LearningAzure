# -------------------------------------------------------------------------
# Program: modules/loadbalancer/main.tf
# Description: Standard Internal Load Balancer for Private Link Service
# Context: AZ-104 Lab - Azure Private Link Service network policies
# Author: Greg Tate
# Date: 2026-02-26
# -------------------------------------------------------------------------

# Standard Internal Load Balancer (required for Private Link Service)
resource "azurerm_lb" "main" {
  name                = "lb-private-link"
  location            = var.location
  resource_group_name = var.resource_group_name
  sku                 = "Standard"

  frontend_ip_configuration {
    name                          = "frontend-ip"
    subnet_id                     = var.pls_subnet_id
    private_ip_address_allocation = "Dynamic"
  }

  tags = var.tags
}

# Backend address pool for web servers
resource "azurerm_lb_backend_address_pool" "main" {
  name            = "pool-backend"
  loadbalancer_id = azurerm_lb.main.id
}

# Health probe for HTTP traffic
resource "azurerm_lb_probe" "http" {
  name                = "probe-http"
  loadbalancer_id     = azurerm_lb.main.id
  protocol            = "Http"
  port                = 80
  request_path        = "/"
  interval_in_seconds = 5
  number_of_probes    = 2
}

# Load balancing rule for HTTP traffic
resource "azurerm_lb_rule" "http" {
  name                           = "rule-http"
  loadbalancer_id                = azurerm_lb.main.id
  protocol                       = "Tcp"
  frontend_port                  = 80
  backend_port                   = 80
  frontend_ip_configuration_name = "frontend-ip"
  backend_address_pool_ids       = [azurerm_lb_backend_address_pool.main.id]
  probe_id                       = azurerm_lb_probe.http.id
  floating_ip_enabled            = false
  idle_timeout_in_minutes        = 4
  disable_outbound_snat          = true
}
