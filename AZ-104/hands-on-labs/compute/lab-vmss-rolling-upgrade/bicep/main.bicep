// -------------------------------------------------------------------------
// Program: main.bicep
// Description: Deploy VMSS with Rolling upgrade policy, Standard LB, and networking
// Context: AZ-104 Lab - VMSS Rolling Upgrade (Microsoft Azure Administrator)
// Author: Greg Tate
// Date: 2026-02-23
// -------------------------------------------------------------------------

targetScope = 'subscription'

// -------------------------------------------------------------------------
// Parameters
// -------------------------------------------------------------------------

@description('AZ-104 exam domain')
@allowed(['identity', 'networking', 'storage', 'compute', 'monitoring'])
param domain string = 'compute'

@description('Lab topic in kebab-case')
param topic string = 'vmss-rolling-upgrade'

@description('Azure region for resources')
param location string = 'centralus'

@description('Lab owner for tagging')
param owner string = 'Greg Tate'

@description('Date created for tagging (static value, YYYY-MM-DD)')
param dateCreated string

@description('Admin username for VMSS instances')
param adminUsername string = 'azureadmin'

// -------------------------------------------------------------------------
// Local variables for naming and tagging
// -------------------------------------------------------------------------

// Resource group and resource names per governance §2
var resourceGroupName = 'az104-${domain}-${topic}-bicep'
var vnetName = 'vnet-${topic}'
var subnetName = 'snet-vmss'
var nsgName = 'nsg-vmss'
var lbName = 'lb-vmss'
var publicIpName = 'pip-lb-vmss'
var vmssName = 'vmss-rolling-upgrade'

// Common tags per governance §1.2
var commonTags = {
  Environment: 'Lab'
  Project: 'AZ-104'
  Domain: 'Compute'
  Purpose: 'VMSS Rolling Upgrade'
  Owner: owner
  DateCreated: dateCreated
  DeploymentMethod: 'Bicep'
}

// -------------------------------------------------------------------------
// Resource Group
// -------------------------------------------------------------------------

resource rg 'Microsoft.Resources/resourceGroups@2024-03-01' = {
  name: resourceGroupName
  location: location
  tags: commonTags
}

// -------------------------------------------------------------------------
// Module: Networking (VNet, Subnet, NSG)
// -------------------------------------------------------------------------

module network 'modules/network.bicep' = {
  name: 'network-deployment'
  scope: rg
  params: {
    location: location
    commonTags: commonTags
    vnetName: vnetName
    subnetName: subnetName
    nsgName: nsgName
  }
}

// -------------------------------------------------------------------------
// Module: Load Balancer (Standard LB with health probe and outbound rule)
// -------------------------------------------------------------------------

module loadbalancer 'modules/loadbalancer.bicep' = {
  name: 'loadbalancer-deployment'
  scope: rg
  params: {
    location: location
    commonTags: commonTags
    lbName: lbName
    publicIpName: publicIpName
  }
}

// -------------------------------------------------------------------------
// Module: VMSS (Rolling upgrade policy, 2 instances)
// -------------------------------------------------------------------------

module vmss 'modules/vmss.bicep' = {
  name: 'vmss-deployment'
  scope: rg
  params: {
    location: location
    commonTags: commonTags
    vmssName: vmssName
    adminUsername: adminUsername
    subnetId: network.outputs.subnetId
    backendPoolId: loadbalancer.outputs.backendPoolId
  }
}

// -------------------------------------------------------------------------
// Outputs
// -------------------------------------------------------------------------

@description('Resource group name')
output resourceGroupName string = rg.name

@description('VMSS name')
output vmssName string = vmss.outputs.vmssName

@description('Load balancer public IP address')
output lbPublicIpAddress string = loadbalancer.outputs.publicIpAddress

@description('Load balancer name')
output lbName string = lbName
