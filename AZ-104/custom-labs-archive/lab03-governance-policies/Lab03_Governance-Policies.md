# Lab 3 – Governance & Policies

**Domain:** Manage Azure identities and governance  
**Difficulty:** Medium (≈8–10 hrs)  
**Dependencies:** Lab 2 – Role-Based Access & Scoping

---

<!-- omit in toc -->
## 📊 Exercise Progress

Track your progress through the lab exercises:

- ✅ Exercise 1 – Understanding Azure Policy Fundamentals
- 🔄 Exercise 2 – Create and Assign Built-in Policies
- ⬜ Exercise 3 – Create Custom Policy Definitions
- ⬜ Exercise 4 – Implement Policy Initiatives
- ⬜ Exercise 5 – Configure Policy Remediation
- ⬜ Exercise 6 – Implement Resource Locks
- ⬜ Exercise 7 – Implement and Manage Resource Tags
- ⬜ Exercise 8 – Move Resources Between Resource Groups and Subscriptions
- ⬜ Exercise 9 – Configure Management Groups

**Status:** ⬜ Not Started | 🔄 In Progress | ✅ Completed

---

<!-- omit in toc -->
## 🧾 Contents

- [🎯 Lab Objective](#-lab-objective)
- [🧱 Skills Measured (Exam Outline)](#-skills-measured-exam-outline)
- [🧠 Scenario](#-scenario)
- [⚙️ Environment Setup](#️-environment-setup)
- [🔧 Command Reference](#-command-reference)
  - [PowerShell Commands](#powershell-commands)
  - [Azure CLI Commands](#azure-cli-commands)
  - [Terraform Commands](#terraform-commands)
  - [Bicep Commands](#bicep-commands)
- [🔹 Exercise 1 – Understanding Azure Policy Fundamentals](#-exercise-1--understanding-azure-policy-fundamentals)
- [🔹 Exercise 2 – Create and Assign Built-in Policies](#-exercise-2--create-and-assign-built-in-policies)
- [🔹 Exercise 3 – Create Custom Policy Definitions](#-exercise-3--create-custom-policy-definitions)
- [🔹 Exercise 4 – Implement Policy Initiatives](#-exercise-4--implement-policy-initiatives)
- [🔹 Exercise 5 – Configure Policy Remediation](#-exercise-5--configure-policy-remediation)
- [🔹 Exercise 6 – Implement Resource Locks](#-exercise-6--implement-resource-locks)
- [🔹 Exercise 7 – Implement and Manage Resource Tags](#-exercise-7--implement-and-manage-resource-tags)
- [🔹 Exercise 8 – Move Resources Between Resource Groups and Subscriptions](#-exercise-8--move-resources-between-resource-groups-and-subscriptions)
- [🔹 Exercise 9 – Configure Management Groups](#-exercise-9--configure-management-groups)
- [🧭 Reflection & Readiness](#-reflection--readiness)
- [📚 References](#-references)

---

## 🎯 Lab Objective

Master Azure governance and policy management to ensure compliance, cost control, and standardization across Azure resources.

You will:

- Understand the relationship between policy definitions, assignments, and initiatives
- Create and assign built-in and custom Azure policies
- Implement policy remediation and compliance tracking
- Protect resources using resource locks
- Organize and manage resources using tags
- Move resources between resource groups and subscriptions
- Establish hierarchical governance using management groups

---

## 🧱 Skills Measured (Exam Outline)

**Manage Azure subscriptions and governance**

- Configure and manage Azure Policy
- Configure resource locks
- Apply and manage tags on resources
- Manage resource groups
- Manage subscriptions
- Configure management groups

---

## 🧠 Scenario

You are the Azure Administrator for Contoso Corporation, a growing enterprise with multiple departments deploying Azure resources. Recently, the organization has experienced:

- **Compliance violations**: Resources deployed without required tags or in unauthorized regions
- **Cost overruns**: Resources created without proper naming conventions or cost tracking
- **Security concerns**: Critical resources accidentally deleted or modified
- **Sprawl**: Resources scattered across multiple subscriptions without consistent governance

Your mission is to implement a comprehensive governance framework using Azure Policy, resource locks, tagging strategies, and management groups to ensure:

1. **Compliance**: All resources meet organizational standards
2. **Security**: Critical resources are protected from accidental changes
3. **Cost Management**: Resources are properly tagged for cost allocation
4. **Organization**: Resources are logically organized across subscriptions

---

## ⚙️ Environment Setup

### Prerequisites

1. **Azure Subscription**: Active subscription with Owner or Contributor + User Access Administrator rights
2. **Completed Labs**: Lab 1 (Identity Baseline) and Lab 2 (RBAC) recommended
3. **PowerShell Modules** (if using PowerShell):

   ```powershell
   Install-Module -Name Az.Resources -Force -AllowClobber
   Install-Module -Name Az.PolicyInsights -Force -AllowClobber
   Connect-AzAccount
   ```

4. **Azure CLI** (if using CLI):

   ```bash
   az login
   az account set --subscription "<Your-Subscription-ID>"
   ```

### Resource Group Setup

Create a resource group for this lab:

```powershell
# PowerShell
New-AzResourceGroup -Name "rg-governance-lab" -Location "eastus"
```

```bash
# Azure CLI
az group create --name rg-governance-lab --location eastus
```

---

## 🔧 Command Reference

Quick reference of all commands used in this lab, organized by tool.

### PowerShell Commands

| Command                        | Purpose                                    | Exercise |
| ------------------------------ | ------------------------------------------ | -------- |
| `Get-AzPolicyDefinition`       | List and query policy definitions          | 1, 2     |
| `Get-AzPolicyAssignment`       | List policy assignments                    | 1, 2, 3  |
| `New-AzPolicyDefinition`       | Create custom policy definition            | 3        |
| `New-AzPolicyAssignment`       | Assign policy to scope                     | 2, 3, 4  |
| `Remove-AzPolicyAssignment`    | Remove policy assignment                   | 2, 5     |
| `Get-AzPolicyState`            | Get policy compliance state                | 2, 5     |
| `Start-AzPolicyComplianceScan` | Trigger on-demand policy evaluation scan   | 2        |
| `Start-AzPolicyRemediation`    | Start remediation task                     | 5        |
| `Get-AzPolicySetDefinition`    | List policy initiatives                    | 4        |
| `New-AzPolicySetDefinition`    | Create policy initiative                   | 4        |
| `New-AzResourceLock`           | Create resource lock                       | 6        |
| `Get-AzResourceLock`           | List resource locks                        | 6        |
| `Remove-AzResourceLock`        | Remove resource lock                       | 6        |
| `New-AzTag`                    | Create tag on resource                     | 7        |
| `Update-AzTag`                 | Update tags on resource                    | 7        |
| `Get-AzTag`                    | List tags                                  | 7        |
| `Move-AzResource`              | Move resource between groups/subscriptions | 8        |
| `Get-AzManagementGroup`        | List management groups                     | 9        |
| `New-AzManagementGroup`        | Create management group                    | 9        |

### Azure CLI Commands

| Command                              | Purpose                                    | Exercise |
| ------------------------------------ | ------------------------------------------ | -------- |
| `az policy definition list`          | List policy definitions                    | 1, 2     |
| `az policy assignment list`          | List policy assignments                    | 1, 2, 3  |
| `az policy definition create`        | Create custom policy definition            | 3        |
| `az policy assignment create`        | Assign policy to scope                     | 2, 3, 4  |
| `az policy assignment delete`        | Remove policy assignment                   | 2, 5     |
| `az policy state list`               | Get policy compliance state                | 2, 5     |
| `az policy state trigger-scan`       | Trigger on-demand policy evaluation scan   | 2        |
| `az policy remediation create`       | Start remediation task                     | 5        |
| `az policy set-definition list`      | List policy initiatives                    | 4        |
| `az policy set-definition create`    | Create policy initiative                   | 4        |
| `az lock create`                     | Create resource lock                       | 6        |
| `az lock list`                       | List resource locks                        | 6        |
| `az lock delete`                     | Remove resource lock                       | 6        |
| `az tag create`                      | Create tag on resource                     | 7        |
| `az tag update`                      | Update tags on resource                    | 7        |
| `az tag list`                        | List tags                                  | 7        |
| `az resource move`                   | Move resource between groups/subscriptions | 8        |
| `az account management-group list`   | List management groups                     | 9        |
| `az account management-group create` | Create management group                    | 9        |

### Terraform Commands

| Command             | Purpose                                | Exercise      |
| ------------------- | -------------------------------------- | ------------- |
| `terraform init`    | Initialize Terraform working directory | 2, 3, 4, 6, 7 |
| `terraform plan`    | Preview infrastructure changes         | 2, 3, 4, 6, 7 |
| `terraform apply`   | Apply Terraform configuration          | 2, 3, 4, 6, 7 |
| `terraform destroy` | Destroy Terraform-managed resources    | All           |

### Bicep Commands

Bicep templates are deployed using `New-AzResourceGroupDeployment` (PowerShell) or `az deployment group create` (CLI).

---

## 🔹 Exercise 1 – Understanding Azure Policy Fundamentals

**Goal:** Understand the core concepts of Azure Policy, including definitions, assignments, parameters, and the policy evaluation flow.

**📚 Related Documentation:**

- [What is Azure Policy?](https://learn.microsoft.com/en-us/azure/governance/policy/overview)
- [Azure Policy definition structure](https://learn.microsoft.com/en-us/azure/governance/policy/concepts/definition-structure)
- [Understanding policy effects](https://learn.microsoft.com/en-us/azure/governance/policy/concepts/effects)
- [Azure Policy assignment structure](https://learn.microsoft.com/en-us/azure/governance/policy/concepts/assignment-structure)
- [Azure Policy scope](https://learn.microsoft.com/en-us/azure/governance/policy/concepts/scope)
- [Tutorial: Create and manage policies to enforce compliance](https://learn.microsoft.com/en-us/azure/governance/policy/tutorials/create-and-manage)

### Key Concepts

#### 1. Policy Definition

A **policy definition** describes a compliance condition and the action to take if the condition is met. Policy definitions are written in JSON and contain:

- **Policy rule**: The condition logic (if-then statement)
- **Effect**: The action to take (Deny, Audit, Append, Modify, etc.)
- **Parameters**: Optional values that make the policy reusable

**Example policy rule structure:**

```json
{
  "if": {
    "field": "location",
    "notIn": ["eastus", "westus"]
  },
  "then": {
    "effect": "deny"
  }
}
```

#### 2. Policy Assignment

A **policy assignment** is the act of assigning a policy definition to a specific scope (management group, subscription, resource group). Assignments can:

- Override default parameter values
- Apply to specific scopes with exclusions
- Be enabled or disabled

#### 3. Policy Effects

Common policy effects:

| Effect                | Description                                 | Use Case                                     |
| --------------------- | ------------------------------------------- | -------------------------------------------- |
| **Deny**              | Prevents resource creation/modification     | Enforce region restrictions, SKU limitations |
| **Audit**             | Creates warning event in activity log       | Monitor compliance without blocking          |
| **AuditIfNotExists**  | Audits if related resource doesn't exist    | Check for diagnostic settings, extensions    |
| **Append**            | Adds fields to the resource during creation | Add default tags                             |
| **Modify**            | Adds, updates, or removes properties        | Modify tags, enable features                 |
| **DeployIfNotExists** | Deploys resource if it doesn't exist        | Auto-deploy diagnostic settings, extensions  |
| **Disabled**          | Policy is not evaluated                     | Temporarily disable without unassigning      |

**Order of Evaluation:**

Azure Policy evaluates effects in a specific order during resource operations. Understanding this order is critical for predicting policy behavior:

1. **Disabled** - Checked first to determine if the policy rule should be evaluated
2. **Append** and **Modify** - Evaluated next; these can alter the resource request before compliance is assessed
3. **Deny** - Evaluated before Audit effects to prevent non-compliant resources from being created
4. **Audit** and **AuditIfNotExists** - Evaluated after Deny to log compliance issues
5. **DeployIfNotExists** - Evaluated last to deploy supporting resources if needed

**Key insights:**

- **Append** and **Modify** run *before* **Deny**, so they can transform a request to make it compliant
- **Deny** takes precedence over **Audit** - if a resource is denied, audit events are not generated
- Multiple policies with different effects can apply to the same resource, evaluated in this order

**Example scenario:** A policy with **Append** adds a required tag, then a **Deny** policy checks for that tag. Because Append runs first, the Deny policy sees the modified request and allows it.

📚 [Learn more about order of evaluation](https://learn.microsoft.com/en-us/azure/governance/policy/concepts/effect-basics#order-of-evaluation)

#### 4. Policy Evaluation Flow

1. **Resource operation** is initiated (create, update, delete)
2. **Azure Policy** evaluates the request against assigned policies
3. **Effect** is applied based on compliance state
4. **Compliance state** is recorded and visible in Azure Policy dashboard

### Explore Existing Policies via Azure Portal

1. Navigate to **Azure Portal** → **Policy**
2. Under **Authoring**, select **Definitions**
3. Browse built-in policy definitions
4. Filter by category (e.g., "Compute", "Storage", "Monitoring")
5. Click on a policy to view:
   - Policy rule (JSON)
   - Parameters
   - Effect type
   - Policy type (Built-in, Custom)

<img src='.img/2025-10-30-04-54-45.png' width=900>

### List Policy Definitions Using PowerShell

There are over 3,000 built-in policy definitions available in Azure.

<img src='.img/2025-10-30-04-59-18.png' width=250>

```powershell
# Get policy count by category
Get-AzPolicyDefinition | 
    Select-Object -ExpandProperty Metadata | 
    Group-Object category | 
    Select-Object @{Name='Category';Expression={$_.Name}}, 
                  @{Name='PolicyCount';Expression={$_.Count}} | 
    Sort-Object PolicyCount -Descending | 
    Format-Table -AutoSize
```

<img src='.img/2025-10-30-05-10-56.png' width=450>

```powershell
# Show matching policy plus full rule JSON for “Do not allow deletion” definitions
Get-AzPolicyDefinition |
    Where-Object DisplayName -match 'Do not allow deletion' |
    Select-Object DisplayName, Name, @{
        Name       = 'PolicyRule'
        Expression = { $_.PolicyRule | ConvertTo-Json -Depth 10 }
    } |
    Format-List
```

<img src='.img/2025-10-30-05-46-20.png' width=600>

```powershell
# Get details of a specific policy
$policy = Get-AzPolicyDefinition -Name "78460a36-508a-49a4-b2b2-2f5ec564f4bb"
$policy.DisplayName
$policy.Description
$policy.PolicyRule | ConvertTo-Json -Depth 10
```

<img src='.img/2025-10-30-05-49-39.png' width=700>

### List Policy Definitions Using Azure CLI

```bash
# Get all built-in policy definitions
az policy definition list \
--query "[?policyType=='BuiltIn'].{Name:name, Category:metadata.category, DisplayName:displayName}" \
--output table | less -S
```

<img src='.img/2025-10-31-04-44-34.png' width=800>

**Note:**

- `less -S` disables line wrapping and allows horizontal scrolling in the terminal.
- The query syntax uses JMESPath for filtering and formatting output.

```bash
# List the properties of the first policy definition
az policy definition list --query "[0]" --output json
```

<img src='.img/2025-10-31-05-11-13.png' width=800>

Use the `jq` command to get some nice formatting:

<img src='.img/2025-10-31-05-12-09.png' width=800>

```bash
# Get the first policy definition containing "deletion" with expanded JSON output
az policy definition list \
    --query "[?contains(displayName, 'deletion')] | [0]" \
    --output json | jq .
```

<img src='.img/2025-10-31-05-39-16.png' width=600>

```bash
# Get the policy and specified fields only, including expanded JSON
az policy definition list \
    --query "[?contains(displayName, 'deletion')] | [0]" \
    --output json | jq '{DisplayName: .displayName, Name: .name, PolicyRule: .policyRule}'
```

<img src='.img/2025-10-31-05-46-01.png' width=700>

```bash
# Get details of a specific policy
az policy definition show --name e56962a6-4747-49cd-b67b-bf8b01975c4c
```

<img src='.img/2025-11-03-02-10-21.png' width=700>

You must specify the GUID; you cannot use the display name.

### Understanding Policy Scopes

Azure Policy can be assigned at multiple scopes:

```txt
Management Group (highest)
    ↓
Subscription
    ↓
Resource Group
    ↓
Resource (lowest)
```

**Key principles:**

- Policies assigned at higher scopes **inherit** to lower scopes
- You can **exclude** specific scopes from policy assignments
- **Exemptions** can be granted for specific resources
- Lower scope assignments **do not** override higher scope denies

### Exam Insights

💡 **Exam Tip:** Understand the difference between:

- **Policy Definition**: The rule itself (reusable template)
- **Policy Assignment**: Applying the rule to a scope
- **Initiative** (Policy Set): A group of related policies assigned together

💡 **Exam Tip:** Know the policy effects and when to use each:

- Use **Deny** to prevent non-compliant resources
- Use **Audit** to monitor compliance without blocking
- Use **DeployIfNotExists** for automatic remediation
- Use **Modify** to change resource properties

💡 **Exam Tip:** Policy evaluation happens during resource **creation and updates**, not continuously. Existing resources are evaluated on a compliance scan schedule (every 24 hours by default).

---

## 🔹 Exercise 2 – Create and Assign Built-in Policies

**Goal:** Assign built-in Azure policies to enforce resource compliance, such as allowed locations, required tags, and allowed SKUs.

**📚 Related Documentation:**

- [Assign a policy - Portal](https://learn.microsoft.com/en-us/azure/governance/policy/assign-policy-portal)
- [Assign a policy - PowerShell](https://learn.microsoft.com/en-us/azure/governance/policy/assign-policy-powershell)
- [Assign a policy - Azure CLI](https://learn.microsoft.com/en-us/azure/governance/policy/assign-policy-azurecli)
- [Azure Policy built-in definitions](https://learn.microsoft.com/en-us/azure/governance/policy/samples/built-in-policies)
- [Understand policy compliance](https://learn.microsoft.com/en-us/azure/governance/policy/how-to/get-compliance-data)

### Scenario: Enforce Allowed Locations

Contoso wants to ensure all resources are deployed only in approved regions (East US and West US) to meet data residency requirements.

### Using the Azure Portal

1. Navigate to **Azure Portal** → **Policy**
2. Under **Authoring**, select **Assignments**
3. Click **Assign policy**
4. Configure assignment:
   - **Scope**: Select your subscription or resource group
   - **Exclusions**: (Optional) Exclude specific resource groups
   - **Policy definition**: Search for "Allowed locations"
   - Select **"Allowed locations"** (built-in policy)

    <img src='.img/2025-11-03-02-20-23.png' width=600>

5. Click **Next** to configure parameters
6. **Allowed locations**: Select **East US** and **West US**

    <img src='.img/2025-11-03-02-21-04.png' width=600>

7. Click **Next** through Remediation and Non-compliance messages
8. **Review + create** → **Create**

    <img src='.img/2025-11-03-02-22-46.png' width=700>

### Using PowerShell

```powershell
$definition = Get-AzPolicyDefinition | Where-Object {
    $_.DisplayName -eq 'Allowed locations' 
}

$allowedLocations = @('eastus', 'westus')

$policyParam = @{
    'listOfAllowedLocations' = $allowedLocations
}

$subscriptionId = (Get-AzContext).Subscription

New-AzPolicyAssignment `
    -Name 'allowed-locations-policy' `
    -DisplayName 'Allowed Locations - East US and West US Only' `
    -Scope "/subscriptions/$subscriptionId" `
    -PolicyDefinition $definition `
    -PolicyParameterObject $policyParam `
    -Description 'Restricts resource deployment to East US and West US regions'

Get-AzPolicyAssignment -Name 'allowed-locations-policy'
```

<img src='.img/2025-11-04-03-27-36.png' width=500>

### Using Azure CLI

```bash
# Get the policy definition ID
az policy definition list \
    --output tsv \
    --query "[?displayName=='Allowed locations'].id" 
```

<img src='.img/2025-11-12-04-57-47.png' width=600>

```bash
# List policies with "allowed" in the display name
az policy definition list \
    --output table \
    --query "[?contains(displayName,'allowed')].{Name:name,DisplayName:displayName}"
```

<img src='.img/2025-11-12-04-55-58.png' width=500>

```bash
# List policy categories
az policy definition list \
    --output json \
    --query "[*].metadata.category" \
    | jq -r '.[]' \
    | sort | uniq
```

<img src='.img/2025-11-12-04-39-54.png' width=300>

**Note:** The JMESPath query language does not provide any facilities for removing duplicates, so we use `jq`, `sort`, and `uniq` to get unique category names. This is by design, as tasks like deduplication, sorting, or aggregation are intentionally left to downstream tools.

The `jq` notation `.[]` extracts (iterates through) each element from the JSON array rather than `.` which would return the entire array structure.

**Note:** Use double quotes `"` for JMESPath queries in Azure CLI and use single quotes `'` for shell commands, e.g. `jq`, to avoid conflicts.

```bash
# List policies in the "Network" category
az policy definition list \
    --output table \
    --filter "category eq 'Network'" \
    --query "[*].{Category:metadata.category,DisplayName:displayName}"
```

<img src='.img/2025-11-11-05-49-42.png' width=800>

**Note:** This command uses a combination of `--filter` and `--query` to narrow down the results to a specific category. The `--filter` parameter applies server-side filtering using OData syntax, while the `--query` parameter uses JMESPath syntax to format the output on the client side.

The `az policy definition list` command only supports certain types of filters. See [URI Parameters](https://learn.microsoft.com/en-us/rest/api/policy/policy-definitions/list?view=rest-policy-2023-04-01&tabs=HTTP#uri-parameters) for more information.

```bash
# Assign the policy to subscription scope
az policy assignment create \
    --name 'allowed-locations-policy' \
    --scope "/subscriptions/$( az account show --query id --output tsv )" \
    --policy $( az policy definition list --query "[?displayName=='Allowed locations'][name]" --output tsv ) \
    --params '{
            "listOfAllowedLocations": {
                    "value": ["eastus", "westus"]
            }
    }' \
    --description 'Restricts resource deployment to East US and West US regions'
```

<img src='.img/2025-11-13-04-06-27.png' width=700>

**Note:** the use of `jq` is optional but provides color formatting and better readability for JSON output in the terminal.

```bash
# Verify the assignment
az policy assignment show --name 'allowed-locations-policy'
```

<img src='.img/2025-11-13-04-08-30.png' width=600>

### Test the Policy

Confirm the policy definition and policy assignment are in place.

```bash
az policy assignment list --query "[?contains(name,'allowed')]" \
    | jq '.[] | {name, description, policyDefinitionId}'
```

<img src='.img/2025-11-20-03-32-28.png' width=700>

You'll need the GUID from the `policyDefinitionId` property for the next steps:

```bash
az policy assignment list --query "[?contains(name,'allowed')]" \
    | jq '.[] | {
        name,
        description,
        policyDefinitionGuid: (.policyDefinitionId | split("/")[-1])
    }'
```

The snippet above shows how to extract the GUID from the full policy definition ID using `jq` string manipulation functions.

<img src='.img/2025-11-20-03-39-26.png' width=600>

You can store the GUID in a variable for use in finding the policy definition. Note the `-r` flag to get raw string output without quotes:

```bash
GUID=$(az policy assignment list --query "[?contains(name,'allowed')]" \
    | jq -r '.[0].policyDefinitionId | split("/")[-1]')
```

<img src='.img/2025-11-20-03-47-40.png' width=550>

From there, you an pull details about the policy definition itself:

```bash
az policy definition show --name $GUID | jq '. | {name, description}'
```

<img src='.img/2025-11-20-03-53-25.png' width=650>

Notice the policy definition description excludes resource groups, so you must test at the resource level.

Now, try to create a resource in a non-allowed region, e.g. `southcentralus`:

```bash
az storage account create \
    -n testpolicysa$RANDOM \
    -g rg-dev-test \
    -l southcentralus \
    --sku Standard_LRS
```

Expected error:

<img src='.img/2025-11-20-04-02-15.png' width=600>

For cleanup, delete the policy assignment:

```bash
# Delete the policy assignment
GUID=$(az policy definition list --query "[?displayName=='Allowed locations'].id" |
    jq -r '.[0] | split("/")[-1]')

az policy assignment delete --name $GUID
```

<img src='.img/2025-11-20-04-09-47.png' width=550>

### Assign Additional Built-in Policies

#### Require a tag on resource groups

The following PowerShell and Az commands command create a policy assignment that requires all resource groups to have a `CostCenter` tag.

The policy definition rule accepts `tagName` as a parameter, which is set to `CostCenter` in this case.

<img src='.img/2025-12-15-03-59-03.png' width=500>

```powershell
# PowerShell
$subscriptionId = Get-AzContext | Select-Object -ExpandProperty Subscription

$definition = Get-AzPolicyDefinition | Where-Object { 
    $_.DisplayName -eq 'Require a tag on resource groups' 
}

$policyParam = @{
    'tagName' = 'CostCenter'
}

New-AzPolicyAssignment `
    -Name 'require-costcenter-tag-rg' `
    -DisplayName 'Require CostCenter Tag on Resource Groups' `
    -Scope "/subscriptions/$($subscriptionId)" `
    -PolicyDefinition $definition `
    -PolicyParameterObject $policyParam
```

<img src='.img/2025-12-15-03-54-28.png' width=700>

```bash
# Azure CLI
subscriptionId=$(az account show --query id -o tsv)

definitionId=$( \
    az policy definition list \
        --query "[?contains(displayName, 'Require a tag on resource groups')].name" \
        -o tsv
)

az policy assignment create \
    --name 'require-costcenter-tag-rg' \
    --display-name 'Require CostCenter Tag on Resource Groups' \
    --scope /subscriptions/$subscriptionId \
    --policy $definitionId \
    --params '{
        "tagName": {
            "value": "CostCenter"
        }
    }'
```

<img src='.img/2025-12-17-04-29-46.png' width=700>

To confirm the assignment:

```bash
az policy assignment list --query "[?displayName && contains(displayName, 'CostCenter')].displayName" -o tsv
```

The `[?displayName && contains(...)]` syntax ensures that only assignments with a defined display name are evaluated, preventing errors from null values.

<img src='.img/2025-12-17-04-41-57.png' width=700>

Test resource group creation to confirm policy:

<img src='.img/2025-12-17-04-47-05.png' width=700>

#### Allowed virtual machine size SKUs

```powershell
# PowerShell
$subscriptionId = Get-AzContext | Select-Object -ExpandProperty Subscription

$definition = Get-AzPolicyDefinition | Where-Object { 
    $_.DisplayName -eq 'Allowed virtual machine size SKUs' 
}

$policyParam = @{
    'listOfAllowedSKUs' = @('Standard_B2s', 'Standard_B2ms', 'Standard_D2s_v3')
}

New-AzPolicyAssignment `
    -Name 'allowed-vm-skus' `
    -DisplayName 'Allowed VM SKUs - Budget-Friendly Only' `
    -Scope "/subscriptions/$($subscriptionId)" `
    -PolicyDefinition $definition `
    -PolicyParameterObject $policyParam
```

<img src='.img/2025-12-18-02-53-27.png' width=600>

### Using Bicep for Policy Assignment

```bash
# Get the policy definition ID of "Allowed locations" policy
az policy definition list --query "[?contains(displayName, 'Allowed locations')]" \
    | jq '.[] | {name, displayName}'
```

<img src='.img/2025-12-18-03-31-25.png' width=600>

Resulting GUID to be used in Bicep template: `e56962a6-4747-49cd-b67b-bf8b01975c4c`

Create `policy-assignment.bicep`:

```bicep
targetScope = 'subscription'

param policyDefinitionId string = '/providers/Microsoft.Authorization/policyDefinitions/e56962a6-4747-49cd-b67b-bf8b01975c4c'
param policyAssignmentName string = 'allowed-locations-policy'
param allowedLocations array = [
  'eastus'
  'westus'
]

resource policyAssignment 'Microsoft.Authorization/policyAssignments@2025-03-01' = {
  name: policyAssignmentName
  properties: {
    displayName: 'Allowed Locations - East US and West US Only'
    description: 'Restricts resource deployment to East US and West US regions'
    policyDefinitionId: policyDefinitionId
    parameters: {
      listOfAllowedLocations: {
        value: allowedLocations
      }
    }
  }
}

output policyAssignmentId string = policyAssignment.id
```

**References:**

- [Azure Policy assignment structure](https://learn.microsoft.com/en-us/azure/governance/policy/concepts/assignment-structure?utm_source=chatgpt.com#policy-definition-id-and-version-preview)
- [Microsoft.Authorization policyAssignments](https://learn.microsoft.com/en-us/azure/templates/microsoft.authorization/policyassignments?pivots=deployment-language-bicep)

Deploy the Bicep template:

```powershell
# PowerShell
New-AzSubscriptionDeployment `
    -Name 'policy-assignment-deployment' `
    -Location 'eastus' `
    -TemplateFile './bicep/policy-assignment.bicep'
```

<img src='.img/2026-01-06-06-07-43.png' width=800>

```bash
# Azure CLI
az deployment sub create \
    --name policy-assignment-deployment \
    --location eastus \
    --template-file ./bicep/policy-assignment.bicep
```

<img src='.img/2026-01-06-06-24-38.png' width=800>

### Using Terraform for Policy Assignment

Create `policy-assignment.tf`:

```hcl
terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.0"
    }
  }
}

provider "azurerm" {
  features {}
}

data "azurerm_subscription" "current" {}

# Assign Allowed Locations policy
resource "azurerm_subscription_policy_assignment" "allowed_locations" {
  name                 = "allowed-locations-policy"
  display_name         = "Allowed Locations - East US and West US Only"
  description          = "Restricts resource deployment to East US and West US regions"
  policy_definition_id = "/providers/Microsoft.Authorization/policyDefinitions/e56962a6-4747-49cd-b67b-bf8b01975c4c"
  subscription_id      = data.azurerm_subscription.current.id

  parameters = jsonencode({
    listOfAllowedLocations = {
      value = ["eastus", "westus"]
    }
  })
}

# Assign Require Tag on Resource Groups policy
resource "azurerm_subscription_policy_assignment" "require_costcenter_tag" {
  name                 = "require-costcenter-tag-rg"
  display_name         = "Require CostCenter Tag on Resource Groups"
  policy_definition_id = "/providers/Microsoft.Authorization/policyDefinitions/96670d01-0a4d-4649-9c89-2d3abc0a5025"
  subscription_id      = data.azurerm_subscription.current.id

  parameters = jsonencode({
    tagName = {
      value = "CostCenter"
    }
  })
}

output "allowed_locations_assignment_id" {
  value = azurerm_subscription_policy_assignment.allowed_locations.id
}

output "require_tag_assignment_id" {
  value = azurerm_subscription_policy_assignment.require_costcenter_tag.id
}
```

Deploy the Terraform configuration:

```bash
cd terraform/
terraform init
terraform plan
terraform apply -auto-approve
```

See [main.tf](terraform/main.tf) for a more comprehensive example.

### Check Policy Compliance

After assigning policies, check compliance status:

#### Using the Azure Portal

1. Navigate to **Azure Portal** → **Policy**
2. Click **Compliance** in the left menu
3. View overall compliance score
4. Click on a policy assignment to see detailed compliance data
5. Review compliant and non-compliant resources

<img src='.img/2026-01-08-03-27-20.png' width=800>

#### Using PowerShell

```powershell
$subscriptionId = Get-AzContext | Select-Object -ExpandProperty Subscription

# Get compliance state for all policy assignments
Get-AzPolicyState -SubscriptionId $subscriptionId | 
    Select-Object PolicyAssignmentName, ComplianceState, ResourceGroup, ResourceType | 
    Sort-Object PolicyAssignmentName |
    Format-Table -AutoSize

# Get compliance summary
Get-AzPolicyStateSummary -SubscriptionId $subscriptionId

# Get non-compliant resources for a specific policy (using OData filter)
Get-AzPolicyState -Filter "PolicyAssignmentName eq 'allowed-locations-policy' and ComplianceState eq 'NonCompliant'"
```

<img src='.img/2026-01-08-03-36-19.png' width=700>

<img src='.img/2026-01-08-03-38-30.png' width=450>

<img src='.img/2026-01-08-03-44-16.png' width=800>

#### Using Azure CLI

```bash
subscriptionId=$(az account show --query id -o tsv)

# Get compliance state for all policy assignments
 az policy state list --subscription $subscriptionId \
        --query "reverse(sort_by( \
                [].{ \
                        PolicyAssignment:policyAssignmentName, \
                        ComplianceState:complianceState, \
                        ResourceGroup:resourceGroup, \
                        ResourceType:resourceType \
                }, \
                &PolicyAssignment))" \
        --output table \
        | column -t

# Get compliance summary
az policy state summarize --subscription $subscriptionId --query results

# Get non-compliant resources for a specific policy
az policy state list --filter "policyAssignmentName eq 'allowed-locations-policy' and complianceState eq 'NonCompliant'"
```

<img src='.img/2026-01-08-04-29-51.png' width=800>

<img src='.img/2026-01-08-04-41-06.png' width=700>

<img src='.img/2026-01-08-04-44-46.png' width=700>

### Trigger On-Demand Policy Evaluation Scan

By default, Azure Policy evaluates compliance for existing resources approximately **every 24 hours**. However, you may want immediate compliance results after assigning a new policy or making changes to resources. You can trigger an on-demand evaluation scan to get instant compliance data.

**📚 Related Documentation:**

- [Get compliance data - On-demand evaluation scan](https://learn.microsoft.com/en-us/azure/governance/policy/how-to/get-compliance-data#on-demand-evaluation-scan)

**Key Concepts:**

- On-demand scans are **asynchronous operations** that may take several minutes to complete
- Scans can be triggered at the **subscription** or **resource group** scope
- If a scan is already running for a scope, new scan requests receive the same status URI
- Not all Azure resource providers support on-demand scans (e.g., Azure Virtual Network Manager)

#### Trigger Scan Using PowerShell

```powershell
# Trigger a compliance scan for the entire subscription
Start-AzPolicyComplianceScan

# Trigger a compliance scan for a specific resource group
Start-AzPolicyComplianceScan -ResourceGroupName "rg-governance-lab"

# Run the scan in the background as a PowerShell job
$job = Start-AzPolicyComplianceScan -AsJob

# Check the job status
$job

# Wait for the job to complete - holds terminal action until done
$job | Wait-Job

# Get the job results
$job | Receive-Job
```
**Example output while running:**

<img src='.img/2026-01-12-03-21-12.png' width=600>

When the scan completes, the `State` property changes to `Completed`.

#### Trigger Scan Using Azure CLI

```bash
# Trigger a compliance scan for the entire subscription
az policy state trigger-scan

# Trigger a compliance scan for a specific resource group
az policy state trigger-scan --resource-group "rg-governance-lab"

# Run the scan without waiting for completion
az policy state trigger-scan --no-wait
```

<img src='.img/2026-01-12-03-27-58.png' width=600>

**Note:** The Azure CLI command runs synchronously by default and waits for the scan to complete before returning. Use the `--no-wait` parameter to run it asynchronously.

#### Verify Compliance After Scan

After the on-demand scan completes, verify the updated compliance data:

```powershell
$subscriptionId = Get-AzContext | Select-Object -ExpandProperty Subscription

# PowerShell - Get compliance summary
Get-AzPolicyStateSummary -SubscriptionId $subscriptionId

# PowerShell - Get detailed compliance state
Get-AzPolicyState -SubscriptionId $subscriptionId | 
    Select-Object PolicyAssignmentName, ComplianceState, ResourceId, Timestamp | 
    Sort-Object Timestamp -Descending | 
    Format-Table -AutoSize
```

<img src='.img/2026-01-12-03-29-47.png' width=700>

```bash
# Azure CLI - Get compliance summary
subscriptionId=$(az account show --query id -o tsv)

az policy state summarize --subscription $subscriptionId --query results

# Azure CLI - Get detailed compliance state sorted by timestamp
az policy state list --subscription $subscriptionId \
    --query "[].{PolicyAssignment:policyAssignmentName, ComplianceState:complianceState, Resource:resourceId, Timestamp:timestamp} | sort_by(@, &Timestamp) | reverse(@)" \
    --output table
```

<img src='.img/2026-01-12-04-08-59.png' width=500>

#### When to Use On-Demand Scans

- **After assigning new policies**: Immediately check compliance without waiting 24 hours
- **After resource deployment**: Verify that new resources comply with policies
- **During policy testing**: Quickly validate policy definitions during development
- **For compliance audits**: Generate up-to-date compliance reports on demand
- **After remediation**: Verify that remediation tasks successfully fixed non-compliant resources

### Disable Policy Assignment

```bash
# List current policy assignments
 az policy assignment list | jq '.[] | {name, displayName, enforcementMode}'
```

<img src='.img/2025-12-18-03-11-50.png' width=600>

```bash
# Disable a policy assignment by setting enforcement mode to DoNotEnforce
az policy assignment update --name allowed-vm-skus --enforcement-mode DoNotEnforce
```

<img src='.img/2025-12-18-03-18-17.png' width=600>

### Exam Insights

💡 **Exam Tip:** Policy assignments can take **up to 30 minutes** to take effect for new resource operations. Compliance evaluation of existing resources happens on a scheduled basis (approximately every 24 hours).

💡 **Exam Tip:** Policy assignments at higher scopes (subscription) apply to all resources within that scope, including new resource groups created later.

💡 **Exam Tip:** You can **exclude** specific scopes from a policy assignment using the exclusion parameter. This is useful when you need policy exceptions for specific resource groups.

💡 **Exam Tip:** Built-in policies cannot be modified, but you can create custom policies based on built-in ones.

---

## 🔹 Exercise 3 – Create Custom Policy Definitions

**Goal:** Create custom policy definitions to enforce organization-specific compliance requirements beyond what built-in policies provide.

**📚 Related Documentation:**

- [Tutorial: Create a custom policy definition](https://learn.microsoft.com/en-us/azure/governance/policy/tutorials/create-custom-policy-definition)
- [Azure Policy definition structure](https://learn.microsoft.com/en-us/azure/governance/policy/concepts/definition-structure)
- [Azure Policy effects](https://learn.microsoft.com/en-us/azure/governance/policy/concepts/effects)
- [Policy conditions](https://learn.microsoft.com/en-us/azure/governance/policy/concepts/definition-structure-policy-rule#conditions)
- [Author policies for array properties](https://learn.microsoft.com/en-us/azure/governance/policy/how-to/author-policies-for-arrays)

### Scenario: Enforce Naming Conventions

Contoso requires all storage accounts to follow a naming convention: `st<environment><application><region><sequence>`, where environment is `dev`, `test`, or `prod`.

Example valid names:

- `stdevwebappeus01` (dev environment, webapp, eastus, sequence 01)
- `stproddbeus02` (prod environment, database, eastus, sequence 02)

### Custom Policy Structure

A custom policy definition consists of:

```json
{
  "mode": "All | Indexed",
  "policyRule": {
    "if": {
      // Condition logic
    },
    "then": {
      "effect": "deny | audit | append | modify | etc."
    }
  },
  "parameters": {
    // Optional parameters
  },
  "metadata": {
    "category": "Custom Category"
  }
}
```

### Create Custom Policy: Storage Account Naming Convention

Create `storage-naming-policy.json`:

```json
{
  "mode": "Indexed",
  "policyRule": {
    "if": {
      "allOf": [
        {
          "field": "type",
          "equals": "Microsoft.Storage/storageAccounts"
        },
        {
          "not": {
            "field": "name",
            "match": "st[dev|test|prod]*[eus|wus|cus]*[0-9][0-9]"
          }
        }
      ]
    },
    "then": {
      "effect": "deny"
    }
  },
  "parameters": {},
  "metadata": {
    "category": "Storage",
    "displayName": "Enforce Storage Account Naming Convention",
    "description": "Storage account names must follow pattern: st<env><app><region><seq>"
  }
}
```

#### Using PowerShell to Create Custom Policy

```powershell
$subscriptionId = Get-AzContext | Select-Object -ExpandProperty Subscription

# Create custom policy definition from JSON file
$policyDef = New-AzPolicyDefinition `
    -Name 'storage-naming-convention' `
    -DisplayName 'Enforce Storage Account Naming Convention' `
    -Description 'Storage account names must follow pattern: st<env><app><region><seq>' `
    -Policy './powershell/storage-naming-policy.json' `
    -Mode 'Indexed' `
    -Metadata '{"category":"Storage"}'

# View the created policy
$policyDef | Select-Object Name, @{Name="DisplayName";Expression={$_.DisplayName}}, Id 

# Assign the custom policy
New-AzPolicyAssignment `
    -Name 'enforce-storage-naming' `
    -DisplayName 'Enforce Storage Naming Convention' `
    -Scope "/subscriptions/$subscriptionId" `
    -PolicyDefinition $policyDef
```

<img src='.img/2026-01-13-04-18-07.png' width=800>

#### Using Azure CLI to Create Custom Policy

```bash
# Create custom policy definition from JSON file
az policy definition create \
    --name 'storage-naming-convention' \
    --display-name 'Enforce Storage Account Naming Convention' \
    --description 'Storage account names must follow pattern: st<env><app><region><seq>' \
    --rules './cli/storage-naming-policy.json' \
    --mode Indexed \
    --metadata category=Storage

# View the created policy
az policy definition show --name 'storage-naming-convention'

# Assign the custom policy
az policy assignment create \
    --name 'enforce-storage-naming' \
    --display-name 'Enforce Storage Naming Convention' \
    --scope /subscriptions/<your-subscription-id> \
    --policy 'storage-naming-convention'
```

### Create Custom Policy: Require Specific Tags with Allowed Values

Contoso requires all resources to have a `CostCenter` tag with values from an approved list.

Create `require-costcenter-tag-values.json`:

```json
{
  "mode": "Indexed",
  "policyRule": {
    "if": {
      "anyOf": [
        {
          "field": "[concat('tags[', parameters('tagName'), ']')]",
          "exists": "false"
        },
        {
          "field": "[concat('tags[', parameters('tagName'), ']')]",
          "notIn": "[parameters('allowedValues')]"
        }
      ]
    },
    "then": {
      "effect": "deny"
    }
  },
  "parameters": {
    "tagName": {
      "type": "String",
      "metadata": {
        "displayName": "Tag Name",
        "description": "Name of the tag, such as 'CostCenter'"
      },
      "defaultValue": "CostCenter"
    },
    "allowedValues": {
      "type": "Array",
      "metadata": {
        "displayName": "Allowed Tag Values",
        "description": "List of allowed values for the tag"
      },
      "defaultValue": [
        "Engineering",
        "Marketing",
        "Sales",
        "HR"
      ]
    }
  },
  "metadata": {
    "category": "Tags",
    "displayName": "Require Tag with Allowed Values",
    "description": "Requires a tag with specific allowed values"
  }
}
```

#### Create and Assign the Policy

```powershell
# PowerShell
$policyDef = New-AzPolicyDefinition `
    -Name 'require-costcenter-values' `
    -DisplayName 'Require CostCenter Tag with Allowed Values' `
    -Description 'Requires CostCenter tag with approved department values' `
    -Policy './powershell/require-costcenter-tag-values.json' `
    -Mode 'Indexed'

# Assign with custom parameter values
$params = @{
    'tagName' = 'CostCenter'
    'allowedValues' = @('Engineering', 'Marketing', 'Sales', 'HR', 'IT')
}

New-AzPolicyAssignment `
    -Name 'require-costcenter-values' `
    -DisplayName 'Require Valid CostCenter Tag' `
    -Scope "/subscriptions/$($subscription.Id)" `
    -PolicyDefinition $policyDef `
    -PolicyParameterObject $params
```

### Create Custom Policy: Audit VMs Without Backup Enabled

Create `audit-vm-backup.json`:

```json
{
  "mode": "Indexed",
  "policyRule": {
    "if": {
      "allOf": [
        {
          "field": "type",
          "equals": "Microsoft.Compute/virtualMachines"
        },
        {
          "field": "Microsoft.Compute/virtualMachines/storageProfile.osDisk.osType",
          "exists": "true"
        }
      ]
    },
    "then": {
      "effect": "auditIfNotExists",
      "details": {
        "type": "Microsoft.RecoveryServices/backupprotecteditems",
        "existenceCondition": {
          "field": "Microsoft.RecoveryServices/backupprotecteditems/friendlyName",
          "equals": "[field('name')]"
        }
      }
    }
  },
  "parameters": {},
  "metadata": {
    "category": "Backup",
    "displayName": "Audit VMs Without Backup Enabled",
    "description": "Audits virtual machines that do not have backup protection configured"
  }
}
```

```powershell
# PowerShell
$policyDef = New-AzPolicyDefinition `
    -Name 'audit-vm-backup' `
    -DisplayName 'Audit VMs Without Backup Enabled' `
    -Description 'Audits virtual machines without backup protection' `
    -Policy './powershell/audit-vm-backup.json' `
    -Mode 'Indexed'

New-AzPolicyAssignment `
    -Name 'audit-vm-backup' `
    -DisplayName 'Audit VM Backup Compliance' `
    -Scope "/subscriptions/$($subscription.Id)" `
    -PolicyDefinition $policyDef
```

### Using Terraform to Create Custom Policy

Create `custom-policy.tf`:

```hcl
# Storage Account Naming Convention Policy
resource "azurerm_policy_definition" "storage_naming" {
  name         = "storage-naming-convention"
  display_name = "Enforce Storage Account Naming Convention"
  description  = "Storage account names must follow pattern: st<env><app><region><seq>"
  policy_type  = "Custom"
  mode         = "Indexed"

  metadata = jsonencode({
    category = "Storage"
  })

  policy_rule = jsonencode({
    if = {
      allOf = [
        {
          field  = "type"
          equals = "Microsoft.Storage/storageAccounts"
        },
        {
          not = {
            field = "name"
            match = "st[dev|test|prod]*[eus|wus|cus]*[0-9][0-9]"
          }
        }
      ]
    }
    then = {
      effect = "deny"
    }
  })
}

# Assign the custom policy
resource "azurerm_subscription_policy_assignment" "storage_naming" {
  name                 = "enforce-storage-naming"
  display_name         = "Enforce Storage Naming Convention"
  subscription_id      = data.azurerm_subscription.current.id
  policy_definition_id = azurerm_policy_definition.storage_naming.id
}

# Require CostCenter Tag with Allowed Values
resource "azurerm_policy_definition" "require_costcenter_values" {
  name         = "require-costcenter-values"
  display_name = "Require CostCenter Tag with Allowed Values"
  description  = "Requires CostCenter tag with approved department values"
  policy_type  = "Custom"
  mode         = "Indexed"

  parameters = jsonencode({
    tagName = {
      type = "String"
      metadata = {
        displayName = "Tag Name"
        description = "Name of the tag, such as 'CostCenter'"
      }
      defaultValue = "CostCenter"
    }
    allowedValues = {
      type = "Array"
      metadata = {
        displayName = "Allowed Tag Values"
        description = "List of allowed values for the tag"
      }
      defaultValue = ["Engineering", "Marketing", "Sales", "HR"]
    }
  })

  policy_rule = jsonencode({
    if = {
      anyOf = [
        {
          field  = "[concat('tags[', parameters('tagName'), ']')]"
          exists = "false"
        },
        {
          field = "[concat('tags[', parameters('tagName'), ']')]"
          notIn = "[parameters('allowedValues')]"
        }
      ]
    }
    then = {
      effect = "deny"
    }
  })
}

output "storage_naming_policy_id" {
  value = azurerm_policy_definition.storage_naming.id
}
```

### Test Custom Policies

```powershell
# Test storage naming policy - should FAIL
New-AzStorageAccount `
    -ResourceGroupName "rg-governance-lab" `
    -Name "mystorageaccount123" `
    -Location "eastus" `
    -SkuName "Standard_LRS"

# Test storage naming policy - should SUCCEED
New-AzStorageAccount `
    -ResourceGroupName "rg-governance-lab" `
    -Name "stdevwebeus01" `
    -Location "eastus" `
    -SkuName "Standard_LRS"

# Test CostCenter tag policy - should FAIL
New-AzResourceGroup `
    -Name "rg-test-no-tag" `
    -Location "eastus"

# Test CostCenter tag policy - should SUCCEED
New-AzResourceGroup `
    -Name "rg-test-with-tag" `
    -Location "eastus" `
    -Tag @{CostCenter="Engineering"}
```

### Exam Insights

💡 **Exam Tip:** Custom policies must be created at the **subscription** or **management group** level before they can be assigned.

💡 **Exam Tip:** The `mode` parameter determines which resource types are evaluated:

- **Indexed**: Evaluates resources that support tags and location (most resources)
- **All**: Evaluates all resources, including those that don't support tags

💡 **Exam Tip:** Use **parameters** to make custom policies reusable across different scenarios without duplicating policy definitions.

💡 **Exam Tip:** Test custom policies thoroughly using the `audit` effect before changing to `deny` to avoid blocking legitimate operations.

---

## 🔹 Exercise 4 – Implement Policy Initiatives

**Goal:** Understand and create policy initiatives (policy sets) to group related policies together for simplified assignment and compliance management.

**📚 Related Documentation:**

- [Azure Policy initiative definition structure](https://learn.microsoft.com/en-us/azure/governance/policy/concepts/initiative-definition-structure)
- [Create and assign an initiative definition](https://learn.microsoft.com/en-us/azure/governance/policy/tutorials/create-and-manage#create-and-assign-an-initiative-definition)
- [Azure Policy built-in initiatives](https://learn.microsoft.com/en-us/azure/governance/policy/samples/built-in-initiatives)

*[Content to be added in next request]*

---

## 🔹 Exercise 5 – Configure Policy Remediation

**Goal:** Configure and execute remediation tasks for non-compliant resources using deployIfNotExists and modify effects.

**📚 Related Documentation:**

- [Remediate non-compliant resources](https://learn.microsoft.com/en-us/azure/governance/policy/how-to/remediate-resources)
- [Policy remediation structure](https://learn.microsoft.com/en-us/azure/governance/policy/concepts/remediation-structure)

*[Content to be added in next request]*

---

## 🔹 Exercise 6 – Implement Resource Locks

**Goal:** Protect critical Azure resources from accidental deletion or modification using resource locks.

**📚 Related Documentation:**

- [Lock resources to prevent changes](https://learn.microsoft.com/en-us/azure/azure-resource-manager/management/lock-resources)
- [Lock resources - PowerShell](https://learn.microsoft.com/en-us/azure/azure-resource-manager/management/lock-resources?tabs=json#powershell)
- [Lock resources - CLI](https://learn.microsoft.com/en-us/azure/azure-resource-manager/management/lock-resources?tabs=json#azure-cli)

*[Content to be added in next request]*

---

## 🔹 Exercise 7 – Implement and Manage Resource Tags

**Goal:** Implement a comprehensive tagging strategy for cost allocation, resource organization, and automation.

**📚 Related Documentation:**

- [Use tags to organize Azure resources](https://learn.microsoft.com/en-us/azure/azure-resource-manager/management/tag-resources)
- [Tag resources - PowerShell](https://learn.microsoft.com/en-us/azure/azure-resource-manager/management/tag-resources-powershell)
- [Tag resources - CLI](https://learn.microsoft.com/en-us/azure/azure-resource-manager/management/tag-resources-cli)

*[Content to be added in next request]*

---

## 🔹 Exercise 8 – Move Resources Between Resource Groups and Subscriptions

**Goal:** Understand the requirements and process for moving Azure resources between resource groups and subscriptions.

**📚 Related Documentation:**

- [Move resources to new resource group or subscription](https://learn.microsoft.com/en-us/azure/azure-resource-manager/management/move-resource-group-and-subscription)
- [Move operation support for resources](https://learn.microsoft.com/en-us/azure/azure-resource-manager/management/move-support-resources)
- [Checklist before moving resources](https://learn.microsoft.com/en-us/azure/azure-resource-manager/management/move-resource-group-and-subscription#checklist-before-moving-resources)

*[Content to be added in next request]*

---

## 🔹 Exercise 9 – Configure Management Groups

**Goal:** Implement hierarchical governance using management groups to organize subscriptions and apply policies at scale.

**📚 Related Documentation:**

- [Organize resources with management groups](https://learn.microsoft.com/en-us/azure/governance/management-groups/overview)
- [Create management groups](https://learn.microsoft.com/en-us/azure/governance/management-groups/create-management-group-portal)
- [Management group hierarchy](https://learn.microsoft.com/en-us/azure/governance/management-groups/overview#hierarchy-of-management-groups-and-subscriptions)

*[Content to be added in next request]*

---

## 🧭 Reflection & Readiness

### Review Questions

1. **What is the difference between a policy definition and a policy assignment?**
   <details>
   <summary>Answer</summary>
   A policy definition describes the compliance rule and effect, while a policy assignment applies that definition to a specific scope (subscription, resource group, etc.).
   </details>

2. **Can a policy assigned at the resource group level block a resource that complies with a subscription-level policy?**
   <details>
   <summary>Answer</summary>
   No. Policies at lower scopes cannot override deny effects from higher scopes. However, they can add additional restrictions.
   </details>

3. **What are the two resource lock types, and what do they prevent?**
   <details>
   <summary>Answer</summary>
   - **CanNotDelete**: Prevents deletion but allows read and modify operations
   - **ReadOnly**: Prevents all modifications and deletions (read-only access)
   </details>

4. **How long does it take for a policy assignment to take effect?**
   <details>
   <summary>Answer</summary>
   Policy assignments typically take effect within 30 minutes for new resources. Compliance evaluation for existing resources runs approximately every 24 hours.
   </details>

5. **Can tags applied at the resource group level automatically inherit to resources?**
   <details>
   <summary>Answer</summary>
   No, tags do not automatically inherit. You must use Azure Policy with the "Append" or "Modify" effect to enforce tag inheritance.
   </details>

### Key Takeaways

✅ **Policy hierarchy**: Management Group → Subscription → Resource Group → Resource  
✅ **Policy effects**: Deny (prevent), Audit (log), Modify/Append (change), DeployIfNotExists (auto-create)  
✅ **Initiatives**: Group related policies for simplified assignment  
✅ **Remediation**: Fix non-compliant existing resources  
✅ **Resource locks**: Protect critical resources (CanNotDelete, ReadOnly)  
✅ **Tags**: Organize resources for cost allocation and automation (do not inherit by default)  
✅ **Moving resources**: Check move support matrix, validate dependencies  
✅ **Management groups**: Hierarchical governance across multiple subscriptions  

### Common Pitfalls

❌ Forgetting that policy evaluation is **not real-time** for existing resources  
❌ Assigning deny policies without testing with audit first  
❌ Not understanding policy **scope inheritance** and exclusions  
❌ Confusing policy **definitions** (reusable) vs. **assignments** (applied to scope)  
❌ Expecting tags to **automatically inherit** from resource groups  
❌ Not checking the **move support matrix** before moving resources  
❌ Applying ReadOnly locks without understanding they block **all write operations**  

---

## 📚 References

### Microsoft Learn Modules

- [Design an Azure governance solution](https://learn.microsoft.com/en-us/training/modules/design-governance/)
- [Configure Azure Policy](https://learn.microsoft.com/en-us/training/modules/configure-azure-policy/)
- [Introduction to Azure Policy](https://learn.microsoft.com/en-us/training/modules/intro-to-azure-policy/)
- [Build a cloud governance strategy on Azure](https://learn.microsoft.com/en-us/training/modules/build-cloud-governance-strategy-azure/)
- [Configure resource locks](https://learn.microsoft.com/en-us/training/modules/configure-resource-locks/)
- [Configure resource tags](https://learn.microsoft.com/en-us/training/modules/configure-azure-resource-manager/)
- [Organize Azure resources effectively](https://learn.microsoft.com/en-us/training/modules/organize-azure-resources-effectively/)

### Microsoft Documentation

- [Azure Policy Overview](https://learn.microsoft.com/en-us/azure/governance/policy/overview)
- [Azure Policy Samples](https://learn.microsoft.com/en-us/azure/governance/policy/samples/)
- [Azure Resource Manager Overview](https://learn.microsoft.com/en-us/azure/azure-resource-manager/management/overview)
- [Management Groups Overview](https://learn.microsoft.com/en-us/azure/governance/management-groups/overview)
- [Azure Resource Graph](https://learn.microsoft.com/en-us/azure/governance/resource-graph/overview)

### Additional Resources

- [Azure Governance Accelerator](https://github.com/Azure/azure-policy)
- [Azure Policy Community Repository](https://github.com/Azure/Community-Policy)
- [Exam Readiness Zone – Identities & Governance](https://learn.microsoft.com/en-us/shows/exam-readiness-zone/preparing-for-az-104-manage-azure-identities-and-governance-1-of-5)

---

*Lab created: 2025-10-29*  
*Last updated: 2025-10-29*
