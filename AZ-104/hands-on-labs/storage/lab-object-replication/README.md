# Lab: Configure Azure Storage Object Replication

## Exam Question Scenario

You plan to configure object replication between storage accounts in two different regions.

You need to ensure that Azure Storage features are configured to support object storage replication. You want to minimize the configuration changes that you make.

How should you configure the Azure Storage features? To answer, select the configuration settings from the drop-down menus.

**Configuration Requirements:**

- **Change feed**: Destination account only
- **Blob versioning**: Source account only

## Scenario Analysis

This exam question tests understanding of the prerequisites for Azure Storage object replication:

1. **Object Replication** requires specific features to be enabled on source and destination storage accounts
2. **Blob versioning** must be enabled on the **source** account to track changes
3. **Change feed** must be enabled on the **destination** account to process replication events
4. Both accounts actually need versioning enabled, but the question asks for **minimum changes**, focusing on what's unique to each account

### Key Concepts

- **Object Replication**: Asynchronously copies block blobs between storage accounts
- **Blob Versioning**: Automatically maintains previous versions of blobs when modified
- **Change Feed**: Provides transaction logs of changes to blobs in a storage account
- **Cross-Region Replication**: Enables disaster recovery and reduces latency for global applications

## Solution Architecture

The lab deploys:

1. **Resource Group**: `az104-storage-object-replication-tf`
2. **Source Storage Account** (East US):
   - Standard LRS storage account
   - **Blob versioning enabled** (required for source)
   - Change feed disabled (not required on source)
   - Source container: `source-data`

3. **Destination Storage Account** (West US 2):
   - Standard LRS storage account
   - **Blob versioning enabled** (required for destination)
   - **Change feed enabled** (required for destination)
   - Destination container: `replicated-data`

4. **Object Replication Policy**: Configured via Azure CLI after Terraform deployment

```
┌─────────────────────────────────┐      ┌─────────────────────────────────┐
│   Source Storage Account        │      │  Destination Storage Account    │
│   (East US)                     │      │  (West US 2)                    │
│                                 │      │                                 │
│   ✓ Blob Versioning: Enabled   │─────>│   ✓ Blob Versioning: Enabled   │
│   ✗ Change Feed: Disabled       │      │   ✓ Change Feed: Enabled       │
│                                 │      │                                 │
│   Container: source-data        │      │   Container: replicated-data   │
└─────────────────────────────────┘      └─────────────────────────────────┘
         Replication Policy →
```

## Prerequisites

- Azure CLI installed and authenticated (`az login`)
- Terraform installed (>= 1.0)
- Azure subscription with appropriate permissions
- Resource providers registered:
  - `Microsoft.Storage`

### Terraform Prerequisites

Ensure you have a `terraform.tfvars` file with your subscription ID:

```bash
# The terraform.tfvars file is already created with the lab subscription ID:
lab_subscription_id = "e091f6e7-031a-4924-97bb-8c983ca5d21a"
```

Register the Storage provider if needed:

```bash
az provider register --namespace Microsoft.Storage
az provider show --namespace Microsoft.Storage --query "registrationState"
```

## Lab Objectives

1. Create source and destination storage accounts in different regions
2. Configure blob versioning on the source storage account
3. Configure blob versioning and change feed on the destination storage account
4. Create blob containers in both storage accounts
5. Configure object replication policy between the accounts
6. Validate objects are replicated from source to destination

## Deployment

### Terraform Deployment

1. Navigate to the terraform directory:

   ```bash
   cd terraform
   ```

2. Verify `terraform.tfvars` exists with your subscription ID:

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

5. Format the code:

   ```bash
   terraform fmt
   ```

6. Review the planned changes:

   ```bash
   terraform plan
   ```

7. Deploy the infrastructure:

   ```bash
   terraform apply
   ```

   When prompted, type `yes` to confirm.

8. Note the output values - you'll need the storage account names for the next steps.

### Configure Object Replication Policy

After Terraform deployment, configure the replication policy using Azure CLI:

