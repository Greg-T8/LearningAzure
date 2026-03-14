// -------------------------------------------------------------------------
// Program: compute.bicep
// Description: Deploy NICs and virtual machines without boot diagnostics enabled
// Context: AZ-104 Lab - Enable Boot Diagnostics for Azure VMs (Microsoft Azure Administrator)
// Author: Greg Tate
// Date: 2026-02-28
// -------------------------------------------------------------------------

@description('Common tags applied to all taggable compute resources')
param commonTags object

@description('Administrator username for both virtual machines')
param adminUsername string

@description('Administrator password for both virtual machines')
@secure()
param adminPassword string

@description('Subnet resource ID in Central US for vm-boot-1')
param centralSubnetId string

@description('Subnet resource ID in East US for vm-boot-2')
param eastSubnetId string

resource vm1Nic 'Microsoft.Network/networkInterfaces@2024-05-01' = {
  name: 'nic-boot-1'
  location: 'centralus'
  tags: commonTags
  properties: {
    ipConfigurations: [
      {
        name: 'ipconfig1'
        properties: {
          privateIPAllocationMethod: 'Dynamic'
          subnet: {
            id: centralSubnetId
          }
        }
      }
    ]
  }
}

resource vm2Nic 'Microsoft.Network/networkInterfaces@2024-05-01' = {
  name: 'nic-boot-2'
  location: 'eastus'
  tags: commonTags
  properties: {
    ipConfigurations: [
      {
        name: 'ipconfig1'
        properties: {
          privateIPAllocationMethod: 'Dynamic'
          subnet: {
            id: eastSubnetId
          }
        }
      }
    ]
  }
}

resource vm1 'Microsoft.Compute/virtualMachines@2024-07-01' = {
  name: 'vm-boot-1'
  location: 'centralus'
  tags: commonTags
  properties: {
    hardwareProfile: {
      vmSize: 'Standard_B2s'
    }
    osProfile: {
      computerName: 'vm-boot-1'
      adminUsername: adminUsername
      adminPassword: adminPassword
      linuxConfiguration: {
        disablePasswordAuthentication: false
      }
    }
    storageProfile: {
      imageReference: {
        publisher: 'Canonical'
        offer: '0001-com-ubuntu-server-focal'
        sku: '20_04-lts-gen2'
        version: 'latest'
      }
      osDisk: {
        createOption: 'FromImage'
        managedDisk: {
          storageAccountType: 'Standard_LRS'
        }
      }
    }
    diagnosticsProfile: {
      bootDiagnostics: {
        enabled: false
      }
    }
    networkProfile: {
      networkInterfaces: [
        {
          id: vm1Nic.id
          properties: {
            primary: true
          }
        }
      ]
    }
  }
}

resource vm2 'Microsoft.Compute/virtualMachines@2024-07-01' = {
  name: 'vm-boot-2'
  location: 'eastus'
  tags: commonTags
  properties: {
    hardwareProfile: {
      vmSize: 'Standard_B2s'
    }
    osProfile: {
      computerName: 'vm-boot-2'
      adminUsername: adminUsername
      adminPassword: adminPassword
    }
    storageProfile: {
      imageReference: {
        publisher: 'MicrosoftWindowsServer'
        offer: 'WindowsServer'
        sku: '2019-datacenter-gensecond'
        version: 'latest'
      }
      osDisk: {
        createOption: 'FromImage'
        managedDisk: {
          storageAccountType: 'Standard_LRS'
        }
      }
    }
    diagnosticsProfile: {
      bootDiagnostics: {
        enabled: false
      }
    }
    networkProfile: {
      networkInterfaces: [
        {
          id: vm2Nic.id
          properties: {
            primary: true
          }
        }
      ]
    }
  }
}

@description('Name of Ubuntu virtual machine')
output vm1Name string = vm1.name

@description('Name of Windows virtual machine')
output vm2Name string = vm2.name
