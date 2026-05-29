// -------------------------------------------------------------------------
// Program: network.bicep
// Description: VNet, Subnet, and NSG for VMSS rolling upgrade lab
// Context: AZ-104 Lab - VMSS Rolling Upgrade (Microsoft Azure Administrator)
// Author: Greg Tate
// Date: 2026-02-23
// -------------------------------------------------------------------------

// Parameters
@description('Azure region for resource deployment')
param location string

@description('Common tags for all resources')
param commonTags object

@description('Virtual network name')
param vnetName string

@description('Subnet name')
param subnetName string

@description('Network security group name')
param nsgName string

// -------------------------------------------------------------------------
// Network Security Group — allow HTTP for LB health probes and web traffic
// -------------------------------------------------------------------------

resource nsg 'Microsoft.Network/networkSecurityGroups@2024-05-01' = {
  name: nsgName
  location: location
  tags: commonTags
  properties: {
    securityRules: [
      {
        name: 'AllowHTTPInbound'
        properties: {
          priority: 100
          direction: 'Inbound'
          access: 'Allow'
          protocol: 'Tcp'
          sourcePortRange: '*'
          destinationPortRange: '80'
          sourceAddressPrefix: '*'
          destinationAddressPrefix: '*'
        }
      }
    ]
  }
}

// -------------------------------------------------------------------------
// Virtual Network with VMSS subnet
// -------------------------------------------------------------------------

resource vnet 'Microsoft.Network/virtualNetworks@2024-05-01' = {
  name: vnetName
  location: location
  tags: commonTags
  properties: {
    addressSpace: {
      addressPrefixes: [
        '10.0.0.0/16'
      ]
    }
    subnets: [
      {
        name: subnetName
        properties: {
          addressPrefix: '10.0.1.0/24'
          networkSecurityGroup: {
            id: nsg.id
          }
        }
      }
    ]
  }
}

// -------------------------------------------------------------------------
// Outputs
// -------------------------------------------------------------------------

@description('Subnet resource ID for VMSS NIC configuration')
output subnetId string = vnet.properties.subnets[0].id

@description('VNet resource ID')
output vnetId string = vnet.id

@description('NSG resource ID')
output nsgId string = nsg.id
