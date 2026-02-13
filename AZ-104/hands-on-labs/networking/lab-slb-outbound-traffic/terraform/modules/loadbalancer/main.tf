# -------------------------------------------------------------------------
# Program: modules/loadbalancer/main.tf
# Description: Standard Load Balancer with inbound/outbound pools and rules
# Context: AZ-104 Lab - Configure Standard Load Balancer outbound traffic and IP allocation
# Author: Greg Tate
# Date: 2026-02-13
# -------------------------------------------------------------------------

# Standard Load Balancer with two frontend IP configurations
resource "azurerm_lb" "main" {
  name                = "lb-public"
  location            = var.location
  resource_group_name = var.resource_group_name
  sku                 = "Standard"

  # Frontend IP configuration for IP02
  frontend_ip_configuration {
    name                 = "frontend-ip-02"
    public_ip_address_id = var.lb_pip_01_id
  }

  # Frontend IP configuration for IP03
  frontend_ip_configuration {
    name                 = "frontend-ip-03"
    public_ip_address_id = var.lb_pip_02_id
  }

  tags = var.tags
}

# Backend address pool for inbound load balancing (all 3 VMs)
resource "azurerm_lb_backend_address_pool" "inbound" {
  name            = "pool-inbound"
  loadbalancer_id = azurerm_lb.main.id
}

# Backend address pool for outbound rules (VM02 and VM03 only)
resource "azurerm_lb_backend_address_pool" "outbound" {
  name            = "pool-outbound"
  loadbalancer_id = azurerm_lb.main.id
}

# Health probe for TCP port 80
resource "azurerm_lb_probe" "tcp" {
  name                = "probe-tcp-80"
  loadbalancer_id     = azurerm_lb.main.id
  protocol            = "Tcp"
  port                = 80
  interval_in_seconds = 5
  number_of_probes    = 2
}

# Load balancing rule for TCP traffic only (disable outbound SNAT)
resource "azurerm_lb_rule" "tcp" {
  name                           = "rule-tcp-80"
  loadbalancer_id                = azurerm_lb.main.id
  protocol                       = "Tcp"
  frontend_port                  = 80
  backend_port                   = 80
  frontend_ip_configuration_name = "frontend-ip-02"
  backend_address_pool_ids       = [azurerm_lb_backend_address_pool.inbound.id]
  probe_id                       = azurerm_lb_probe.tcp.id
  disable_outbound_snat          = true
  idle_timeout_in_minutes        = 4
}

# Outbound rule for TCP using both frontend IPs (IP02 and IP03)
resource "azurerm_lb_outbound_rule" "tcp_outbound" {
  name                    = "outbound-rule-tcp"
  loadbalancer_id         = azurerm_lb.main.id
  protocol                = "Tcp"
  backend_address_pool_id = azurerm_lb_backend_address_pool.outbound.id

  # Use IP02 for outbound SNAT
  frontend_ip_configuration {
    name = "frontend-ip-02"
  }

  # Use IP03 for outbound SNAT
  frontend_ip_configuration {
    name = "frontend-ip-03"
  }
}
