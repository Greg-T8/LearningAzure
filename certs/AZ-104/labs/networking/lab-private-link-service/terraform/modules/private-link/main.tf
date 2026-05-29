# -------------------------------------------------------------------------
# Program: modules/private-link/main.tf
# Description: Private Link Service and consumer Private Endpoint
# Context: AZ-104 Lab - Azure Private Link Service network policies
# Author: Greg Tate
# Date: 2026-02-26
# -------------------------------------------------------------------------

# Private Link Service connected to the Internal Load Balancer
resource "azurerm_private_link_service" "main" {
  name                = "pls-web"
  location            = var.location
  resource_group_name = var.resource_group_name

  load_balancer_frontend_ip_configuration_ids = [var.lb_frontend_ip_config_id]

  # NAT IP configuration — source IP selected from PLS subnet
  nat_ip_configuration {
    name                       = "nat-ip-primary"
    subnet_id                  = var.pls_subnet_id
    primary                    = true
    private_ip_address_version = "IPv4"
  }

  tags = var.tags
}

# Private Endpoint in consumer VNet connecting to the Private Link Service
resource "azurerm_private_endpoint" "main" {
  name                = "pe-web"
  location            = var.location
  resource_group_name = var.resource_group_name
  subnet_id           = var.pe_subnet_id

  private_service_connection {
    name                           = "pe-connection-web"
    private_connection_resource_id = azurerm_private_link_service.main.id
    is_manual_connection           = false
  }

  tags = var.tags
}
