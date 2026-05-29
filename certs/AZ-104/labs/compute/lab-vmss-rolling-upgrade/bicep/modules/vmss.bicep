// -------------------------------------------------------------------------
// Program: vmss.bicep
// Description: Virtual Machine Scale Set with Rolling upgrade policy
// Context: AZ-104 Lab - VMSS Rolling Upgrade (Microsoft Azure Administrator)
// Author: Greg Tate
// Date: 2026-02-23
// -------------------------------------------------------------------------

// Parameters
@description('Azure region for resource deployment')
param location string

@description('Common tags for all resources')
param commonTags object

@description('VMSS name')
param vmssName string

@description('Admin username for VMSS instances')
param adminUsername string

@description('Admin password for VMSS instances')
@secure()
param adminPassword string

@description('Subnet resource ID for VMSS NIC configuration')
param subnetId string

@description('Load balancer backend pool resource ID')
param backendPoolId string

@description('Load balancer health probe resource ID')
param healthProbeId string

// -------------------------------------------------------------------------
// Local variables
// -------------------------------------------------------------------------

// Cloud-init script to install nginx (provides health probe endpoint on port 80)
var cloudInitScript = '''
#cloud-config
package_update: true
packages:
  - nginx
runcmd:
  - [ systemctl, enable, nginx ]
  - [ systemctl, start, nginx ]
'''

// -------------------------------------------------------------------------
// Virtual Machine Scale Set — Uniform mode, Rolling upgrade policy
// -------------------------------------------------------------------------

resource vmss 'Microsoft.Compute/virtualMachineScaleSets@2024-07-01' = {
  name: vmssName
  location: location
  tags: commonTags
  sku: {
    name: 'Standard_B2s'
    tier: 'Standard'
    capacity: 2
  }
  properties: {
    orchestrationMode: 'Uniform'
    overprovision: false
    singlePlacementGroup: true

    // Rolling upgrade policy — triggers automatic batched upgrades on model changes
    upgradePolicy: {
      mode: 'Rolling'
      rollingUpgradePolicy: {
        maxBatchInstancePercent: 50
        maxUnhealthyInstancePercent: 50
        maxUnhealthyUpgradedInstancePercent: 50
        pauseTimeBetweenBatches: 'PT10S'
      }
    }

    // VM instance profile
    virtualMachineProfile: {

      // OS configuration — Ubuntu Linux with password auth
      osProfile: {
        computerNamePrefix: 'vmss'
        adminUsername: adminUsername
        adminPassword: adminPassword
        customData: base64(cloudInitScript)
        linuxConfiguration: {
          disablePasswordAuthentication: false
        }
      }

      // Storage profile — OS disk + 32 GB data disk (exam scenario tests both)
      storageProfile: {
        imageReference: {
          publisher: 'Canonical'
          offer: '0001-com-ubuntu-server-jammy'
          sku: '22_04-lts-gen2'
          version: 'latest'
        }
        osDisk: {
          createOption: 'FromImage'
          caching: 'ReadWrite'
          managedDisk: {
            storageAccountType: 'Standard_LRS'
          }
        }
        dataDisks: [
          {
            lun: 0
            createOption: 'Empty'
            diskSizeGB: 32
            caching: 'ReadOnly'
            managedDisk: {
              storageAccountType: 'Standard_LRS'
            }
          }
        ]
      }

      // Network profile — connects to LB backend pool via subnet
      networkProfile: {
        healthProbe: {
          id: healthProbeId
        }
        networkInterfaceConfigurations: [
          {
            name: 'nic-vmss'
            properties: {
              primary: true
              ipConfigurations: [
                {
                  name: 'ipconfig1'
                  properties: {
                    subnet: {
                      id: subnetId
                    }
                    loadBalancerBackendAddressPools: [
                      {
                        id: backendPoolId
                      }
                    ]
                  }
                }
              ]
            }
          }
        ]
      }
    }
  }
}

// -------------------------------------------------------------------------
// Outputs
// -------------------------------------------------------------------------

@description('VMSS name')
output vmssName string = vmss.name

@description('VMSS resource ID')
output vmssId string = vmss.id
