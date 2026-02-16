# -------------------------------------------------------------------------
# Program: main.tf
# Description: Orchestrate Internal Load Balancer with backend VMs and proxy
# Context: AZ-104 Lab - Troubleshoot Internal Load Balancer backend VM access
# Author: Greg Tate
# Date: 2026-02-16
# -------------------------------------------------------------------------

# Common local values for tags and naming
locals {
  resource_group_name = "az104-networking-ilb-backend-access-tf"

  common_tags = {
    Environment      = "Lab"
    Project          = "AZ-104"
    Domain           = "Networking"
    Purpose          = "Internal Load Balancer Backend Access"
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

# Deploy networking components (VNet, Subnets, NSGs, Public IPs)
module "networking" {
  source = "./modules/networking"

  resource_group_name = azurerm_resource_group.main.name
  location            = azurerm_resource_group.main.location
  tags                = local.common_tags
}

# Deploy Internal Load Balancer with backend pool and rules
module "loadbalancer" {
  source = "./modules/loadbalancer"

  resource_group_name = azurerm_resource_group.main.name
  location            = azurerm_resource_group.main.location
  backend_subnet_id   = module.networking.backend_subnet_id
  tags                = local.common_tags
}

# Deploy Linux VMs with NICs, backend pool associations, and cloud-init
module "compute" {
  source = "./modules/compute"

  resource_group_name = azurerm_resource_group.main.name
  location            = azurerm_resource_group.main.location
  backend_subnet_id   = module.networking.backend_subnet_id
  proxy_subnet_id     = module.networking.proxy_subnet_id
  pip_backend_01_id   = module.networking.pip_backend_01_id
  pip_backend_02_id   = module.networking.pip_backend_02_id
  pip_proxy_01_id     = module.networking.pip_proxy_01_id
  backend_pool_id     = module.loadbalancer.backend_pool_id
  ilb_frontend_ip     = module.loadbalancer.frontend_ip_address
  tags                = local.common_tags
}
