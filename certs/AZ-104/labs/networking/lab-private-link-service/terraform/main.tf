# -------------------------------------------------------------------------
# Program: main.tf
# Description: Orchestrate Private Link Service with provider/consumer VNets
# Context: AZ-104 Lab - Azure Private Link Service network policies
# Author: Greg Tate
# Date: 2026-02-26
# -------------------------------------------------------------------------

# Common local values for tags and naming
locals {
  resource_group_name = "az104-networking-private-link-service-tf"

  common_tags = {
    Environment      = "Lab"
    Project          = "AZ-104"
    Domain           = "Networking"
    Purpose          = "Private Link Service"
    Owner            = var.owner
    DateCreated      = var.date_created
    DeploymentMethod = "Terraform"
  }
}

# Create the resource group for all lab resources
resource "azurerm_resource_group" "main" {
  name     = local.resource_group_name
  location = var.location
  tags     = local.common_tags
}

# Deploy networking components (provider VNet, consumer VNet, subnets, NSG)
module "networking" {
  source = "./modules/networking"

  resource_group_name = azurerm_resource_group.main.name
  location            = azurerm_resource_group.main.location
  tags                = local.common_tags
}

# Deploy Standard Internal Load Balancer for Private Link Service
module "loadbalancer" {
  source = "./modules/loadbalancer"

  resource_group_name = azurerm_resource_group.main.name
  location            = azurerm_resource_group.main.location
  pls_subnet_id       = module.networking.pls_subnet_id
  tags                = local.common_tags
}

# Deploy Linux VM with nginx as backend service
# depends_on ensures all subnets complete before Bastion creation
# (Bastion Developer SKU requires VNet in "Succeeded" state, not "Updating")
module "compute" {
  source = "./modules/compute"

  resource_group_name = azurerm_resource_group.main.name
  location            = azurerm_resource_group.main.location
  backend_subnet_id   = module.networking.backend_subnet_id
  backend_pool_id     = module.loadbalancer.backend_pool_id
  provider_vnet_id    = module.networking.provider_vnet_id
  tags                = local.common_tags

  depends_on = [module.networking]
}

# Deploy Private Link Service and consumer Private Endpoint
module "private_link" {
  source = "./modules/private-link"

  resource_group_name      = azurerm_resource_group.main.name
  location                 = azurerm_resource_group.main.location
  pls_subnet_id            = module.networking.pls_subnet_id
  pe_subnet_id             = module.networking.pe_subnet_id
  lb_frontend_ip_config_id = module.loadbalancer.frontend_ip_config_id
  tags                     = local.common_tags
}