1. Get the storage account names from Terraform output:

   ```bash
   SOURCE_ACCOUNT=$(terraform output -raw source_storage_account_name)
   DEST_ACCOUNT=$(terraform output -raw destination_storage_account_name)
   SOURCE_CONTAINER=$(terraform output -raw source_container_name)
   DEST_CONTAINER=$(terraform output -raw destination_container_name)
   ```

2. Create the object replication policy on the **destination** account first:

   ```bash
   az storage account or-policy create \
     --account-name $DEST_ACCOUNT \
     --source-account $(terraform output -raw source_storage_account_id) \
     --destination-account $(terraform output -raw destination_storage_account_id) \
     --source-container $SOURCE_CONTAINER \
     --destination-container $DEST_CONTAINER
   ```

3. Get the policy ID from the command output and apply it to the source account:

   ```bash
   # The policy ID will be displayed in the output
   # Use it to complete the replication setup
   ```

**Note**: Object replication policies can also be configured via the Azure Portal:

- Navigate to destination storage account → Object replication → Set up replication rules

## Validation Steps

### 1. Verify Storage Account Configuration

```powershell
# Get storage account names from Terraform output
$sourceAccount = terraform output -raw source_storage_account_name
$destAccount = terraform output -raw destination_storage_account_name
$rgName = terraform output -raw resource_group_name

# Verify source account has versioning enabled
az storage account blob-service-properties show `
  --account-name $sourceAccount `
  --resource-group $rgName `
  --query "{versioning:isVersioningEnabled, changeFeed:changeFeed.enabled}"

# Verify destination account has versioning AND change feed enabled
az storage account blob-service-properties show `
  --account-name $destAccount `
  --resource-group $rgName `
  --query "{versioning:isVersioningEnabled, changeFeed:changeFeed.enabled}"
```

**Expected Results:**

- Source account: `versioning: true`, `changeFeed: false` or `null`
- Destination account: `versioning: true`, `changeFeed: true`

### 2. Verify Containers Exist

```powershell
# List containers in source account
az storage container list `
  --account-name $sourceAccount `
  --auth-mode login `
  --query "[].name"

# List containers in destination account
az storage container list `
  --account-name $destAccount `
  --auth-mode login `
  --query "[].name"
```

### 3. Check Object Replication Policy Status

```powershell
# View replication policies on source account
az storage account or-policy list `
  --account-name $sourceAccount `
  --resource-group $rgName

# View replication policies on destination account
az storage account or-policy list `
  --account-name $destAccount `
  --resource-group $rgName
```

## Testing the Solution

### Test Object Replication

1. **Upload a test blob to the source container**:

   ```powershell
   # Create a test file
   "Test content for object replication" | Out-File -FilePath test.txt
   
   # Upload to source container
   az storage blob upload `
     --account-name $sourceAccount `
     --container-name $sourceContainer `
     --name test.txt `
     --file test.txt `
     --auth-mode login
   ```

2. **Wait for replication** (usually takes a few minutes):

   ```powershell
   # Check replication status
   az storage blob show `
     --account-name $sourceAccount `
     --container-name $sourceContainer `
     --name test.txt `
     --auth-mode login `
     --query "properties.objectReplicationSourceProperties"
   ```

