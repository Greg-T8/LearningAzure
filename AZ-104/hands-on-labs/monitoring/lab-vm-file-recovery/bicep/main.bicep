// -------------------------------------------------------------------------
// Program: main.bicep
// Description: Entry point - creates resource group and deploys VM with Recovery Services vault
// Context: AZ-104 Lab - Recover Configuration File from Azure VM Backup
// Author: Greg Tate
// Date: 2026-02-17
// -------------------------------------------------------------------------

targetScope = 'subscription'

@description('AZ-104 exam domain')
@allowed(['identity', 'networking', 'storage', 'compute', 'monitoring'])
param domain string = 'monitoring'

@description('Lab topic in kebab-case')
param topic string = 'vm-file-recovery'

@description('Azure region for resources')
param location string = 'eastus'

@description('Lab owner for tagging')
param owner string = 'Greg Tate'

@description('Date created for tagging')
param dateCreated string = '2026-02-17'

@description('VM admin username')
param adminUsername string = 'azureadmin'

@description('VM admin password')
@secure()
param adminPassword string = 'AzureLab2026!'

// -------------------------------------------------------------------------
// Local variables for naming and tagging
// -------------------------------------------------------------------------
var resourceGroupName = 'az104-${domain}-${topic}-bicep'

var commonTags = {
  Environment: 'Lab'
  Project: 'AZ-104'
  Domain: 'Monitoring'
  Purpose: 'VM File Recovery'
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
// Deploy networking resources
// -------------------------------------------------------------------------
module network 'modules/network.bicep' = {
  scope: rg
  name: 'network-deployment'
  params: {
    location: location
    tags: commonTags
  }
}

// -------------------------------------------------------------------------
// Deploy VM resources
// -------------------------------------------------------------------------
module vm 'modules/vm.bicep' = {
  scope: rg
  name: 'vm-deployment'
  params: {
    location: location
    tags: commonTags
    subnetId: network.outputs.subnetId
    adminUsername: adminUsername
    adminPassword: adminPassword
  }
}

// -------------------------------------------------------------------------
// Deploy Recovery Services vault and backup policy
// -------------------------------------------------------------------------
module recovery 'modules/recovery.bicep' = {
  scope: rg
  name: 'recovery-deployment'
  params: {
    location: location
    tags: commonTags
    vmId: vm.outputs.vmId
    vmName: vm.outputs.vmName
    resourceGroupName: resourceGroupName
  }
}

// -------------------------------------------------------------------------
// Outputs
// -------------------------------------------------------------------------
@description('Resource group name')
output resourceGroupName string = rg.name

@description('Resource group ID')
output resourceGroupId string = rg.id

@description('Location')
output location string = rg.location

@description('VM name')
output vmName string = vm.outputs.vmName

@description('VM ID')
output vmId string = vm.outputs.vmId

@description('Recovery Services vault name')
output vaultName string = recovery.outputs.vaultName

@description('Backup policy name')
output backupPolicyName string = recovery.outputs.backupPolicyName
