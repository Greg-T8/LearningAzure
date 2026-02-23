// -------------------------------------------------------------------------
// Program: loadbalancer.bicep
// Description: Standard Load Balancer with health probe and outbound rule
// Context: AZ-104 Lab - VMSS Rolling Upgrade (Microsoft Azure Administrator)
// Author: Greg Tate
// Date: 2026-02-23
// -------------------------------------------------------------------------

// Parameters
@description('Azure region for resource deployment')
param location string

@description('Common tags for all resources')
param commonTags object

@description('Load balancer name')
param lbName string

@description('Public IP name for load balancer frontend')
param publicIpName string

// -------------------------------------------------------------------------
// Public IP — Standard SKU, Static allocation (required for Standard LB)
// -------------------------------------------------------------------------

resource publicIp 'Microsoft.Network/publicIPAddresses@2024-05-01' = {
  name: publicIpName
  location: location
  tags: commonTags
  sku: {
    name: 'Standard'
  }
  properties: {
    publicIPAllocationMethod: 'Static'
  }
}

// -------------------------------------------------------------------------
// Standard Load Balancer with health probe, inbound rule, and outbound rule
// -------------------------------------------------------------------------

resource lb 'Microsoft.Network/loadBalancers@2024-05-01' = {
  name: lbName
  location: location
  tags: commonTags
  sku: {
    name: 'Standard'
  }
  properties: {

    // Frontend IP bound to public IP
    frontendIPConfigurations: [
      {
        name: 'frontendIPConfig'
        properties: {
          publicIPAddress: {
            id: publicIp.id
          }
        }
      }
    ]

    // Backend pool for VMSS instances
    backendAddressPools: [
      {
        name: 'backendPool'
      }
    ]

    // TCP health probe on port 80 — used by rolling upgrade policy
    probes: [
      {
        name: 'healthProbe'
        properties: {
          protocol: 'Tcp'
          port: 80
          intervalInSeconds: 15
          probeThreshold: 2
        }
      }
    ]

    // Inbound LB rule — disableOutboundSnat per governance §9.2
    loadBalancingRules: [
      {
        name: 'httpRule'
        properties: {
          frontendIPConfiguration: {
            id: resourceId('Microsoft.Network/loadBalancers/frontendIPConfigurations', lbName, 'frontendIPConfig')
          }
          backendAddressPool: {
            id: resourceId('Microsoft.Network/loadBalancers/backendAddressPools', lbName, 'backendPool')
          }
          probe: {
            id: resourceId('Microsoft.Network/loadBalancers/probes', lbName, 'healthProbe')
          }
          protocol: 'Tcp'
          frontendPort: 80
          backendPort: 80
          enableFloatingIP: false
          disableOutboundSnat: true
        }
      }
    ]

    // Outbound rule — provides SNAT for VMSS instances (cloud-init package install)
    outboundRules: [
      {
        name: 'outboundRule'
        properties: {
          frontendIPConfigurations: [
            {
              id: resourceId('Microsoft.Network/loadBalancers/frontendIPConfigurations', lbName, 'frontendIPConfig')
            }
          ]
          backendAddressPool: {
            id: resourceId('Microsoft.Network/loadBalancers/backendAddressPools', lbName, 'backendPool')
          }
          protocol: 'All'
          allocatedOutboundPorts: 1024
        }
      }
    ]
  }
}

// -------------------------------------------------------------------------
// Outputs
// -------------------------------------------------------------------------

@description('Load balancer backend pool resource ID')
output backendPoolId string = lb.properties.backendAddressPools[0].id

@description('Load balancer public IP address')
output publicIpAddress string = publicIp.properties.ipAddress

@description('Load balancer resource ID')
output lbId string = lb.id