3. **Verify blob appears in destination container**:

   ```powershell
   # List blobs in destination
   az storage blob list `
     --account-name $destAccount `
     --container-name $destContainer `
     --auth-mode login `
     --query "[].name"
   
   # Download and verify content
   az storage blob download `
     --account-name $destAccount `
     --container-name $destContainer `
     --name test.txt `
     --file test-downloaded.txt `
     --auth-mode login
   
   Get-Content test-downloaded.txt
   ```

4. **Test versioning by updating the blob**:

   ```powershell
   # Update the source blob
   "Updated content for version testing" | Out-File -FilePath test.txt
   
   az storage blob upload `
     --account-name $sourceAccount `
     --container-name $sourceContainer `
     --name test.txt `
     --file test.txt `
     --auth-mode login `
     --overwrite
   
   # Wait and verify new version is replicated
   Start-Sleep -Seconds 120
   
   az storage blob download `
     --account-name $destAccount `
     --container-name $destContainer `
     --name test.txt `
     --file test-updated.txt `
     --auth-mode login `
     --overwrite
   
   Get-Content test-updated.txt
   ```

### Validation Script

Run the provided PowerShell validation script:

```powershell
cd ../validation
./test-object-replication.ps1
```

## Cleanup

### Terraform Cleanup

```bash
cd terraform
terraform destroy
```

When prompted, type `yes` to confirm deletion of all resources.

**Verify cleanup:**

```bash
az group show --name az104-storage-object-replication-tf
```

This should return an error indicating the resource group doesn't exist.

## Key Learning Points

1. **Object Replication Prerequisites**:
   - Blob versioning must be enabled on **both** source and destination accounts
   - Change feed must be enabled on the **destination** account
   - Both accounts must be General Purpose v2 or Premium Block Blob accounts

2. **Minimum Configuration** (exam focus):
   - **Source account unique requirement**: Blob versioning
   - **Destination account unique requirement**: Change feed
   - This is what the exam question tests - what's uniquely required on each side

3. **Replication Policy Configuration**:
   - Policy is created on the destination account first
   - Policy must then be applied to the source account
   - Policies can include multiple rules with filters

4. **Use Cases for Object Replication**:
   - **Disaster recovery**: Geographic redundancy for critical data
   - **Latency reduction**: Place data closer to users in different regions
   - **Data sovereignty**: Keep copies in specific regions for compliance
   - **Cost optimization**: Move compute to data rather than data to compute

5. **Replication Behavior**:
   - Only new blobs or updates after policy creation are replicated
   - Existing blobs are NOT replicated automatically
   - Replication is asynchronous (not real-time)
   - Failed replication can be retried

6. **Differences from Other Replication Types**:
   - **LRS/ZRS/GRS**: Built-in redundancy within/across regions (synchronous)
   - **Object Replication**: Custom policy-based cross-region replication (asynchronous)
   - **Object Replication vs. GRS**: More control but requires manual configuration

## Related AZ-104 Exam Objectives

This lab covers the following AZ-104 exam objectives:

- **Implement and manage storage**:
  - Configure Azure Storage accounts
  - Configure blob storage
  - Configure storage replication
  - Manage data in Azure Storage accounts

- **Storage account features**:
  - Blob versioning
  - Change feed
  - Object replication policies

## Additional Resources

- [Object replication for block blobs](https://learn.microsoft.com/en-us/azure/storage/blobs/object-replication-overview)
- [Configure object replication](https://learn.microsoft.com/en-us/azure/storage/blobs/object-replication-configure)
- [Blob versioning](https://learn.microsoft.com/en-us/azure/storage/blobs/versioning-overview)
- [Change feed support in Azure Blob Storage](https://learn.microsoft.com/en-us/azure/storage/blobs/storage-blob-change-feed)
- [Azure Storage replication](https://learn.microsoft.com/en-us/azure/storage/common/storage-redundancy)

## Troubleshooting

### Common Issues

1. **Replication policy creation fails**:
   - Ensure blob versioning is enabled on both accounts
   - Ensure change feed is enabled on destination account
   - Verify storage accounts are General Purpose v2

2. **Blobs not replicating**:
   - Check replication policy is applied to both accounts
   - Verify containers exist in both accounts
   - Wait sufficient time (can take several minutes)
   - Check replication status in blob properties

3. **Terraform apply fails**:
   - Verify subscription ID in terraform.tfvars
   - Ensure Microsoft.Storage provider is registered
   - Check for storage account name conflicts (globally unique)

4. **Permission errors**:
   - Ensure you have Contributor or Storage Account Contributor role
   - Use `--auth-mode login` for Azure CLI storage commands
   - Verify Azure CLI is authenticated (`az account show`)
