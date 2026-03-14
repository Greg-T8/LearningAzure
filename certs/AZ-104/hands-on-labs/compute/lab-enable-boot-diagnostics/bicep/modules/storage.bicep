// -------------------------------------------------------------------------
// Program: storage.bicep
// Description: Deploy storage accounts used to evaluate boot diagnostics constraints
// Context: AZ-104 Lab - Enable Boot Diagnostics for Azure VMs (Microsoft Azure Administrator)
// Author: Greg Tate
// Date: 2026-02-28
// -------------------------------------------------------------------------

@description('Common tags applied to all storage accounts')
param commonTags object

resource storage1 'Microsoft.Storage/storageAccounts@2023-05-01' = {
  name: 'staz104boot1'
  location: 'centralus'
  tags: commonTags
  kind: 'StorageV2'
  sku: {
    name: 'Premium_LRS'
  }
}

resource storage2 'Microsoft.Storage/storageAccounts@2023-05-01' = {
  name: 'staz104boot2'
  location: 'eastus'
  tags: commonTags
  kind: 'Storage'
  sku: {
    name: 'Standard_LRS'
  }
}

resource storage3 'Microsoft.Storage/storageAccounts@2023-05-01' = {
  name: 'staz104boot3'
  location: 'centralus'
  tags: commonTags
  kind: 'StorageV2'
  sku: {
    name: 'Standard_GRS'
  }
}

@description('Premium storage account name')
output storage1Name string = storage1.name

@description('Standard v1 storage account name')
output storage2Name string = storage2.name

@description('Standard v2 storage account name')
output storage3Name string = storage3.name
