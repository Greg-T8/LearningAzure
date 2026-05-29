// -------------------------------------------------------------------------
// Program: main.bicep
// Description: Root orchestration for boot diagnostics storage compatibility lab
// Context: AZ-104 Lab - Enable Boot Diagnostics for Azure VMs (Microsoft Azure Administrator)
// Author: Greg Tate
// Date: 2026-02-28
// -------------------------------------------------------------------------

targetScope = 'subscription'

@description('AZ-104 exam domain')
@allowed([
  'compute'
])
param domain string = 'compute'

@description('Lab topic in kebab-case')
param topic string = 'enable-boot-diagnostics'

@description('Azure region for deployment metadata')
param location string = 'eastus'

@description('Lab owner for resource tagging')
param owner string = 'Greg Tate'

@description('Date created for tagging (static value, YYYY-MM-DD)')
param dateCreated string = '2026-02-28'

@description('Administrator username for both virtual machines')
param adminUsername string = 'azureadmin'

@description('Administrator password for both virtual machines')
@secure()
param adminPassword string

var resourceGroupName = 'az104-${domain}-${topic}-bicep'

var commonTags = {
  Environment: 'Lab'
  Project: 'AZ-104'
  Domain: 'Compute'
  Purpose: 'Enable Boot Diagnostics'
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
    commonTags: commonTags
  }
}

module storage 'modules/storage.bicep' = {
  name: 'storage-deployment'
  scope: rg
  params: {
    commonTags: commonTags
  }
}

module compute 'modules/compute.bicep' = {
  name: 'compute-deployment'
  scope: rg
  params: {
    commonTags: commonTags
    adminUsername: adminUsername
    adminPassword: adminPassword
    centralSubnetId: networking.outputs.centralSubnetId
    eastSubnetId: networking.outputs.eastSubnetId
  }
}

@description('Resource group name')
output resourceGroupName string = rg.name

@description('Virtual machine 1 name')
output vm1Name string = compute.outputs.vm1Name

@description('Virtual machine 2 name')
output vm2Name string = compute.outputs.vm2Name

@description('Storage account for vm1 boot diagnostics')
output storageForVm1 string = storage.outputs.storage3Name

@description('Storage account for vm2 boot diagnostics')
output storageForVm2 string = storage.outputs.storage2Name
