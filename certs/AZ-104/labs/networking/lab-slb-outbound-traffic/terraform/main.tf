# -------------------------------------------------------------------------
# Program: main.tf
# Description: Orchestrate Standard Load Balancer with outbound traffic and IP allocation
# Context: AZ-104 Lab - Configure Standard Load Balancer outbound traffic and IP allocation
# Author: Greg Tate
# Date: 2026-02-13
# -------------------------------------------------------------------------

# Common local values for tags and naming
locals {
  resource_group_name = "az104-networking-slb-outbound-traffic-tf"

  common_tags = {
    Environment      = "Lab"
    Project          = "AZ-104"
    Domain           = "Networking"
    Purpose          = "Standard Load Balancer Outbound Traffic"
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

# Deploy networking components (VNet, Subnet, NSG, Public IPs)
module "networking" {
  source = "./modules/networking"

  resource_group_name = azurerm_resource_group.main.name
  location            = azurerm_resource_group.main.location
  tags                = local.common_tags
}

# Deploy Standard Load Balancer with frontend IPs and rules
module "loadbalancer" {
  source = "./modules/loadbalancer"

  resource_group_name = azurerm_resource_group.main.name
  location            = azurerm_resource_group.main.location
  lb_pip_01_id        = module.networking.lb_pip_01_id
  lb_pip_02_id        = module.networking.lb_pip_02_id
  tags                = local.common_tags
}

# Deploy Windows VMs with NIC and backend pool associations
module "compute" {
  source = "./modules/compute"

  resource_group_name = azurerm_resource_group.main.name
  location            = azurerm_resource_group.main.location
  subnet_id           = module.networking.subnet_id
  vm_pip_id           = module.networking.vm_pip_id
  inbound_pool_id     = module.loadbalancer.inbound_pool_id
  outbound_pool_id    = module.loadbalancer.outbound_pool_id
  tags                = local.common_tags
}
