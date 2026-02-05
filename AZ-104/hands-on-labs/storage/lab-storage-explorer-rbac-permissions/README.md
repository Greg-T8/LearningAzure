# Lab: Storage Explorer RBAC Permissions

## Exam Reference

- **Source**: AZ-104 Practice Exam - Storage Account Permissions
- **Domain**: Implement and Manage Storage
- **Topic**: Configure Azure Storage access using RBAC

## Scenario

You have storage accounts in your Azure subscription for different purposes. The storage accounts have blob containers and file shares configured.

Some users access these storage accounts by using the **Microsoft Azure Storage Explorer** desktop application. They are reporting that they get this error message when they try to browse the contents of the storage account:

> **"Unable to list resources in account due to inadequate permissions. Permission to list containers or to list account keys is required."**

You need to resolve the issue.

**Question**: What are two possible reasons why users are getting this error message? Each correct answer presents a complete solution.

## Answer Analysis

The **correct answers** explain why users cannot list containers:

| Answer | Correct? | Explanation |
|--------|----------|-------------|
| Storage Blob Data Reader role | ✅ Yes | Data plane role only - cannot list containers at management level |
| Storage Blob Data Contributor role | ✅ Yes | Data plane role only - cannot list containers at management level |
| ReadOnly resource lock | ❌ No | Locks prevent modifications, not read operations |
| CanNotDelete resource lock | ❌ No | Only prevents deletion, doesn't affect read operations |
| Reader role | ❌ No | Reader role WOULD work - it grants management plane read access |

## Key Concepts

### Data Plane vs Management Plane

| Role Type | Plane | Can List Containers? | Can Access Blob Data? |
|-----------|-------|---------------------|----------------------|
| Reader | Management | ✅ Yes | ❌ No |
| Storage Blob Data Reader | Data | ❌ No | ✅ Yes (read) |
| Storage Blob Data Contributor | Data | ❌ No | ✅ Yes (read/write) |
| Storage Account Contributor | Management | ✅ Yes | ❌ No (but can list keys) |

### Required Permissions to List Containers

To list containers in Storage Explorer, users need ONE of:

1. **Management plane access** (e.g., Reader role) - uses ARM to enumerate resources
2. **Storage account key access** - uses `listkeys` action
3. **Both data and management roles** - recommended approach for production

### The Fix

Assign users **BOTH** roles:
- **Reader** (on storage account or resource group) - to list containers
- **Storage Blob Data Reader/Contributor** - to access blob data

## Objectives

1. Deploy a storage account with blob containers and file shares
2. Create service principals with different RBAC role assignments
3. Demonstrate the permission error with data-plane-only roles
4. Validate the solution by adding management plane access
5. Understand the difference between data plane and management plane roles

## Prerequisites

- Azure subscription
- Terraform CLI installed
- Azure CLI authenticated (`az login`)
- Permission to create service principals and role assignments

---

# Terraform Deployment

## First-Time Setup

```powershell
cd terraform

# Copy the tfvars template and configure your settings
Copy-Item ..\..\..\..\_shared\terraform\terraform.tfvars.template .\terraform.tfvars

# Edit terraform.tfvars with your values:
# - lab_subscription_id = "your-subscription-id"
```

## Deploy

```powershell
cd terraform

# Initialize Terraform
terraform init

# Review the plan
terraform plan

# Deploy the resources
terraform apply
```

## Validate the Permissions Issue

### Step 1: Test with Data Plane Only Role (Storage Blob Data Reader)

The lab creates a service principal with only the **Storage Blob Data Reader** role.

```powershell
# Get the service principal credentials
$appId = terraform output -raw sp_data_reader_app_id
$password = terraform output -raw sp_data_reader_password
$tenant = terraform output -raw tenant_id
$storageAccountName = terraform output -raw storage_account_name

# Login as the service principal
az login --service-principal -u $appId -p $password --tenant $tenant

# Try to list containers - THIS WILL FAIL
az storage container list --account-name $storageAccountName --auth-mode login

# Error: "You do not have the required permissions..."
```

