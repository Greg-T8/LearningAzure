# Lab: Azure Blob Versioning Write Operations

## Overview

This lab demonstrates which write operations create new blob versions when blob versioning is enabled on an Azure Storage account.

## Objectives

- Deploy a storage account with blob versioning enabled
- Test different write operations
- Identify which operations create new versions
- Observe version history

## Prerequisites

- Azure subscription
- Azure CLI or PowerShell Az module
- Terraform (optional, for infrastructure deployment)

## Lab Structure

```
lab-blob-versioning/
├── README.md (this file)
├── bicep/
│   ├── main.bicep
│   ├── main.bicepparam
│   └── storage.bicep
└── scripts/
    └── Test-BlobVersioning.ps1
```

## Deployment Steps

### Option 1: Deploy with Bicep

```bash
# Deploy the infrastructure
az deployment group create \
  --resource-group <your-rg-name> \
  --template-file bicep/main.bicep \
  --parameters bicep/main.bicepparam
```

### Option 2: Deploy with PowerShell

```powershell
# Deploy using PowerShell
New-AzResourceGroupDeployment `
  -ResourceGroupName <your-rg-name> `
  -TemplateFile .\bicep\main.bicep `
  -TemplateParameterFile .\bicep\main.bicepparam
```

## Testing Write Operations

Run the test script to verify which operations create new versions:

```powershell
.\scripts\Test-BlobVersioning.ps1 `
  -ResourceGroupName <your-rg-name> `
  -StorageAccountName <storage-account-name>
```

## Expected Results

The following operations should create new versions:

- Put Blob
- Put Block List
- Copy Blob
- Put Blob From URL

The following operations should NOT create new versions:

- Append Block
- Set Blob Metadata
- Put Page (when updating existing pages)

## Verification

After running the tests, verify versions using:

```powershell
# List all versions of a blob
az storage blob list \
  --account-name <storage-account-name> \
  --container-name test-container \
  --prefix test-blob.txt \
  --include v \
  --auth-mode login
```

## Cleanup

```bash
# Delete the resource group
az group delete --name <your-rg-name> --yes --no-wait
```

## References

- [Blob versioning documentation](https://docs.microsoft.com/azure/storage/blobs/versioning-overview)
- [Enable blob versioning](https://docs.microsoft.com/azure/storage/blobs/versioning-enable)
