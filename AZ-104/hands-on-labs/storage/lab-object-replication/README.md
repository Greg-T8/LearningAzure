<!--
# -------------------------------------------------------------------------
# Program: README.md
# Description: Hands-on lab for storage object replication
# Context: AZ-104 Lab - Object replication between storage accounts
# Author: Greg Tate
# Date: 2026-02-05
# -------------------------------------------------------------------------
-->

# Lab: Object Replication Between Storage Accounts

## Exam Question Scenario

You plan to configure object replication between storage accounts in two different regions.
You need to ensure that Azure Storage features are configured to support object storage replication. You want to minimize the configuration changes that you make.

How should you configure the Azure Storage features? To answer, select the configuration settings from the drop-down menus.

## Scenario Analysis

- The solution must replicate blobs between storage accounts in different regions.
- Object replication requires blob versioning enabled on both accounts.
- Change feed is required on the source account only.
- The goal is to enable only the minimum features needed to meet the requirement.

## Solution Architecture

- One resource group for the lab.
- Two StorageV2 accounts in different regions.
- Blob versioning enabled on both accounts.
- Change feed enabled on the source account only.
- One source container and one destination container.
- An object replication policy from source to destination.

## Prerequisites

- Azure CLI installed and authenticated
- Terraform installed
- Azure subscription with appropriate permissions
- Resource provider registered: Microsoft.Storage

### Terraform Prerequisites

Ensure you have a terraform.tfvars file with your subscription ID:

```bash
# The terraform.tfvars should contain:
lab_subscription_id = "e091f6e7-031a-4924-97bb-8c983ca5d21a"
```

Register the provider if needed:

```bash
az provider register --namespace Microsoft.Storage
```

## Lab Objectives

1. Deploy two StorageV2 accounts in different regions.
2. Enable blob versioning and change feed settings required for object replication.
3. Configure an object replication policy between containers.

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

1. Verify storage account features:
   - Source account: change feed enabled, versioning enabled
   - Destination account: versioning enabled

2. Confirm the object replication policy exists and is active.

3. Upload a test blob to the source container and verify it appears in the destination container.

## Testing the Solution

1. Create a sample file on your local machine.
2. Upload to the source container using Azure CLI:
   ```bash
   az storage blob upload \
     --account-name <source-storage-account> \
     --container-name src-objects \
     --name sample.txt \
     --file sample.txt
   ```

3. Check for replication to the destination container:
   ```bash
   az storage blob list \
     --account-name <destination-storage-account> \
     --container-name dst-objects \
     --output table
   ```

## Cleanup

### Terraform Cleanup

```bash
terraform destroy
```

## Key Learning Points

- Object replication requires blob versioning on both accounts.
- Change feed is required only on the source account.
- Replication policies connect source and destination containers.

## Related AZ-104 Exam Objectives

- Implement and manage storage
- Configure Azure Storage accounts
- Configure and manage object replication

## Additional Resources

- https://learn.microsoft.com/azure/storage/blobs/object-replication-configure
- https://learn.microsoft.com/azure/storage/common/storage-account-overview
