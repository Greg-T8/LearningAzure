# MeasureUp Assessment AZ-104: Microsoft Azure Administrator

## Overview

Notes and insights from the MeasureUp practice assessment for AZ-104.

I took this assessment on Friday, January 30th, after reviewing the Microsoft Learn content and the John Savill video course, but prior to completing the hands-on labs and practice exams.

## Assessment Results

<img src='.img/2026-01-30-06-23-36.png' width=700>

<img src='.img/2026-01-30-06-25-12.png' width=700>

---

## Wrong Answers Review

<img src='.img/2026-01-30-05-33-53.png' width=700>

<details>
<summary>Click to expand explanation</summary>

## Your Answer vs. The Correct Sequence

**Your selected order:**

1. Create a Microsoft Entra group and add users to the group ✓
2. Select the Microsoft Entra group for which you want to allow SSPR ✗
3. Register an authentication method for SSPR ✗
4. Enable SSPR with the Selected option ✗

## The Issue

The main problem is with **steps 2-4**. You're trying to select a group for SSPR (step 2) before SSPR is even enabled (step 4). Additionally, you should configure the authentication method requirements before enabling SSPR.

## The Correct Order Should Be

1. **Create a Microsoft Entra group and add users to the group** ✓
   - This satisfies the requirement to "add and remove users" by managing group membership

2. **Register an authentication method for SSPR**
   - This configures "one additional piece of personal information" that users must provide (like security questions, phone, email, etc.)

3. **Enable SSPR with the Selected option**
   - You use "Selected" (not "All") because you only want a subset of users to have SSPR access
   - This must be done before you can assign groups to SSPR

4. **Select the Microsoft Entra group for which you want to allow SSPR**
   - Now you can specify which group(s) should have SSPR enabled
   - Users can be added/removed from SSPR by managing group membership

## Key Takeaway

You must **configure the authentication requirements and enable SSPR** before you can **assign it to specific groups**. Think of it as: configure what → enable it → specify who gets it.

</details>

---

<img src='.img/2026-01-30-06-03-01.png' width=700>

<details>
<summary>Click to expand explanation</summary>

Looking at your selected answers, I can help you understand why this approach doesn't meet the requirements.

## Your Selected Answer

1. ✓ Assign the built-in Contributor role to the SalesDepartment group for the RG1 resource group
2. ✗ Assign the built-in Reader role to the SalesDepartment group at the subscription level

## The Problem with Your Answer

**The second selection violates the least privilege principle:**

When you assign **Reader at the subscription level**, the Sales team gets read access to **ALL** resource groups in the subscription, including:

- RG1 ✓ (needed)
- RG2 ✓ (needed)
- **RG3 ✗ (NOT allowed by requirements)**

The requirement explicitly states: "The Sales team should be able to read resources in RG1 and RG2 **only**."

## The Correct Answer Should Be

1. **Assign the built-in Contributor role to the SalesDepartment group for the RG1 resource group** ✓
   - Allows creating resources in RG1
   - Allows reading resources in RG1
   - Does NOT allow assigning permissions (Contributor lacks this ability)

2. **Assign the built-in Reader role to the SalesDepartment group for the RG2 resource group** ✓
   - Allows reading resources in RG2 only
   - Does NOT allow creating resources
   - No access to RG3

## Why This Meets All Requirements

