<!--
# -------------------------------------------------------------------------
# Program: README.md
# Description: Hands-on lab guide for load balancer outbound traffic
# Context: AZ-104 Lab - Load balancer outbound traffic
# Author: Greg Tate
# Date: 2026-02-05
# -------------------------------------------------------------------------
-->

# Lab: Standard Load Balancer Outbound Traffic

## Exam Question Scenario

You deploy three Windows virtual machines (VMs) named VM01, VM02, and VM03 that host the front-end layer of a web application. You configure a Standard Load Balancer named LB01. VM01, VM02, and VM03 are configured as part of the backend pool for LB01. You configure a load balancing rule for Transmission Control Protocol (TCP) traffic only.

You also configure three public static IP addresses named IP01, IP02, and IP03 which are assigned as follows:

- IP01 is assigned to VM01.
- IP02 and IP03 are assigned to LB01.

For each of the following statements, select Yes if the statement is true. Otherwise, select No.

## Scenario Analysis

The scenario focuses on outbound connectivity behavior for a Standard Load Balancer when a backend VM has its own public IP and the load balancer has multiple frontend IPs. The lab must model three backend VMs, one instance-level public IP, two load balancer public frontends, and a TCP-only load balancing rule.

## Solution Architecture

This lab deploys a resource group, virtual network, subnet, network security group, three Windows VMs, a Standard public load balancer, and three public IPs. VM01 receives its own public IP. The load balancer exposes two public frontends, and the backend pool contains all three VMs. An outbound rule is configured for each frontend IP to model SNAT behavior for VM02 and VM03.

## Prerequisites

- Azure CLI installed and authenticated
- Terraform installed
- Azure subscription with appropriate permissions
- Resource providers registered: Microsoft.Compute, Microsoft.Network

### Terraform Prerequisites

Ensure you have a `terraform.tfvars` file with your subscription ID:

```bash
# The terraform.tfvars should contain:
lab_subscription_id = "e091f6e7-031a-4924-97bb-8c983ca5d21a"
```

Register the provider if needed:

```bash
az provider register --namespace Microsoft.Network
az provider register --namespace Microsoft.Compute
```

## Lab Objectives

1. Deploy a Standard Load Balancer with multiple public frontends.
2. Place three Windows VMs into a backend pool with a TCP rule.
3. Validate outbound IP selection for instance-level and load balancer SNAT.

## Deployment

### Terraform Deployment

1. Navigate to the terraform directory:
   ```bash
   cd terraform
   ```

2. Verify terraform.tfvars exists with your subscription ID:
   ```bash
   # File should already exist with lab subscription ID
   cat terraform.tfvars
   ```

3. Initialize Terraform:
   ```bash
   terraform init
   ```

4. Validate the configuration:
   ```bash
   terraform validate
   ```

5. Review the planned changes:
   ```bash
   terraform plan
   ```

6. Deploy the infrastructure:
   ```bash
   terraform apply
   ```

## Validation Steps

1. Confirm the public IPs after deployment:
   - VM01 uses the VM01 public IP.
   - IP02 and IP03 are load balancer frontends.
2. Connect to VM01 and run:
   ```powershell
   Invoke-RestMethod -Uri "https://ifconfig.me"
   ```
3. Connect to VM02 and run:
   ```powershell
   Invoke-RestMethod -Uri "https://ifconfig.me"
   ```
4. Connect to VM03 and run:
   ```powershell
   Invoke-RestMethod -Uri "https://ifconfig.me"
   ```
5. Compare the results:
   - VM01 should return IP01.
   - VM02 and VM03 should return IP02 or IP03.

## Testing the Solution

1. Browse to the load balancer IP02 from your workstation:
   - `http://<IP02>` should return the IIS welcome page.
2. Browse to the load balancer IP03 from your workstation:
   - `http://<IP03>` should return the IIS welcome page.
3. Refresh multiple times to observe load distribution across VM01-VM03.

## Cleanup

### Terraform Cleanup

```bash
terraform destroy
```

## Key Learning Points

- Instance-level public IPs override load balancer outbound SNAT.
- Standard Load Balancer outbound rules control egress IP selection.
- Multiple frontend IPs can be used for outbound flows.

## Related AZ-104 Exam Objectives

- Configure and manage virtual networks
- Configure load balancing
- Implement and manage virtual machines

## Additional Resources

- https://learn.microsoft.com/azure/load-balancer/load-balancer-outbound-rules
- https://learn.microsoft.com/azure/load-balancer/load-balancer-overview
- https://learn.microsoft.com/azure/virtual-network/network-security-groups-overview
