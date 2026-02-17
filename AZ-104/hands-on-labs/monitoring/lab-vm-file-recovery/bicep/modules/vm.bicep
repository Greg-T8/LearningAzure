// -------------------------------------------------------------------------
// Program: vm.bicep
// Description: Windows Server 2019 VM with configuration file for backup testing
// Context: AZ-104 Lab - Recover Configuration File from Azure VM Backup
// Author: Greg Tate
// Date: 2026-02-17
// -------------------------------------------------------------------------

@description('Azure region for resources')
param location string

@description('Resource tags')
param tags object

@description('Subnet resource ID for NIC placement')
param subnetId string

@description('VM admin username')
param adminUsername string

@description('VM admin password')
@secure()
param adminPassword string

// -------------------------------------------------------------------------
// Network Interface
// -------------------------------------------------------------------------
resource nic 'Microsoft.Network/networkInterfaces@2024-05-01' = {
  name: 'nic-file-recovery'
  location: location
  tags: tags
  properties: {
    ipConfigurations: [
      {
        name: 'ipconfig1'
        properties: {
          subnet: {
            id: subnetId
          }
          privateIPAllocationMethod: 'Dynamic'
        }
      }
    ]
  }
}

// -------------------------------------------------------------------------
// Windows Server 2019 VM
// -------------------------------------------------------------------------
resource vm 'Microsoft.Compute/virtualMachines@2024-07-01' = {
  name: 'vm-file-recovery'
  location: location
  tags: tags
  properties: {
    hardwareProfile: {
      vmSize: 'Standard_B2s'
    }
    osProfile: {
      computerName: 'vm-filerecov'
      adminUsername: adminUsername
      adminPassword: adminPassword
    }
    storageProfile: {
      imageReference: {
        publisher: 'MicrosoftWindowsServer'
        offer: 'WindowsServer'
        sku: '2019-Datacenter'
        version: 'latest'
      }
      osDisk: {
        name: 'osdisk-file-recovery'
        createOption: 'FromImage'
        managedDisk: {
          storageAccountType: 'Standard_LRS'
        }
      }
    }
    networkProfile: {
      networkInterfaces: [
        {
          id: nic.id
        }
      ]
    }
  }
}

// -------------------------------------------------------------------------
// Auto-shutdown schedule (8:00 AM CST daily)
// -------------------------------------------------------------------------
resource autoShutdown 'Microsoft.DevTestLab/schedules@2018-09-15' = {
  name: 'shutdown-computevm-vm-file-recovery'
  location: location
  tags: tags
  properties: {
    status: 'Enabled'
    taskType: 'ComputeVmShutdownTask'
    dailyRecurrence: {
      time: '0800'
    }
    timeZoneId: 'Central Standard Time'
    targetResourceId: vm.id
    notificationSettings: {
      status: 'Disabled'
    }
  }
}

// -------------------------------------------------------------------------
// Custom Script Extension - create sample configuration file
// -------------------------------------------------------------------------
resource configScript 'Microsoft.Compute/virtualMachines/extensions@2024-07-01' = {
  parent: vm
  name: 'create-config-file'
  location: location
  tags: tags
  properties: {
    publisher: 'Microsoft.Compute'
    type: 'CustomScriptExtension'
    typeHandlerVersion: '1.10'
    autoUpgradeMinorVersion: true
    settings: {
      commandToExecute: 'powershell -Command "New-Item -Path C:\\Config -ItemType Directory -Force; Set-Content -Path C:\\Config\\app.config -Value \'\'<configuration><appSettings><add key=Version value=2.0 /><add key=Environment value=Production /><add key=LastUpdated value=2026-02-17 /></appSettings></configuration>\'\'"'
    }
  }
}

// -------------------------------------------------------------------------
// Outputs
// -------------------------------------------------------------------------
@description('VM resource ID')
output vmId string = vm.id

@description('VM name')
output vmName string = vm.name

@description('NIC private IP address')
output privateIpAddress string = nic.properties.ipConfigurations[0].properties.privateIPAddress
