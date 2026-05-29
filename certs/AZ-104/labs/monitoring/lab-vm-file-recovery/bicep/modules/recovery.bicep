// -------------------------------------------------------------------------
// Program: recovery.bicep
// Description: Recovery Services vault with backup policy and VM protection
// Context: AZ-104 Lab - Recover Configuration File from Azure VM Backup
// Author: Greg Tate
// Date: 2026-02-17
// -------------------------------------------------------------------------

@description('Azure region for resources')
param location string

@description('Resource tags')
param tags object

@description('VM resource ID to protect')
param vmId string

@description('VM name')
param vmName string

@description('Resource group name containing the VM')
param resourceGroupName string

// -------------------------------------------------------------------------
// Variables
// -------------------------------------------------------------------------
var uniqueSuffix = substring(uniqueString(resourceGroup().id), 0, 4)
var vaultName = 'rsv-file-recovery-${uniqueSuffix}'
var policyName = 'policy-daily-vm'
var backupFabric = 'Azure'
var protectionContainer = 'iaasvmcontainer;iaasvmcontainerv2;${resourceGroupName};${vmName}'
var protectedItem = 'vm;iaasvmcontainerv2;${resourceGroupName};${vmName}'
var restorePointRGPrefix = '${resourceGroupName}-rpc-'

// -------------------------------------------------------------------------
// Recovery Services Vault
// -------------------------------------------------------------------------
resource vault 'Microsoft.RecoveryServices/vaults@2024-04-30-preview' = {
  name: vaultName
  location: location
  tags: tags
  sku: {
    name: 'RS0'
    tier: 'Standard'
  }
  properties: {
    publicNetworkAccess: 'Enabled'
    securitySettings: {
      softDeleteSettings: {
        softDeleteState: 'Disabled'
      }
    }
  }
}

// -------------------------------------------------------------------------
// Daily backup policy - 7 day retention
// -------------------------------------------------------------------------
resource backupPolicy 'Microsoft.RecoveryServices/vaults/backupPolicies@2024-04-30-preview' = {
  parent: vault
  name: policyName
  properties: {
    backupManagementType: 'AzureIaasVM'
    instantRpRetentionRangeInDays: 2
    instantRPDetails: {
      azureBackupRGNamePrefix: restorePointRGPrefix
    }
    schedulePolicy: {
      schedulePolicyType: 'SimpleSchedulePolicy'
      scheduleRunFrequency: 'Daily'
      scheduleRunTimes: [
        '2026-01-01T02:00:00Z'
      ]
    }
    retentionPolicy: {
      retentionPolicyType: 'LongTermRetentionPolicy'
      dailySchedule: {
        retentionTimes: [
          '2026-01-01T02:00:00Z'
        ]
        retentionDuration: {
          count: 7
          durationType: 'Days'
        }
      }
    }
    timeZone: 'Central Standard Time'
  }
}

// -------------------------------------------------------------------------
// Enable backup protection for the VM
// -------------------------------------------------------------------------
resource protectedVm 'Microsoft.RecoveryServices/vaults/backupFabrics/protectionContainers/protectedItems@2024-04-30-preview' = {
  name: '${vaultName}/${backupFabric}/${protectionContainer}/${protectedItem}'
  properties: {
    protectedItemType: 'Microsoft.Compute/virtualMachines'
    policyId: backupPolicy.id
    sourceResourceId: vmId
  }
}

// -------------------------------------------------------------------------
// Outputs
// -------------------------------------------------------------------------
@description('Recovery Services vault name')
output vaultName string = vault.name

@description('Recovery Services vault ID')
output vaultId string = vault.id

@description('Backup policy name')
output backupPolicyName string = backupPolicy.name

@description('Restore point collection resource group name')
output restorePointRGName string = '${restorePointRGPrefix}1'
