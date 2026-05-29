// -------------------------------------------------------------------------
// Program: networking.bicep
// Description: Deploy regional virtual networks and subnets for two VMs
// Context: AZ-104 Lab - Enable Boot Diagnostics for Azure VMs (Microsoft Azure Administrator)
// Author: Greg Tate
// Date: 2026-02-28
// -------------------------------------------------------------------------

@description('Common tags applied to all taggable resources')
param commonTags object

resource centralVnet 'Microsoft.Network/virtualNetworks@2024-05-01' = {
  name: 'vnet-boot-centralus'
  location: 'centralus'
  tags: commonTags
  properties: {
    addressSpace: {
      addressPrefixes: [
        '10.10.0.0/16'
      ]
    }
    subnets: [
      {
        name: 'snet-vm'
        properties: {
          addressPrefix: '10.10.1.0/24'
        }
      }
    ]
  }
}

resource eastVnet 'Microsoft.Network/virtualNetworks@2024-05-01' = {
  name: 'vnet-boot-eastus'
  location: 'eastus'
  tags: commonTags
  properties: {
    addressSpace: {
      addressPrefixes: [
        '10.20.0.0/16'
      ]
    }
    subnets: [
      {
        name: 'snet-vm'
        properties: {
          addressPrefix: '10.20.1.0/24'
        }
      }
    ]
  }
}

@description('Central US subnet resource ID for vm-boot-1')
output centralSubnetId string = centralVnet.properties.subnets[0].id

@description('East US subnet resource ID for vm-boot-2')
output eastSubnetId string = eastVnet.properties.subnets[0].id
