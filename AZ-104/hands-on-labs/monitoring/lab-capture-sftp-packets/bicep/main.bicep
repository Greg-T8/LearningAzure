// -------------------------------------------------------------------------
// Program: main.bicep
// Description: Root deployment for packet capture lab infrastructure
// Context: AZ-104 Lab - Capture SFTP Packets with Network Watcher
// Author: Greg Tate
// Date: 2026-02-27
// -------------------------------------------------------------------------

targetScope = 'subscription'

@description('AZ-104 exam domain')
@allowed(['identity', 'networking', 'storage', 'compute', 'monitoring'])
param domain string = 'monitoring'

@description('Lab topic in kebab-case')
param topic string = 'capture-sftp-packets'

@description('Azure region for resource deployment')
param location string = 'eastus'

@description('Resource owner name')
param owner string = 'Greg Tate'

@description('Static date for DateCreated tag (YYYY-MM-DD)')
param dateCreated string = '2026-02-27'

@description('VM admin username')
param adminUsername string = 'azureadmin'

@description('VM admin password')
@secure()
param adminPassword string

var resourceGroupName = 'az104-${domain}-${topic}-bicep'
var commonTags = {
  Environment: 'Lab'
  Project: 'AZ-104'
  Domain: 'Monitoring'
  Purpose: 'Capture SFTP Packets'
  Owner: owner
  DateCreated: dateCreated
  DeploymentMethod: 'Bicep'
}

resource rg 'Microsoft.Resources/resourceGroups@2024-03-01' = {
  name: resourceGroupName
  location: location
  tags: commonTags
}

module networking 'modules/networking.bicep' = {
  name: 'networking-deployment'
  scope: rg
  params: {
    location: location
    tags: commonTags
  }
}

module compute 'modules/compute.bicep' = {
  name: 'compute-deployment'
  scope: rg
  params: {
    location: location
    tags: commonTags
    subnetId: networking.outputs.subnetId
    adminUsername: adminUsername
    adminPassword: adminPassword
  }
}

@description('Resource group name')
output resourceGroupName string = rg.name

@description('Resource group location')
output resourceGroupLocation string = rg.location

@description('Virtual network name')
output vnetName string = networking.outputs.vnetName

@description('VM name')
output vmName string = compute.outputs.vmName

@description('VM ID')
output vmId string = compute.outputs.vmId

@description('Storage account name for packet captures')
output storageAccountName string = compute.outputs.storageAccountName
