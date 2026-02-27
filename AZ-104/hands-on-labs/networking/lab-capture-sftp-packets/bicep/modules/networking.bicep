// -------------------------------------------------------------------------
// Program: networking.bicep
// Description: Deploy virtual network, subnet, and network security group
// Context: AZ-104 Lab - Capture SFTP Packets with Network Watcher
// Author: Greg Tate
// Date: 2026-02-27
// -------------------------------------------------------------------------

@description('Azure region for resources')
param location string

@description('Resource tags')
param tags object

resource nsg 'Microsoft.Network/networkSecurityGroups@2024-05-01' = {
  name: 'nsg-capture-sftp-packets'
  location: location
  tags: tags
  properties: {
    securityRules: [
      {
        name: 'Allow-SSH-From-VNet'
        properties: {
          priority: 300
          protocol: 'Tcp'
          access: 'Allow'
          direction: 'Inbound'
          sourceAddressPrefix: 'VirtualNetwork'
          sourcePortRange: '*'
          destinationAddressPrefix: '*'
          destinationPortRange: '22'
        }
      }
    ]
  }
}

resource vnet 'Microsoft.Network/virtualNetworks@2024-05-01' = {
  name: 'vnet-capture-sftp-packets'
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
        name: 'snet-capture-sftp-packets'
        properties: {
          addressPrefix: '10.0.0.0/24'
          networkSecurityGroup: {
            id: nsg.id
          }
        }
      }
    ]
  }
}

@description('Virtual network name')
output vnetName string = vnet.name

@description('Subnet resource ID')
output subnetId string = vnet.properties.subnets[0].id

@description('Network security group name')
output nsgName string = nsg.name