✓ Read resources in RG1 and RG2 only (not RG3)  
✓ Create resources in only RG1  
✓ Cannot assign permissions (Contributor doesn't include this)  
✓ Cannot create resource groups (no subscription-level permissions)  
✓ Follows least privilege principle

## Key Takeaway

Avoid assigning roles at higher scopes (like subscription level) when you can achieve the same result at lower scopes (resource group level). Always grant the minimum access needed at the most specific scope possible.

</details>

---

<img src='.img/2026-01-30-06-20-49.png' width=700>


<details>
<summary>Click to expand explanation</summary>

Looking at your selected answers, I can help you understand what went wrong.

## Your Selected Answers

1. ✗ Create a tag named CostCenter and assign it to each **resource group**
2. ✓ Instruct the accounting department to use the Cost Analysis blade in the subscription panel

## The Problem with Your Answer

You got **one correct** (Cost Analysis), but your tagging strategy is at the **wrong level of granularity**.

### Why Resource Group Tagging is Insufficient

**Resource group-level tags** can cause issues when:

- Multiple resources in the same resource group belong to **different cost centers**
- You need **granular cost allocation** at the resource level
- Resources are moved between resource groups

For example, if RG1 contains:

- 5 VMs for Cost Center A
- 3 VMs for Cost Center B

Tagging the resource group only gives you one cost center value, preventing accurate cost allocation.

## The Correct Answers Should Be

1. **Create a tag named CostCenter and assign it to each resource** ✓
   - Provides granular cost tracking at the resource level
   - Each resource can be assigned to its specific cost center
   - More accurate cost allocation

2. **Instruct the accounting department to use the Cost Analysis blade in the subscription panel** ✓
   - This is the correct tool for CSP-managed subscriptions
   - Azure Account Center is NOT available for CSP subscriptions
   - Cost Analysis can filter and group costs by tags

## Why "Azure Account Center" is Wrong

The **Azure Account Center** is not accessible in **Cloud Service Provider (CSP) managed subscriptions**. Only direct Enterprise Agreement (EA) or other subscription types have access to it.

## Key Takeaway

For cost center allocation:

- Tag at the **resource level** (not resource group level) for accurate, granular tracking
- Use **Cost Analysis** (not Account Center) for CSP subscriptions
- Cost Analysis allows filtering and grouping by tags to assign costs to cost centers

</details>

---

<img src='.img/2026-01-30-05-46-07.png' width=700>

<img src='.img/2026-01-30-05-42-04.png' width=400>

<details>
<summary>Click to expand explanation</summary>

Looking at your selected answers, I can see you've made the same mistake again with this question (which appears to be the same as image 3).

## Your Selected Answers

1. ✗ Your users have the Storage Blob Data Reader role assigned in the storage accounts
2. ✗ Your users have the Storage Blob Data Contributor role assigned in the storage accounts

## The Problem - You're Still Selecting SOLUTIONS Instead of PROBLEMS

The error message clearly states:
> "**Unable to list resources in account due to inadequate permissions**. Permission to list containers or to list account keys is required."

You selected answers that indicate users **already have proper data access roles**. If they had Storage Blob Data Reader or Contributor, they **wouldn't be getting this error** - the problem would already be solved!

## The Correct Answers Should Be

1. **Your users have the Read role assigned in the storage accounts** ✓
   - **This IS a problem**: The generic "Read" role only provides management plane access
   - It does NOT grant data plane access to browse blob/file contents
   - Users can see the storage account exists but cannot access the data inside

2. **There is a ReadOnly resource lock configured** ✓
   - **This IS a problem**: ReadOnly locks can block operations in Storage Explorer
   - Locks can override permissions and prevent certain actions

## Understanding the Logic

**Error exists** = Something is wrong/missing

- ❌ "Users have Storage Blob Data Reader" = No error (they have correct access)
- ✓ "Users have Read role" = Error! (they lack data plane access)
- ✓ "ReadOnly lock configured" = Error! (lock blocks operations)

## Key Takeaway

When a question asks for "**reasons why users are getting an error**," you need to identify what's **CAUSING the problem** (wrong role, locks), not what would **FIX the problem** (correct roles).

### More Detail

Great question! Let me explain how ReadOnly locks interact with Azure Storage Explorer and why they can cause issues.

## What ReadOnly Locks Do

**ReadOnly locks** in Azure prevent **any modifications** to a resource, including:

- Changing resource configuration
- Modifying properties
- Regenerating access keys
- Updating firewall rules
- ANY write operation at the management plane

## How Storage Explorer Accesses Storage

Azure Storage Explorer can authenticate and access storage using **multiple methods**:

### 1. **Account Keys (Management Plane)**

- Storage Explorer attempts to **list and retrieve storage account keys**
- This is a **write-equivalent operation** (POST request to list keys)
- ReadOnly lock **BLOCKS** this operation
- Result: ❌ Access denied

### 2. **Azure AD / RBAC (Data Plane)**

- Uses your Azure AD identity with data plane roles
- Directly accesses blobs/files without needing account keys
- ReadOnly lock does **NOT** block this
- Result: ✓ Should work

### 3. **SAS Tokens**

- Uses pre-generated shared access signatures
- ReadOnly lock does **NOT** block this
- Result: ✓ Should work

## Why ReadOnly Locks Cause the Error

When Storage Explorer opens and tries to browse a storage account:

```
1. Storage Explorer connects to storage account
2. Attempts to list containers/shares
3. Tries to retrieve account keys (common default method)
4. POST /listKeys operation is attempted
5. ReadOnly lock intercepts: "NO MODIFICATIONS ALLOWED"
6. Error: "Unable to list resources due to inadequate permissions"
```

## The Confusing Part

The error message says "**inadequate permissions**," but it's actually:

- Not about RBAC permissions ✗
- About the **lock preventing the listKeys operation** ✓

Even if you have **Owner** or **Contributor** role, the ReadOnly lock **overrides** your permissions and blocks management plane operations.

## Visual Representation

```
Without ReadOnly Lock:
User → Storage Explorer → List Keys API → ✓ Success → Browse Storage

With ReadOnly Lock:
User → Storage Explorer → List Keys API → ✗ BLOCKED by Lock → Error Message
```

## How to Verify This is the Issue

1. Check if a ReadOnly lock exists:

   ```
   Storage Account → Locks → See "ReadOnly" lock
   ```

2. Remove the lock temporarily and test Storage Explorer
   - If it works now, the lock was the problem

## Solutions When ReadOnly Lock Exists

**Option 1: Remove the Lock** (if policy allows)

- Not always possible due to governance requirements

**Option 2: Use Azure AD Authentication**

- In Storage Explorer, explicitly connect using "Azure AD"
- Assign proper data plane roles (Storage Blob Data Reader)
- Bypasses the need for account keys

**Option 3: Use SAS Tokens**

- Generate SAS token before the lock was applied
- Connect to storage using SAS URL

**Option 4: Use Azure Portal**

- Portal has built-in handling for locked resources
- May provide better error messages

## Key Takeaway

ReadOnly locks block the **listKeys operation** that Storage Explorer commonly uses for authentication. While users might have proper RBAC permissions, the lock creates a hard stop at the management plane level, preventing Storage Explorer from retrieving the keys needed to access the data using the default authentication method.

The solution is either:

- Remove the lock, OR
- Use authentication methods that don't require listing keys (Azure AD, SAS tokens)

</details>

---

<img src='.img/2026-01-30-05-58-51.png' width=700>

<details>
<summary>Click to expand explanation</summary>

Looking at your answer, I can explain why you got the File storage authorization wrong.

## Your Answer

- **Blob storage**: Microsoft Entra ID, access keys, and SAS ✓
- **File storage**: Microsoft Entra ID only ✗

## The Problem

You selected **Microsoft Entra ID only** for File storage, which is incorrect because:

### 1. **Microsoft Entra ID has LIMITED/NO support for Azure Files with AzCopy**

While Microsoft Entra ID (Azure AD) works excellently for **Blob storage** with AzCopy, it has **very limited or no support** for **Azure Files** (File shares).

AzCopy's Azure AD authentication is primarily designed for:

- ✓ Blob storage
- ✓ Azure Data Lake Storage Gen2
- ✗ Azure Files (not supported or very limited)

### 2. **You Excluded Valid Methods**

The scenario explicitly states:
> "You have access to the storage account access keys for the source storage accounts and for DevStore. You also have valid Microsoft Entra user accounts and **shared access signatures (SAS)**."

For Azure Files, AzCopy **DOES support**:

- ✓ **SAS tokens** - Fully supported and commonly used
- ✓ **Access keys** - Supported
- ✗ **Microsoft Entra ID** - Not supported/limited

## The Correct Answer Should Be

- **Blob storage**: Microsoft Entra ID, access keys, and SAS ✓
- **File storage**: **Access keys and SAS** (or possibly just SAS)

## Why This Matters

The critical distinction:

| Storage Type | Entra ID | Access Keys | SAS |
|-------------|----------|-------------|-----|
| **Blob Storage** | ✓ Yes | ✓ Yes | ✓ Yes |
| **File Storage** | ✗ Limited/No | ✓ Yes | ✓ Yes |

## Key Detail: "Commands target only the file share or the account"

This hint suggests:

- **File share level**: Use SAS tokens (most common)
- **Account level**: Use access keys

Both are valid for Azure Files, but **not** Microsoft Entra ID.

## AzCopy Command Examples

**For Blob (with Entra ID):**

```bash
azcopy login
azcopy copy "source" "https://devstore.blob.core.windows.net/container"
```

**For File Storage (with SAS):**

```bash
azcopy copy "source" "https://devstore.file.core.windows.net/share?<SAS-token>"
```

**For File Storage (with Account Key):**

```bash
# Set environment variable
export AZCOPY_ACCOUNT_KEY="<account-key>"
azcopy copy "source" "https://devstore.file.core.windows.net/share"
```

## Key Takeaway

**Microsoft Entra ID authentication is NOT supported for Azure Files with AzCopy**, unlike Blob storage where it works perfectly. For File storage, you must use **SAS tokens or access keys**. Don't assume that authentication methods work the same across all storage types!

</details>

---

<img src='.img/2026-01-30-05-31-43.png' width=700>


---

<img src='.img/2026-01-30-05-50-54.png' width=700>


<details>
<summary>Click to expand explanation</summary>

You're absolutely right! Let me correct my response.

## Your Selected Answers

- **$action** (not visible in dropdown, but should be first): ✗ Wrong cmdlet used
- **$filter**: New-AzStorageAccountManagementPolicyFilter ✓
- **$rule2**: New-AzStorageBlobInventoryPolicyRule ✗
- **Final command**: Set-AzStorageBlobInventoryPolicy ✗

## The Problem - You Mixed Up Two Different Features

You confused **Lifecycle Management Policies** with **Blob Inventory Policies**, AND the first command uses the wrong cmdlet structure.

### The Correct Script Structure

```powershell
$rgName = "RgGroup01"
$accountName = "storageaccount01"

$action = Add-AzStorageAccountManagementPolicyAction `  ✓ CORRECT
    -BaseBlobAction TierToCool `
    -daysAfterModificationGreaterThan 30

$filter = New-AzStorageAccountManagementPolicyFilter `  ✓ CORRECT
    -PrefixMatch ef,gh `
    -BlobType blockBlob

$rule2 = New-AzStorageAccountManagementPolicyRule `  ✓ CORRECT
    -Name test-rule `
    -Action $action `
    -Filter $filter

Set-AzStorageAccountManagementPolicy `  ✓ CORRECT
    -ResourceGroupName $rgName `
    -StorageAccountName $accountName `
    -Rule $rule2
```

## The Correct Cmdlets

1. **$action**: `Add-AzStorageAccountManagementPolicyAction`
   - **ADD** an action to the policy (TierToCool after 30 days)

2. **$filter**: `New-AzStorageAccountManagementPolicyFilter` ✓ You got this one
   - **CREATE** a filter (which blobs to target)

3. **$rule2**: `New-AzStorageAccountManagementPolicyRule`
   - **CREATE** a rule by combining action + filter
   - ✗ You used: `New-AzStorageBlobInventoryPolicyRule` (wrong - for inventory)

4. **Final**: `Set-AzStorageAccountManagementPolicy`
   - **SET/APPLY** the management policy to the storage account
   - Creates or modifies the management policy of an Azure Storage account.
   - ✗ You used: `Set-AzStorageBlobInventoryPolicy` (wrong - for inventory)

## Why Your Answer Was Wrong

### Issue #1: Wrong Cmdlet Pattern for $action

The first command should use `Add-AzStorageAccountManagementPolicyAction` to **add an action** (what to do with the blobs).

### Issue #2: Inventory vs Management (Last Two Cmdlets)

**You selected:**

- `New-AzStorageBlobInventoryPolicyRule` ✗ (creates inventory reports)
- `Set-AzStorageBlobInventoryPolicy` ✗ (applies inventory policy)

**Should be:**

- `New-AzStorageAccountManagementPolicyRule` ✓ (creates lifecycle rule)
- `Set-AzStorageAccountManagementPolicy` ✓ (applies lifecycle policy)

## The Logic Flow

1. **$action** = `Add-AzStorageAccountManagementPolicyAction`
   - Define WHAT to do: "Tier to Cool after 30 days"

2. **$filter** = `New-AzStorageAccountManagementPolicyFilter` ✓
   - Define WHICH blobs: "blockBlobs with prefix ef,gh"

3. **$rule2** = `New-AzStorageAccountManagementPolicyRule`
   - Combine action + filter = complete rule

4. **Apply** = `Set-AzStorageAccountManagementPolicy`
   - Apply the rule to the storage account

## Cmdlet Naming Pattern

| Step | Verb | Object |
|------|------|--------|
| Create action | **Add**-AzStorageAccount**ManagementPolicyAction** | Action definition |
| Create filter | **New**-AzStorageAccount**ManagementPolicyFilter** | Filter definition |
| Create rule | **New**-AzStorageAccount**ManagementPolicyRule** | Rule (action + filter) |
| Apply policy | **Set**-AzStorageAccount**ManagementPolicy** | Complete policy |

## Key Differences

### Lifecycle Management (What you need)

```powershell
Add-AzStorageAccountManagementPolicyAction      # Define action
New-AzStorageAccountManagementPolicyFilter      # Define filter
New-AzStorageAccountManagementPolicyRule        # Combine to rule
Set-AzStorageAccountManagementPolicy            # Apply policy
# Purpose: Move blobs between tiers, delete old blobs
```

### Blob Inventory (What you incorrectly selected)

```powershell
New-AzStorageBlobInventoryPolicyRule            # ✗ Wrong!
Set-AzStorageBlobInventoryPolicy                # ✗ Wrong!
# Purpose: Generate CSV/Parquet reports of blob metadata
```

## Key Takeaway

1. **Use `Add-` for actions**, `New-` for filters and rules, `Set-` to apply
2. **Management Policy ≠ Inventory Policy**
   - **Management Policy** = Lifecycle automation (tier/delete based on rules)
   - **Inventory Policy** = Generate reports about blob metadata
3. All cmdlets must have `*ManagementPolicy*` in the name for lifecycle management tasks
4. The cmdlet structure follows a pattern: Add action → Create filter → Create rule → Set policy

</details>

---

<img src='.img/2026-01-30-06-01-29.png' width=700>

---

<img src='.img/2026-01-30-05-38-46.png' width=700>

---

<img src='.img/2026-01-30-06-12-43.png' width=700>

---

<img src='.img/2026-01-30-05-53-50.png' width=700>

---

<img src='.img/2026-01-30-05-30-07.png' width=700>

---

<img src='.img/2026-01-30-05-26-15.png' width=700>

---

<img src='.img/2026-01-30-06-20-01.png' width=700>

---

<img src='.img/2026-01-30-05-36-07.png' width=700>

---

<img src='.img/2026-01-30-05-41-40.png' width=700>

---

## Correctly Answered Questions

<img src='.img/2026-01-30-05-24-16.png' width=700>

---

<img src='.img/2026-01-30-05-24-56.png' width=700>

---

<img src='.img/2026-01-30-05-34-11.png' width=500>

---

<img src='.img/2026-01-30-05-55-46.png' width=700>

---

<img src='.img/2026-01-30-05-57-13.png' width=700>

---

<img src='.img/2026-01-30-05-59-35.png' width=700>

---

<img src='.img/2026-01-30-06-00-11.png' width=700>

---

<img src='.img/2026-01-30-06-03-32.png' width=700>

---

<img src='.img/2026-01-30-06-06-46.png' width=700>

---

<img src='.img/2026-01-30-06-08-51.png' width=700>

---

<img src='.img/2026-01-30-06-10-09.png' width=700>

---

<img src='.img/2026-01-30-06-15-31.png' width=700>

---

<img src='.img/2026-01-30-06-17-12.png' width=700>

---

<img src='.img/2026-01-30-06-17-46.png' width=700>

---

<img src='.img/2026-01-30-06-18-07.png' width=700>

---

<img src='.img/2026-01-30-06-21-46.png' width=700>

---

<img src='.img/2026-01-30-06-23-03.png' width=700>
