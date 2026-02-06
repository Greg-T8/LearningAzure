<!--
# -------------------------------------------------------------------------
# Program: README.md
# Description: Hands-on lab guide for load balancer outbound flow behavior
# Context: AZ-104 Lab - Standard Load Balancer outbound flow behavior
# Author: Greg Tate
# Date: 2026-02-06
# -------------------------------------------------------------------------
-->

# Lab: Load Balancer Outbound Behavior

## Exam Question Scenario

You deploy three Windows virtual machines (VMs) named VM01, VM02, and VM03 that host the front-end layer of a web application. You configure a Standard Load Balancer named LB01. VM01, VM02, and VM03 are configured as part of the backend pool for LB01. You configure a load balancing rule for Transmission Control Protocol (TCP) traffic only.

You also configure three public static IP addresses named IP01, IP02, and IP03 which are assigned as follows:

- IP01 is assigned to VM01.
- IP02 and IP03 are assigned to LB01.

For each of the following statements, select Yes if the statement is true. Otherwise, select No.

## Scenario Analysis

The scenario focuses on outbound connectivity behavior for a Standard Load Balancer when a backend VM has its own public IP and the load balancer has multiple frontend IPs. The lab models three backend VMs, one instance-level public IP, two load balancer public frontends, and a TCP-only load balancing rule with an outbound rule that uses both frontends.

## Solution Architecture

This lab deploys a resource group, virtual network, subnet, network security group, three Windows VMs, a Standard public load balancer, and three public IPs. VM01 receives its own public IP. The load balancer exposes two public frontends, and the backend pool contains all three VMs. A TCP-only load balancing rule and an outbound rule are configured to match the scenario.

## Prerequisites

- Azure CLI installed and authenticated
- Bicep installed
- Azure subscription with appropriate permissions
- Resource providers registered: Microsoft.Compute, Microsoft.Network, Microsoft.Resources

Register the providers if needed:

```bash
az provider register --namespace Microsoft.Network
az provider register --namespace Microsoft.Compute
az provider register --namespace Microsoft.Resources
```

## Lab Objectives

1. Deploy a Standard Load Balancer with multiple public frontends.
2. Place three Windows VMs into a backend pool with a TCP rule.
3. Validate outbound IP selection for instance-level and load balancer SNAT.

## Deployment

### Bicep Deployment

1. Navigate to the bicep directory:
   ```bash
   cd bicep
   ```

2. Update the admin password in main.bicepparam:
   ```bash
   # Replace the placeholder with a strong password before deployment
   ```

3. Validate the template:
   ```powershell
   .\bicep.ps1 validate
   ```

4. Review the plan (what-if):
   ```powershell
   .\bicep.ps1 plan
   ```

5. Deploy the stack:
   ```powershell
   .\bicep.ps1 apply
   ```

## Validation Steps

1. Confirm the load balancer frontends:
   ```bash
   az network lb frontend-ip list \
     --resource-group az104-networking-load-balancer-outbound-bicep \
     --lb-name lb-load-balancer-outbound
   ```
2. Confirm the outbound rule uses both frontend IPs:
   ```bash
   az network lb outbound-rule list \
     --resource-group az104-networking-load-balancer-outbound-bicep \
     --lb-name lb-load-balancer-outbound
   ```
3. From each VM, check outbound IP selection:
   ```powershell
   Invoke-RestMethod -Uri "https://ifconfig.me"
   ```
4. Compare the results:
   - VM01 should return IP01.
   - VM02 and VM03 should return IP02 or IP03.

## Testing the Solution

1. Confirm VM01 has its own public IP:
   ```bash
   az network public-ip show \
     --resource-group az104-networking-load-balancer-outbound-bicep \
     --name pip-load-balancer-outbound-vm01 \
     --query ipAddress
   ```
2. Refresh the outbound IP test from VM02 and VM03 to observe IP02 or IP03 usage.

## Cleanup

### Bicep Cleanup

```powershell
.\bicep.ps1 destroy
```

## Key Learning Points

- Instance-level public IPs override load balancer outbound SNAT.
- TCP-only load balancing rules impact outbound SNAT behavior.
- Multiple frontend IPs can be used for outbound flows.

## Related AZ-104 Exam Objectives

- Configure and manage virtual networks
- Configure load balancing
- Implement and manage virtual machines

## Additional Resources

- https://learn.microsoft.com/azure/load-balancer/load-balancer-outbound-connections
- https://learn.microsoft.com/azure/load-balancer/load-balancer-multiple-frontends
- https://learn.microsoft.com/azure/virtual-network/network-security-groups-overview
