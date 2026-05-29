// -------------------------------------------------------------------------
// Program: network.bicep
// Description: Virtual network, subnet, NSG, and Bastion for VM access
// Context: AZ-104 Lab - Recover Configuration File from Azure VM Backup
// Author: Greg Tate
// Date: 2026-02-17
// -------------------------------------------------------------------------

@description('Azure region for resources')
param location string

@description('Resource tags')
param tags object

// -------------------------------------------------------------------------
// Network Security Group
// -------------------------------------------------------------------------
resource nsg 'Microsoft.Network/networkSecurityGroups@2024-05-01' = {
  name: 'nsg-file-recovery'
  location: location
  tags: tags
}

// -------------------------------------------------------------------------
// Virtual Network with subnets
// -------------------------------------------------------------------------
resource vnet 'Microsoft.Network/virtualNetworks@2024-05-01' = {
  name: 'vnet-file-recovery'
  location: location
  tags: tags
  properties: {
    addressSpace: {
      addressPrefixes: [
        '10.0.0.0/16'
      ]
    }
    subnets: [
      {
        name: 'snet-default'
        properties: {
          addressPrefix: '10.0.0.0/24'
          networkSecurityGroup: {
            id: nsg.id
          }
        }
      }
      {
        name: 'AzureBastionSubnet'
        properties: {
          addressPrefix: '10.0.1.0/26'
        }
      }
    ]
  }
}

// -------------------------------------------------------------------------
// Bastion - Developer SKU for secure VM access
// -------------------------------------------------------------------------
resource bastion 'Microsoft.Network/bastionHosts@2024-05-01' = {
  name: 'bas-file-recovery'
  location: location
  tags: tags
  sku: {
    name: 'Developer'
  }
  properties: {
    virtualNetwork: {
      id: vnet.id
    }
  }
}

// -------------------------------------------------------------------------
// Outputs
// -------------------------------------------------------------------------
@description('Subnet resource ID for VM deployment')
output subnetId string = vnet.properties.subnets[0].id

@description('Virtual network name')
output vnetName string = vnet.name

@description('Bastion name')
output bastionName string = bastion.name