### Step 2: Test Blob Data Access (Should Work)

```powershell
# Direct blob access works because we have the data plane role
$containerName = terraform output -raw container_name

az storage blob list `
    --account-name $storageAccountName `
    --container-name $containerName `
    --auth-mode login

# This works! Data plane access is granted.
```

### Step 3: Test with Reader + Data Role (Solution)

```powershell
# Get the service principal with both roles
$appIdBoth = terraform output -raw sp_both_roles_app_id
$passwordBoth = terraform output -raw sp_both_roles_password

# Login as the service principal with both roles
az login --service-principal -u $appIdBoth -p $passwordBoth --tenant $tenant

# Now list containers - THIS WILL WORK
az storage container list --account-name $storageAccountName --auth-mode login

# Success! User can now list containers AND access data.
```

### Step 4: Test in Storage Explorer (GUI)

1. Open **Microsoft Azure Storage Explorer**
2. Add connection → Service principal
3. Use the **data-reader-only** service principal credentials
4. Try to expand the storage account → **See the error message**
5. Disconnect and use the **both-roles** service principal
6. Expand the storage account → **Containers are visible!**

## Clean Up

```powershell
# Remove all resources
terraform destroy -auto-approve

# Log back in as yourself
az login
```

---

## Architecture Diagram

```
┌─────────────────────────────────────────────────────────────────────┐
│                        Azure Subscription                           │
├─────────────────────────────────────────────────────────────────────┤
│                                                                     │
│  ┌──────────────────────────────────────────────────────────────┐  │
│  │                    Resource Group                             │  │
│  │                    (rg-storage-lab-*)                         │  │
│  │                                                               │  │
│  │  ┌────────────────────────────────────────────────────────┐  │  │
│  │  │              Storage Account                            │  │  │
│  │  │              (stlab*)                                   │  │  │
│  │  │                                                         │  │  │
│  │  │  ┌─────────────────┐    ┌─────────────────┐            │  │  │
│  │  │  │ Blob Container  │    │   File Share    │            │  │  │
│  │  │  │  (documents)    │    │   (reports)     │            │  │  │
│  │  │  └─────────────────┘    └─────────────────┘            │  │  │
│  │  └────────────────────────────────────────────────────────┘  │  │
│  │                                                               │  │
│  │  RBAC Role Assignments:                                       │  │
│  │  ┌────────────────────────────────────────────────────────┐  │  │
│  │  │ SP: data-reader-only                                    │  │  │
│  │  │   └── Storage Blob Data Reader (Data Plane)             │  │  │
│  │  │       ❌ Cannot list containers                         │  │  │
│  │  │       ✅ Can read blob data (if container known)        │  │  │
│  │  ├────────────────────────────────────────────────────────┤  │  │
│  │  │ SP: data-contributor-only                               │  │  │
│  │  │   └── Storage Blob Data Contributor (Data Plane)        │  │  │
│  │  │       ❌ Cannot list containers                         │  │  │
│  │  │       ✅ Can read/write blob data                       │  │  │
│  │  ├────────────────────────────────────────────────────────┤  │  │
│  │  │ SP: reader-and-data-reader                              │  │  │
│  │  │   ├── Reader (Management Plane)                         │  │  │
│  │  │   └── Storage Blob Data Reader (Data Plane)             │  │  │
│  │  │       ✅ Can list containers                            │  │  │
│  │  │       ✅ Can read blob data                             │  │  │
│  │  └────────────────────────────────────────────────────────┘  │  │
│  └──────────────────────────────────────────────────────────────┘  │
│                                                                     │
└─────────────────────────────────────────────────────────────────────┘
```

## Related Documentation

- [Azure RBAC built-in roles](https://learn.microsoft.com/en-us/azure/role-based-access-control/built-in-roles)
- [Authorize access to blobs using Microsoft Entra ID](https://learn.microsoft.com/en-us/azure/storage/blobs/authorize-access-azure-active-directory)
- [Data operations not permitted through RBAC](https://learn.microsoft.com/en-us/azure/storage/common/storage-auth-aad-app)
