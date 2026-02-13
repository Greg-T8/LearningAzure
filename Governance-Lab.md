# Hands-On Labs Governance Policy

Standards and naming conventions for all Terraform and Bicep implementations across Azure certification labs (AI-102, AZ-104, etc.).

---

## General Policies

### Location Policy

| Setting | Value | Rationale |
|---------|-------|-----------|
| Default Region | `eastus` | Cost-effective, wide service availability |
| Allowed Regions | All US regions (e.g., `eastus`, `eastus2`, `westus`, `westus2`, `westus3`, `centralus`, `northcentralus`, `southcentralus`, etc.) | Maximum flexibility for resource availability; minimize latency within US |

### Tagging Policy

All resources **must** include these tags:

> **IMPORTANT**: For `DateCreated`, always use a **static value** (e.g., via variable/parameter), never dynamic functions like `timestamp()` (Terraform) or `utcNow()` (Bicep). Dynamic values cause Terraform/Bicep to detect tag changes on every plan/deployment, forcing unnecessary resource updates.

| Tag | Description | Example |
|-----|-------------|---------|
| `Environment` | Fixed value | `Lab` |
| `Project` | Certification context | `AI-102`, `AZ-104` |
| `Domain` | Exam domain or area | `Networking`, `AI-Services`, `Computer-Vision` |
| `Purpose` | What the lab demonstrates | `VNet Peering`, `DALL-E Image Generation` |
| `Owner` | Your identifier | `Greg Tate` |
| `DateCreated` | Resource creation date | `2026-02-09` |
| `DeploymentMethod` | IaC tool used | `Terraform` or `Bicep` |

---

## Quick Reference

### Domain to Resource Type Mapping

| Domain | Common Resource Types | Applicable Exams |
|--------|----------------------|------------------|
| `identity` | Resource Groups, RBAC Roles, Managed Identities, Key Vaults | AZ-104 |
| `networking` | VNets, Subnets, NSGs, Load Balancers, Public IPs, NAT Gateways, Application Gateways, Bastion | AZ-104 |
| `storage` | Storage Accounts, Blob Containers, File Shares, Disks | AZ-104, AI-102 |
| `compute` | Virtual Machines, VM Scale Sets, Availability Sets, App Services | AZ-104 |
| `monitoring` | Log Analytics Workspaces, Recovery Services Vaults, Action Groups, Alerts | AZ-104 |
| `ai-services` | Cognitive Services (OpenAI, Vision, Language, Speech, etc.), Microsoft Foundry, Cognitive Deployments | AI-102 |
| `generative-ai` | Azure OpenAI, Model Deployments (GPT-4, DALL-E, etc.), Prompt Flow | AI-102 |
| `computer-vision` | Computer Vision, Custom Vision, Face API, Form Recognizer/Document Intelligence | AI-102 |
| `nlp` | Language Service, Translator, Speech Services | AI-102 |

---

## Exam-Specific Domain Guidelines

### AI-102 Domains

| Domain | Common Topics | Key Resources |
|--------|---------------|---------------|
| `generative-ai` | Azure OpenAI, GPT models, DALL-E, embeddings, prompt engineering | `oai`, `deploy`, `st` (for outputs) |
| `computer-vision` | Computer Vision, Custom Vision, Face API, Form Recognizer | `cv`, `cvtr`, `cvpr`, `doc` |
| `nlp` | Language Service, Translator, sentiment analysis, entity recognition | `lang`, `trans` |
| `knowledge-mining` | AI Search, indexers, skillsets, knowledge stores | `srch`, `st` (for data sources) |
| `ai-services` | Multi-service accounts, Cognitive Services configuration | `cog` |

### AZ-104 Domains

| Domain | Common Topics | Key Resources |
|--------|---------------|---------------|
| `identity` | RBAC, Azure AD, managed identities, Key Vault | Resource Groups, RBAC, `kv` |
| `networking` | VNets, subnets, NSGs, load balancers, peering, Bastion | `vnet`, `snet`, `nsg`, `lb`, `pip`, `bas` |
| `storage` | Storage accounts, blob lifecycle, file shares, disks | `st`, blob containers, file shares, `disk` |
| `compute` | VMs, availability sets, VM scale sets, App Services | `vm`, `avset`, `vmss`, `app` |
| `monitoring` | Log Analytics, backup, alerts, diagnostics | `law`, `rsv`, action groups |

---

## Naming Conventions

### Resource Group Naming

**Pattern:** `<exam>-<domain>-<topic>-<deployment_method>`

| Segment | Description | Allowed Values |
|---------|-------------|----------------|
| `<exam>` | Certification exam code (lowercase) | `ai102`, `az104` |
| `<domain>` | Exam domain or service area | AZ-104: `identity`, `networking`, `storage`, `compute`, `monitoring`<br>AI-102: `ai-services`, `generative-ai`, `computer-vision`, `nlp`, `knowledge-mining` |
| `<topic>` | Lab topic (kebab-case) | e.g., `vnet-peering`, `dalle-image-gen`, `custom-vision` |
| `<deployment_method>` | IaC tool used | `tf` (Terraform), `bicep` (Bicep) |

**Examples:**

| Lab | Exam | Deployment | Resource Group Name |
|-----|------|------------|---------------------|
| VNet Peering | AZ-104 | Terraform | `az104-networking-vnet-peering-tf` |
| DALL-E Image Generation | AI-102 | Terraform | `ai102-generative-ai-dalle-image-gen-tf` |
| Custom Vision Classification | AI-102 | Bicep | `ai102-computer-vision-custom-vision-bicep` |
| Azure OpenAI Chat | AI-102 | Terraform | `ai102-generative-ai-openai-chat-tf` |
| Language Understanding | AI-102 | Bicep | `ai102-nlp-language-understanding-bicep` |
| Storage Lifecycle | AZ-104 | Bicep | `az104-storage-blob-lifecycle-bicep` |

### Resource Naming

**Pattern:** `<type>-<topic>[-<instance>]`

#### Infrastructure Resources (AZ-104)

| Resource Type | Prefix | Example | Notes |
|---------------|--------|---------|-------|
| Virtual Network | `vnet` | `vnet-hub`, `vnet-spoke` | |
| Subnet | `snet` | `snet-web`, `snet-db` | |
| Network Security Group | `nsg` | `nsg-web` | |
| Network Interface | `nic` | `nic-vm-web-01` | |
| Load Balancer | `lb` | `lb-public` | |
| Public IP | `pip` | `pip-lb` | |
| NAT Gateway | `natgw` | `natgw-outbound` | |
| Application Gateway | `agw` | `agw-frontend` | |
| Azure Bastion | `bas` | `bas-management` | |
| Storage Account | `st<exam><topic>` | `staz104vnetpeer01` | No hyphens; max 24 chars; globally unique |
| Managed Disk | `disk` | `disk-vm-web-01-os` | |
| Virtual Machine | `vm` | `vm-web-01` | |
| Availability Set | `avset` | `avset-web` | |
| VM Scale Set | `vmss` | `vmss-web` | |
| App Service | `app` | `app-api` | Globally unique |
| Key Vault | `kv` | `kv-az104-secrets` | Globally unique; 3-24 chars |
| Log Analytics Workspace | `law` | `law-central` | |
| Recovery Services Vault | `rsv` | `rsv-backup` | |

#### Azure AI Services Resources (AI-102)

| Resource Type | Prefix | Example | Notes |
|---------------|--------|---------|-------|
| Cognitive Services (Multi-Service) | `cog` | `cog-ai102-lab01` | Multi-service account |
| Azure OpenAI | `oai` | `oai-dalle-lab`, `oai-gpt4-lab` | Single-service OpenAI account |
| Computer Vision | `cv` | `cv-analysis-lab` | Single-service Computer Vision |
| Custom Vision (Training) | `cvtr` | `cvtr-classifier-lab` | Custom Vision training resource |
| Custom Vision (Prediction) | `cvpr` | `cvpr-classifier-lab` | Custom Vision prediction resource |
| Language Service | `lang` | `lang-sentiment-lab` | Language understanding/analysis |
| Translator | `trans` | `trans-multilang-lab` | Text translation service |
| Speech Service | `speech` | `speech-tts-lab` | Speech-to-text/text-to-speech |
| Form Recognizer/Document Intelligence | `doc` | `doc-invoice-lab` | Document processing |
| AI Search (Cognitive Search) | `srch` | `srch-knowledge-lab` | Cognitive/AI Search service |
| Cosmos DB (for AI Agents) | `cosmos` | `cosmos-agent-a6mh64` | Serverless; thread storage for AI Agent Service |
| Cognitive Deployment (Model) | `deploy` | `deploy-gpt4`, `deploy-dalle3` | Model deployment within OpenAI account |
| Microsoft Foundry Hub | `mfh` | `mfh-project-hub` | Microsoft Foundry hub resource |
| Microsoft Foundry Project | `mfp` | `mfp-genai-lab` | Microsoft Foundry project resource |
| Storage Account (AI outputs) | `st<exam><topic>` | `stai102dalle01`, `stai102img01` | For storing AI-generated content |

**AI Resource Naming Notes:**

- OpenAI accounts often need random suffix for global uniqueness: `oai-dalle-lab-abc123`
- Model deployments can be descriptive: `deploy-gpt4-turbo`, `deploy-dalle3`, `deploy-embeddings`
- Storage accounts for AI outputs: append random suffix, e.g., `stai102dalle{randomString}`

### Deployment Stack Naming (Bicep-Specific)

**Pattern:** `stack-<domain>-<topic>`

**Note:** Deployment stack names don't include the exam code or `-bicep` suffix since they're deployment-specific constructs.

**Examples:**

- `stack-networking-vnet-peering`
- `stack-generative-ai-dalle-image-gen`
- `stack-computer-vision-custom-vision`

---

## Cost Management

### Resource Cleanup Policy

- **Mandatory Cleanup:** All lab resources must be destroyed within **7 days** of creation
- **Tagging for Tracking:** Use `DateCreated` tag to identify resources approaching cleanup deadline
- **Exception Process:** Document permanent reference labs in `README.md` with justification

### Resource Limits

| Resource Type | Maximum per Lab | Rationale |
|---------------|-----------------|-----------|
| Virtual Machines | 4 | Control costs; most labs don't need more |
| Public IPs | 5 | Limit exposure and costs |
| Storage Accounts | 3 | Sufficient for most scenarios |
| VNets | 4 | Typical hub-spoke plus extras |
| Azure OpenAI Accounts | 2 | Most labs need only one; allow second for comparison |
| Cognitive Services Accounts | 3 | May need multiple single-service resources per lab |
| Model Deployments | 4 | Multiple models (GPT-4, DALL-E, embeddings, etc.) |

### Cost Control Measures

- **VM Auto-Shutdown:** Configure 7:00 PM EST daily shutdown for all VMs
- **VM Sizing:** Use `Standard_B2s` or smaller unless lab specifically requires larger
- **Disk Type:** Use Standard HDD unless Premium SSD required for testing
- **AI Service Tiers:** Start with Free (F0) or Standard (S0) tiers; use higher only when needed
- **Budget Alerts:** (Optional) Set up Azure Budget alerts at $50 threshold

### Resource SKU/Tier Standards

#### Infrastructure Resources (AZ-104)

| Resource Type | Default SKU/Tier | Notes |
|---------------|------------------|-------|
| Virtual Machines | `Standard_B2s` (2 vCPU, 4 GB RAM) | General-purpose default |
| Virtual Machines (Minimal) | `Standard_B1s` (1 vCPU, 1 GB RAM) | Use for simple scenarios |
| Virtual Machines (High-Performance) | D-series or higher | Only when explicitly required by scenario |
| Storage Accounts | Standard LRS | Use unless redundancy required |
| Load Balancers | Basic SKU | Standard SKU only when required |
| Public IPs | Basic SKU | Standard SKU only for specific features |
| App Services | Free or Basic tier | Higher tiers only when needed |
| SQL Database | Basic or S0 tier | Higher tiers only for performance testing |
| Managed Disks | Standard HDD | Premium SSD only when required |

#### Azure AI Services Resources (AI-102)

| Resource Type | Default SKU/Tier | Notes |
|---------------|------------------|-------|
| Azure OpenAI | `S0` (Standard) | F0 (Free) not available; S0 is entry tier |
| Cognitive Services Multi-Service | `F0` (Free) or `S0` (Standard) | Start with F0 for testing; upgrade to S0 when needed |
| Computer Vision | `F0` (Free) or `S1` (Standard) | F0: 20 calls/min, 5K/month; S1: 10 calls/sec |
| Custom Vision (Training) | `F0` (Free) or `S0` (Standard) | F0: 2 projects, 5K training images |
| Custom Vision (Prediction) | `F0` (Free) or `S0` (Standard) | F0: 10K predictions/month |
| Language Service | `F0` (Free) or `S` (Standard) | F0 sufficient for many labs |
| Translator | `F0` (Free) or `S1` (Standard) | F0: 2M chars/month |
| Speech Service | `F0` (Free) or `S0` (Standard) | F0: 5 hours audio/month |
| Form Recognizer | `F0` (Free) or `S0` (Standard) | F0: 500 pages/month |
| AI Search | `Free` or `Basic` | Free: 50 MB storage, 3 indexes |
| Storage (AI outputs) | Standard LRS | Same as general storage |

**AI Service SKU Notes:**

- **Always start with Free (F0) tier** when available for initial testing
- **Upgrade to Standard (S0/S1)** only when you hit rate limits or need production features
- **OpenAI has no free tier**; S0 is pay-per-token
- **Model deployments** don't have separate SKUs; capacity managed within OpenAI account

---

## Soft-Delete Resource Management

### Overview

Several Azure resource types use soft-delete protection, which prevents immediate recreation with the same name and can block resource group deletion. For lab environments with frequent destroy/recreate cycles, you must purge soft-deleted resources.

### Resources Requiring Purge Scripts

| Resource Type | Soft-Delete Period | Purge Required | Impact on Labs |
|---------------|-------------------|----------------|----------------|
| **Cognitive Services** | 48 hours | ✅ Yes | Name collision on redeploy |
| **Key Vault** | 7-90 days | ✅ Yes | Name collision on redeploy |
| **API Management** | 48 hours | ✅ Yes | Name collision on redeploy |
| **Recovery Services Vault** | 14 days | ✅ Yes | Blocks resource group deletion |
| **Application Insights** | 14 days | ⚠️ No manual purge | Must wait or rename |
| **Log Analytics Workspace** | 14 days | ⚠️ No manual purge | Must wait or rename |

### Integration with Deployment Scripts

**Best Practice**: Integrate purge logic into your destroy workflow (e.g., in `bicep.ps1` destroy action or Terraform wrapper scripts).

**Pattern**:

1. Query resources before deletion
2. Execute deletion/destroy
3. If successful, purge soft-deleted items
4. Handle purge failures gracefully

### Purge Commands by Resource Type

#### Cognitive Services (AI Services, OpenAI, etc.)

**Azure CLI**:

```powershell
# Purge a single account
az cognitiveservices account purge `
    --name <account-name> `
    --resource-group <rg-name> `
    --location <location>

# List all soft-deleted accounts
az cognitiveservices account list-deleted

# Purge all deleted accounts in a subscription (scripting)
$deletedAccounts = az cognitiveservices account list-deleted --query "[].{name:name, location:location, resourceGroup:resourceGroup}" -o json | ConvertFrom-Json

foreach ($account in $deletedAccounts) {
    az cognitiveservices account purge `
        --name $account.name `
        --resource-group $account.resourceGroup `
        --location $account.location
}
```

**PowerShell (Az module)**:

```powershell
# Purge a single account
Remove-AzCognitiveServicesAccountPurge `
    -Name <account-name> `
    -ResourceGroupName <rg-name> `
    -Location <location>

# List soft-deleted accounts
Get-AzCognitiveServicesDeletedAccount

# Purge all deleted accounts
Get-AzCognitiveServicesDeletedAccount | ForEach-Object {
    Remove-AzCognitiveServicesAccountPurge `
        -Name $_.AccountName `
        -ResourceGroupName $_.ResourceGroupName `
        -Location $_.Location
}
```

#### Key Vault

**Azure CLI**:

```powershell
# Purge a single vault
az keyvault purge --name <vault-name>

# List all soft-deleted vaults
az keyvault list-deleted

# Purge all deleted vaults in a subscription
$deletedVaults = az keyvault list-deleted --query "[].{name:name}" -o json | ConvertFrom-Json

foreach ($vault in $deletedVaults) {
    az keyvault purge --name $vault.name
}
```

**PowerShell (Az module)**:

```powershell
# Purge a single vault
Remove-AzKeyVault -VaultName <vault-name> -InRemovedState -Location <location>

# List soft-deleted vaults
Get-AzKeyVault -InRemovedState

# Purge all deleted vaults
Get-AzKeyVault -InRemovedState | ForEach-Object {
    Remove-AzKeyVault -VaultName $_.VaultName -InRemovedState -Location $_.Location -Force
}
```

#### API Management

**Azure CLI**:

```powershell
# Purge a single service
az apim deletedservice purge `
    --service-name <apim-name> `
    --location <location>

# List all soft-deleted services
az apim deletedservice list

# Purge all deleted services
$deletedApims = az apim deletedservice list --query "[].{name:name, location:location}" -o json | ConvertFrom-Json

foreach ($apim in $deletedApims) {
    az apim deletedservice purge `
        --service-name $apim.name `
        --location $apim.location
}
```

**PowerShell (Az module)**:

```powershell
# Purge a single service
Remove-AzApiManagement -Name <apim-name> -ResourceGroupName <rg-name> -Location <location> -DeletedService

# Note: Az.ApiManagement module has limited soft-delete support; prefer Azure CLI
```

#### Recovery Services Vault

**Important**: Recovery vaults cannot be deleted until all backup data (including soft-deleted) is removed.

**Disable soft-delete** (before or after vault creation):

```powershell
# Azure CLI
az backup vault backup-properties set `
    --name <vault-name> `
    --resource-group <rg-name> `
    --soft-delete-feature-state Disable

# PowerShell
Set-AzRecoveryServicesVaultProperty `
    -VaultId <vault-id> `
    -SoftDeleteFeatureState Disable
```

**Delete all backup items**:

```powershell
# This is complex; usually need to:
# 1. Stop protection with delete data for each backup item
# 2. Delete backup items
# 3. Then delete the vault

# For lab environments, disable soft-delete BEFORE creating backups
```

**Lab Best Practice**: Configure vaults with soft-delete disabled from the start:

**Terraform**:

```hcl
resource "azurerm_recovery_services_vault" "vault" {
  name                = "rsv-backup"
  location            = azurerm_resource_group.lab.location
  resource_group_name = azurerm_resource_group.lab.name
  sku                 = "Standard"
  
  soft_delete_enabled = false  # Disable for lab environments
}
```

**Bicep**:

```bicep
resource vault 'Microsoft.RecoveryServices/vaults@2023-01-01' = {
  name: 'rsv-backup'
  location: location
  sku: {
    name: 'Standard'
  }
  properties: {
    securitySettings: {
      softDeleteSettings: {
        softDeleteState: 'Disabled'  // Disable for lab environments
      }
    }
  }
}
```

#### Application Insights & Log Analytics Workspace

**No manual purge available**. These resources:

- Cannot be purged during the 14-day retention period
- Must either wait for automatic expiration or use different names on redeployment

**Lab Workaround**:

```powershell
# Use unique suffixes for each deployment
$suffix = Get-Random -Minimum 1000 -Maximum 9999
$workspaceName = "law-central-$suffix"
$appInsightsName = "appi-webapp-$suffix"
```

Or use date-based naming:

```powershell
$dateSuffix = Get-Date -Format "MMdd"
$workspaceName = "law-central-$dateSuffix"
```

### Example: Integrated Bicep Destroy Script

The `bicep.ps1` wrapper script demonstrates the proper pattern:

```powershell
function Invoke-DestroyAction {
    # 1. Capture resources before destroy
    $cogAccounts = Get-CognitiveServicesAccounts -StackName $script:StackName
    
    # 2. Execute destroy
    Write-Host "Destroying deployment stack..." -ForegroundColor Cyan
    az stack sub delete --name $script:StackName --action-on-unmanage deleteAll --yes
    $destroyExitCode = $LASTEXITCODE
    
    # 3. Purge soft-deleted resources if destroy succeeded
    if ($destroyExitCode -eq 0 -and $cogAccounts.Count -gt 0) {
        Invoke-PurgeCognitiveServices -Accounts $cogAccounts
    }
    
    exit $destroyExitCode
}

function Invoke-PurgeCognitiveServices {
    param([array]$Accounts)
    
    Write-Host "Purging soft-deleted Cognitive Services accounts..." -ForegroundColor Cyan
    
    foreach ($account in $Accounts) {
        az cognitiveservices account purge `
            --name $account.name `
            --resource-group $account.resourceGroup `
            --location $account.location 2>$null
        
        if ($LASTEXITCODE -eq 0) {
            Write-Host "✅ Purged: $($account.name)" -ForegroundColor Green
        } else {
            Write-Host "⚠️ Could not purge: $($account.name)" -ForegroundColor Yellow
        }
    }
}
```

### Example: Terraform Wrapper Script

Create a `deploy.ps1` wrapper for Terraform:

```powershell
# deploy.ps1
param(
    [Parameter(Mandatory = $true)]
    [ValidateSet('plan', 'apply', 'destroy')]
    [string]$Action
)

function Invoke-TerraformDestroy {
    # Capture resource names before destroy
    $cogAccounts = terraform output -json cognitive_accounts | ConvertFrom-Json
    $keyVaults = terraform output -json key_vaults | ConvertFrom-Json
    
    # Execute terraform destroy
    terraform destroy -auto-approve
    
    if ($LASTEXITCODE -eq 0) {
        # Purge Cognitive Services
        foreach ($account in $cogAccounts) {
            az cognitiveservices account purge `
                --name $account.name `
                --resource-group $account.resource_group `
                --location $account.location
        }
        
        # Purge Key Vaults
        foreach ($vault in $keyVaults) {
            az keyvault purge --name $vault.name
        }
    }
}

switch ($Action) {
    'plan' { terraform plan }
    'apply' { terraform apply -auto-approve }
    'destroy' { Invoke-TerraformDestroy }
}
```

**Required Terraform outputs** for purge tracking:

```hcl
# outputs.tf
output "cognitive_accounts" {
  description = "Cognitive Services accounts for purge tracking"
  value = [
    for account in azurerm_cognitive_account.all : {
      name           = account.name
      resource_group = account.resource_group_name
      location       = account.location
    }
  ]
}

output "key_vaults" {
  description = "Key Vaults for purge tracking"
  value = [
    for vault in azurerm_key_vault.all : {
      name     = vault.name
      location = vault.location
    }
  ]
}
```

### Purge Verification

After purging, verify resources are fully removed:

```powershell
# Check Cognitive Services
az cognitiveservices account list-deleted

# Check Key Vaults
az keyvault list-deleted

# Check API Management
az apim deletedservice list

# Should return empty arrays if purge succeeded
```

### Best Practices Summary

1. **Always integrate purge logic** into destroy workflows for resources with soft-delete
2. **Capture resource metadata before deletion** (names, locations, resource groups)
3. **Handle purge failures gracefully** - warn but don't fail the entire operation
4. **Verify purge completion** before marking destroy as successful
5. **For Recovery Vaults**: Disable soft-delete during creation in lab environments
6. **For Application Insights/Log Analytics**: Use unique naming patterns to avoid conflicts
7. **Document purge requirements** in lab README files

---

## Code Style Standards

### Header Comments

All code files (Terraform, Bicep, PowerShell) **must** include a header comment section:

```
# -------------------------------------------------------------------------
# Program: [filename]
# Description: [what this does]
# Context: [EXAM] Lab - [scenario description]
# Author: Greg Tate
# Date: [YYYY-MM-DD]
# -------------------------------------------------------------------------
```

**Example for AI-102:**

```
# -------------------------------------------------------------------------
# Program: main.tf
# Description: Deploy Azure OpenAI with DALL-E 3 for image generation
# Context: AI-102 Lab - Generate and manipulate images with DALL-E
# Author: Greg Tate
# Date: 2026-02-09
# -------------------------------------------------------------------------
```

### Code Commenting Rules

1. **Add comments above code blocks** separated by blank lines
2. **Code block definition**: Any of the following:
   - Group of declarations/initializations separated by blank lines
   - Single significant assignment separated by blank lines
   - Each loop (`for`, `while`) body
   - Each `if` / `else if` / `else` body
3. Comments must describe the **intent** of the code block
4. Use **clear, descriptive names** for all resources, variables, and modules

### Naming Conventions (Code)

- **Terraform**: Use snake_case for resource names, variables, locals
- **Bicep**: Use camelCase for parameters, variables; kebab-case for symbolic resource names
- **Both**: Resource name values must follow Azure naming prefixes (see Resource Naming section)

---

## Documentation Requirements

### Required README.md Contents

Every lab directory must include a `README.md` with:

1. **Lab Overview**
   - Brief description of what the lab demonstrates
   - Exam objective reference
     - **AI-102**: "Implement generative AI solutions (30-35%)" or similar
     - **AZ-104**: "Configure and manage virtual networks (25-30%)" or similar

2. **Prerequisites**
   - Azure CLI or PowerShell requirements
   - Required permissions (e.g., Contributor on subscription)
   - Any pre-existing resources needed
   - For AI-102 labs: API version requirements, model availability

3. **Deployment Steps**

   ```bash
   # Terraform example
   terraform init
   terraform plan -var="exam=ai102" -var="domain=generative-ai" -var="topic=dalle-image-gen"
   terraform apply -auto-approve
   ```

   ```powershell
   # Bicep example
   ./bicep.ps1 Plan
   ./bicep.ps1 Deploy
   ```

4. **Validation Steps**
   - How to verify the deployment worked
   - Expected outcomes or tests to run
   - For AI labs: Include sample API calls, expected responses

5. **Testing AI Services** (AI-102 specific)
   - Connection string / endpoint / key retrieval
   - Sample REST API calls or SDK code
   - Expected outputs (images, text, analysis results)

6. **Cleanup Procedure**

   ```bash
   # Terraform
   terraform destroy -auto-approve
   
   # Bicep
   ./bicep.ps1 Destroy
   ```

7. **Troubleshooting** (if applicable)
   - Common issues and resolutions
   - Model availability errors
   - Quota/rate limit issues

---

## Tool-Specific Standards

### Terraform Standards

#### Provider Selection: AzureRM vs AzAPI

**Use AzureRM provider for all labs** unless a specific feature absolutely requires AzAPI.

| Provider | When to Use | Characteristics |
|----------|-------------|-----------------|
| **AzureRM** (Standard) | Default for all labs | ✅ Mature, well-documented<br>✅ Strongly-typed with IntelliSense<br>✅ Best for learning and production<br>✅ Comprehensive resource coverage |
| **AzAPI** (Advanced) | Only when AzureRM lacks a feature | ⚠️ Direct REST API access<br>⚠️ More complex, less intuitive<br>⚠️ For preview/bleeding-edge features<br>⚠️ Requires Azure REST API knowledge |

**Rationale**: AzureRM is the appropriate choice for certification labs because it's:

- Industry standard for Azure infrastructure-as-code
- Better documented with more examples
- Easier to read and understand
- More aligned with exam objectives and real-world usage

**AzAPI use cases** (rare in lab context):

- A brand-new Azure service not yet in AzureRM
- Preview feature with no AzureRM support
- Specific property not exposed by AzureRM resource

#### Required Versions

```hcl
terraform {
  required_version = ">= 1.0"
  
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 4.0"
    }
    # Add additional providers as needed:
    random = {
      source  = "hashicorp/random"
      version = "~> 3.0"
    }
    #
    # Only add azapi if absolutely necessary for a specific unsupported feature:
    # azapi = {
    #   source  = "Azure/azapi"
    #   version = "~> 2.0"
    # }
  }
}

provider "azurerm" {
  features {}
  subscription_id = var.lab_subscription_id
}
```

#### State Management

- **Local State:** Default for all labs (stored in `.tfstate` files)
- **Remote State:** Not required for learning labs
- **State Security:** Add `*.tfstate*` to `.gitignore`

#### File Structure

```
lab-<topic>/
├── terraform/
│   ├── main.tf
│   ├── variables.tf
│   ├── outputs.tf
│   ├── terraform.tfvars  (gitignored, use .tfvars.example)
│   └── README.md
```

#### Variable Files

- Use `terraform.tfvars` for local values (gitignored)
- **Required content**:

  ```hcl
  lab_subscription_id = "e091f6e7-031a-4924-97bb-8c983ca5d21a"
  location            = "eastus"
  owner               = "Greg Tate"
  date_created        = "2026-02-12"
  ```

- Provide `terraform.tfvars.example` as template
- Document all variables in `variables.tf` with descriptions
- **Never** store admin passwords or API keys in variable files

#### Module Standards

**When to create modules**: Use modules when the lab creates **3 or more related resources** within a logical grouping (e.g., networking, compute, storage, ai-services). For very simple labs with only 1-2 resources total, modules are optional.

**Module structure** — each module in `modules/<group>/`:

- `main.tf` — resource definitions
- `variables.tf` — input variables (tags, location, names, etc.)
- `outputs.tf` — values needed by other modules or root outputs

**Module design principles**:

- **Group by logical domain**: `modules/networking/`, `modules/compute/`, `modules/storage/`, `modules/ai-services/`
- **Self-contained**: Each module receives everything it needs via variables
- **Tag passing**: Pass `common_tags` as a `map(string)` variable and merge with resource-specific tags
- **Explicit dependencies**: Keep inter-module dependencies explicit via output references
- **Resource group placement**: Typically define resource group in `main.tf` (not in a module) since most modules need its name as input

**Orchestration layer** (`main.tf`):

- Keep `main.tf` thin — it should primarily call modules
- Define resource group, locals (common_tags, resource_group_name), and module calls
- Pass `common_tags`, `location`, and naming values into modules
- Do not define individual resources directly when a module is more appropriate

#### Credentials and Secrets

**Password Generation for Lab Environments**:

**CRITICAL**: Automatically generate friendly admin passwords that are easy to type but meet complexity requirements.

**Terraform approach**:

```hcl
# In providers.tf, add to required_providers:
random = {
  source  = "hashicorp/random"
  version = "~> 3.0"
}

# In main.tf or module:
resource "random_integer" "password_suffix" {
  min = 1000
  max = 9999
}

locals {
  admin_password = "AzureLab${random_integer.password_suffix.result}!"
}

# In outputs.tf:
output "admin_password" {
  description = "Generated admin password for resources (friendly format)"
  value       = local.admin_password
  sensitive   = true
}
```

**Friendly password patterns** (all meet complexity requirements):

- `AzureLab2026!` - Simple, memorable
- `LabPassword${variation}!` - Pattern with variation
- `Learning@Azure123` - Descriptive
- `Demo${year}Pass!` - Year-based

**Requirements**:

- Must include: uppercase, lowercase, numbers, special characters
- Output passwords so users can access resources
- Mark password outputs as `sensitive = true`
- **Never** define password variables in `variables.tf` or `terraform.tfvars`

**Azure AI Services Keys**:

- Azure automatically generates API keys for Cognitive Services / OpenAI accounts
- Output keys as sensitive values for testing:

```hcl
output "openai_endpoint" {
  value = azurerm_cognitive_account.openai.endpoint
}

output "openai_primary_key" {
  value     = azurerm_cognitive_account.openai.primary_access_key
  sensitive = true
}
```

**Note**: These friendly patterns are acceptable for lab environments. In production, use Key Vault and avoid predictable patterns.

### Bicep Standards

#### Required Configuration

```json
// bicepconfig.json
{
  "analyzers": {
    "core": {
      "enabled": true,
      "rules": {
        "no-hardcoded-env-urls": { "level": "warning" },
        "no-unused-params": { "level": "warning" }
      }
    }
  }
}
```

#### File Structure

```
lab-<topic>/
├── bicep/
│   ├── main.bicep
│   ├── main.bicepparam
│   ├── modules/  (if needed)
│   ├── bicep.ps1  (deployment script)
│   └── README.md
```

#### Parameter Files

- Use `.bicepparam` for all deployments
- Store deployment-specific values in parameter files
- Use `@secure()` decorator for sensitive parameters

#### Deployment Scripts

- **Always copy** `bicep.ps1` from `.assets/shared/bicep/bicep.ps1` folder to lab's `bicep/` folder
  - Location: `.assets/shared/bicep/bicep.ps1` (workspace root)
  - Copy to: `<EXAM>/hands-on-labs/<domain>/lab-<topic>/bicep/bicep.ps1`
- Script provides: validate, plan, apply, destroy, show, list commands
- Use deployment stacks for easier cleanup
- Stack naming: Auto-derived as `stack-<domain>-<topic>` from parameters

#### Module Standards

**When to create modules**: Use modules when the lab creates **3 or more related resources** within a logical grouping. For very simple labs with only 1-2 resources total, modules are optional.

**Module structure** — each module in `modules/`:

- `modules/<group>.bicep` (e.g., `modules/networking.bicep`, `modules/ai-services.bicep`)
- Declare parameters for all inputs (tags, location, names, etc.)
- Declare outputs for values needed by other modules or root template

**Module design principles**:

- **Group by logical domain**: `networking.bicep`, `compute.bicep`, `storage.bicep`, `ai-services.bicep`
- **Self-contained**: Each module receives everything it needs via parameters
- **Tag passing**: Pass `commonTags` as an `object` parameter, use `union()` for resource-specific tags
- **Explicit dependencies**: Keep inter-module dependencies explicit via output references
- **Resource group placement**: Typically define resource group in `main.bicep` (subscription-scoped), modules are scoped to it

**Orchestration layer** (`main.bicep`):

- Keep `main.bicep` thin — it should primarily call modules
- Define resource group, commonTags variable, and module calls
- Use `@allowed()` decorator for domain parameter validation
- Pass `commonTags`, `location`, and naming values into modules
- Do not define individual resources directly when a module is more appropriate

#### Credentials and Secrets

**Password Generation for Lab Environments**:

**Bicep approach**:

```bicep
// In main.bicep:
var adminPassword = 'AzureLab${uniqueString(resourceGroup().id, '2026')}!'

// Or for even more friendly:
var adminPassword = 'AzureLab2026!'

// In outputs:
@description('Admin password for resources (friendly format)')
output adminPassword string = adminPassword
```

**Azure AI Services Keys**:

- Azure automatically generates API keys for Cognitive Services / OpenAI accounts
- Output keys for testing:

```bicep
output openaiEndpoint string = openaiAccount.properties.endpoint

@description('Primary API key for Azure OpenAI (sensitive)')
output openaiPrimaryKey string = openaiAccount.listKeys().key1
```

**Friendly password patterns** (all meet complexity requirements):

- `AzureLab2026!` - Simple, memorable
- `LabPassword${variation}!` - Pattern with variation
- `Learning@Azure123` - Descriptive
- `Demo${year}Pass!` - Year-based

**Requirements**:

- Must include: uppercase, lowercase, numbers, special characters
- Output passwords so users can access resources
- Ensure complexity requirements are met

**Note**: These friendly patterns are acceptable for lab environments. In production, use Key Vault and avoid predictable patterns.

---

## Lab Lifecycle Policy

### Lab States

| State | Description | Action Required |
|-------|-------------|----------------|
| **Active** | Currently being developed or used | Regular updates |
| **Reference** | Completed, kept for future reference | Document in main README |
| **Archived** | No longer relevant; kept for history | Move to `archived/` directory |
| **Deleted** | Resources destroyed, code removed | Remove from repository |

### Decision Criteria

- **Keep as Reference:** Lab demonstrates important exam concept, well-documented, validated
- **Archive:** Lab outdated due to Azure changes or exam updates
- **Delete:** Experimental/incomplete work, duplicate of better implementation

### Archival Process

1. Move lab directory to `archived/<domain>/`
2. Update main domain README to remove archived lab
3. Add entry to `archived/README.md` with reason and date
4. Ensure all Azure resources destroyed before archiving

---

## Implementation Examples

### Terraform - AZ-104 Example

```hcl
# variables.tf
variable "exam" {
  description = "Certification exam code (lowercase)"
  type        = string
  validation {
    condition     = contains(["ai102", "az104"], var.exam)
    error_message = "Exam must be: ai102 or az104."
  }
}

variable "domain" {
  description = "Exam domain"
  type        = string
  validation {
    condition     = contains(["identity", "networking", "storage", "compute", "monitoring"], var.domain)
    error_message = "Domain must be: identity, networking, storage, compute, or monitoring."
  }
}

variable "topic" {
  description = "Lab topic in kebab-case"
  type        = string
}

variable "owner" {
  description = "Lab owner"
  type        = string
  default     = "Greg Tate"
}

variable "date_created" {
  description = "Date the lab resources were created (YYYY-MM-DD format)"
  type        = string

  validation {
    condition     = can(regex("^\\\\d{4}-\\\\d{2}-\\\\d{2}$", var.date_created))
    error_message = "Date must be in YYYY-MM-DD format."
  }
}

locals {
  resource_group_name = "${var.exam}-${var.domain}-${var.topic}-tf"
  
  common_tags = {
    Environment = "Lab"
    Project     = upper(var.exam)
    Domain      = title(var.domain)
    Purpose     = replace(title(var.topic), "-", " ")
    Owner       = var.owner
    DateCreated = var.date_created
    DeploymentMethod = "Terraform"
  }
}

# main.tf
resource "azurerm_resource_group" "lab" {
  name     = local.resource_group_name
  location = var.location
  tags     = local.common_tags
}
```

### Terraform - AI-102 Example (Azure OpenAI + DALL-E)

```hcl
# -------------------------------------------------------------------------
# Program: main.tf
# Description: Deploy Azure OpenAI with DALL-E 3 for image generation
# Context: AI-102 Lab - Generate and manipulate images with DALL-E
# Author: Greg Tate
# Date: 2026-02-09
# -------------------------------------------------------------------------

# variables.tf
variable "exam" {
  description = "Certification exam code (lowercase)"
  type        = string
  default     = "ai102"
  validation {
    condition     = contains(["ai102", "az104"], var.exam)
    error_message = "Exam must be: ai102 or az104."
  }
}

variable "domain" {
  description = "Exam domain"
  type        = string
  default     = "generative-ai"
  validation {
    condition     = contains(["ai-services", "generative-ai", "computer-vision", "nlp", "knowledge-mining"], var.domain)
    error_message = "Domain must be a valid AI-102 domain."
  }
}

variable "topic" {
  description = "Lab topic in kebab-case"
  type        = string
  default     = "dalle-image-gen"
}

variable "location" {
  description = "Azure region"
  type        = string
  default     = "eastus"
}

variable "owner" {
  description = "Lab owner"
  type        = string
  default     = "Greg Tate"
}

variable "date_created" {
  description = "Date the lab resources were created (YYYY-MM-DD format)"
  type        = string

  validation {
    condition     = can(regex("^\\\\d{4}-\\\\d{2}-\\\\d{2}$", var.date_created))
    error_message = "Date must be in YYYY-MM-DD format."
  }
}

variable "image_model_name" {
  description = "DALL-E model name"
  type        = string
  default     = "dall-e-3"
}

variable "image_model_version" {
  description = "DALL-E model version"
  type        = string
  default     = "1.0"
}

locals {
  resource_group_name = "${var.exam}-${var.domain}-${var.topic}-tf"
  
  common_tags = {
    Environment      = "Lab"
    Project          = upper(var.exam)
    Domain           = title(replace(var.domain, "-", " "))
    Purpose          = "DALL-E Image Generation"
    Owner            = var.owner
    DateCreated      = var.date_created
    DeploymentMethod = "Terraform"
  }
}

# main.tf
resource "azurerm_resource_group" "lab" {
  name     = local.resource_group_name
  location = var.location
  tags     = local.common_tags
}

resource "random_string" "suffix" {
  length  = 6
  upper   = false
  special = false
}

# Azure OpenAI account
resource "azurerm_cognitive_account" "openai" {
  name                = "oai-dalle-${random_string.suffix.result}"
  location            = azurerm_resource_group.lab.location
  resource_group_name = azurerm_resource_group.lab.name

  kind     = "OpenAI"
  sku_name = "S0"

  # Exam-lab friendly settings
  public_network_access_enabled = true

  # Managed identity for RBAC scenarios
  identity {
    type = "SystemAssigned"
  }

  tags = local.common_tags
}

# Deploy DALL-E 3 model
resource "azurerm_cognitive_deployment" "dalle" {
  name                 = "deploy-dalle3"
  cognitive_account_id = azurerm_cognitive_account.openai.id

  model {
    format  = "OpenAI"
    name    = var.image_model_name
    version = var.image_model_version
  }

  scale {
    type = "Standard"
  }
}

# Storage account for generated images (optional)
resource "azurerm_storage_account" "images" {
  name                     = "stai102img${random_string.suffix.result}"
  resource_group_name      = azurerm_resource_group.lab.name
  location                 = azurerm_resource_group.lab.location
  account_tier             = "Standard"
  account_replication_type = "LRS"

  allow_nested_items_to_be_public = false

  tags = merge(local.common_tags, {
    Purpose = "Store DALL-E Generated Images"
  })
}

resource "azurerm_storage_container" "images" {
  name                  = "images"
  storage_account_id    = azurerm_storage_account.images.id
  container_access_type = "private"
}

# outputs.tf
output "openai_endpoint" {
  description = "Azure OpenAI endpoint URL"
  value       = azurerm_cognitive_account.openai.endpoint
}

output "openai_account_name" {
  description = "Azure OpenAI account name"
  value       = azurerm_cognitive_account.openai.name
}

output "image_deployment_name" {
  description = "DALL-E deployment name"
  value       = azurerm_cognitive_deployment.dalle.name
}

output "openai_primary_key" {
  description = "Azure OpenAI primary API key (key-based auth)"
  value       = azurerm_cognitive_account.openai.primary_access_key
  sensitive   = true
}

output "storage_account_name" {
  description = "Storage account for generated images"
  value       = azurerm_storage_account.images.name
}

output "storage_container_name" {
  description = "Blob container for generated images"
  value       = azurerm_storage_container.images.name
}
```

### Bicep - AI-102 Example (Azure OpenAI + DALL-E)

```bicep
// -------------------------------------------------------------------------
// Program: main.bicep
// Description: Deploy Azure OpenAI with DALL-E 3 for image generation
// Context: AI-102 Lab - Generate and manipulate images with DALL-E
// Author: Greg Tate
// Date: 2026-02-09
// -------------------------------------------------------------------------

targetScope = 'subscription'

@allowed(['ai102', 'az104'])
param exam string = 'ai102'

@allowed(['ai-services', 'generative-ai', 'computer-vision', 'nlp', 'knowledge-mining'])
param domain string = 'generative-ai'

param topic string = 'dalle-image-gen'
param location string = 'eastus'
param owner string = 'Greg Tate'
param dateCreated string = '2026-02-09'

param imageModelName string = 'dall-e-3'
param imageModelVersion string = '1.0'

var resourceGroupName = '${exam}-${domain}-${topic}-bicep'
var openaiName = 'oai-dalle-${uniqueString(subscription().id, resourceGroupName)}'
var storageName = 'stai102img${uniqueString(subscription().id, resourceGroupName)}'

var commonTags = {
  Environment: 'Lab'
  Project: toUpper(exam)
  Domain: replace(domain, '-', ' ')
  Purpose: 'DALL-E Image Generation'
  Owner: owner
  DateCreated: dateCreated
  DeploymentMethod: 'Bicep'
}

// Resource group
resource rg 'Microsoft.Resources/resourceGroups@2024-03-01' = {
  name: resourceGroupName
  location: location
  tags: commonTags
}

// Azure OpenAI account
module openai 'modules/ai-services.bicep' = {
  name: 'openai-deployment'
  scope: rg
  params: {
    location: location
    openaiName: openaiName
    imageModelName: imageModelName
    imageModelVersion: imageModelVersion
    commonTags: commonTags
  }
}

// Storage for generated images
module storage 'modules/storage.bicep' = {
  name: 'storage-deployment'
  scope: rg
  params: {
    location: location
    storageName: storageName
    commonTags: commonTags
  }
}

// Outputs
output openaiEndpoint string = openai.outputs.endpoint
output openaiAccountName string = openai.outputs.accountName
output imageDeploymentName string = openai.outputs.deploymentName
output openaiPrimaryKey string = openai.outputs.primaryKey
output storageAccountName string = storage.outputs.accountName
output storageContainerName string = storage.outputs.containerName
```

**Module: `modules/ai-services.bicep`**

```bicep
param location string
param openaiName string
param imageModelName string
param imageModelVersion string
param commonTags object

// Azure OpenAI cognitive account
resource openaiAccount 'Microsoft.CognitiveServices/accounts@2023-05-01' = {
  name: openaiName
  location: location
  kind: 'OpenAI'
  sku: {
    name: 'S0'
  }
  properties: {
    publicNetworkAccess: 'Enabled'
    customSubDomainName: openaiName
  }
  identity: {
    type: 'SystemAssigned'
  }
  tags: commonTags
}

// DALL-E 3 model deployment
resource dalleDeployment 'Microsoft.CognitiveServices/accounts/deployments@2023-05-01' = {
  parent: openaiAccount
  name: 'deploy-dalle3'
  sku: {
    name: 'Standard'
    capacity: 1
  }
  properties: {
    model: {
      format: 'OpenAI'
      name: imageModelName
      version: imageModelVersion
    }
  }
}

output endpoint string = openaiAccount.properties.endpoint
output accountName string = openaiAccount.name
output deploymentName string = dalleDeployment.name
output primaryKey string = openaiAccount.listKeys().key1
```

---

## Pre-Deployment Checklist

Before deploying any lab:

### Naming & Organization

- [ ] Resource group follows `<exam>-<domain>-<topic>-<deployment_method>` pattern
- [ ] Resource names follow defined prefix patterns (including AI-specific resources)
- [ ] Deployment stack (Bicep) follows `stack-<domain>-<topic>` pattern

### Tagging & Metadata

- [ ] All resources include required tags: `Environment`, `Project`, `Domain`, `Purpose`, `Owner`, `DateCreated`, `DeploymentMethod`
- [ ] `Project` tag uses uppercase exam code (AI-102, AZ-104)
- [ ] `DateCreated` set to current date for cleanup tracking

### Configuration

- [ ] Location is in allowed US regions (default: `eastus`; any US region permitted per Location Policy)
- [ ] **AI-specific**: Regional capacity validated for all required services (run capacity checks for AI Search, Cosmos DB, model availability)
- [ ] Resource SKUs are cost-appropriate:
  - VMs: `Standard_B2s` or smaller
  - AI Services: F0 (Free) or S0 (Standard) tier
  - Storage: Standard LRS
- [ ] VM auto-shutdown configured for 7:00 PM EST (if VMs present)
- [ ] Resource counts within limits
- [ ] **AI-specific**: Model names/versions validated for target region

### Documentation

- [ ] README.md includes lab overview and exam objective reference
- [ ] README.md documents prerequisites and required permissions
- [ ] README.md provides deployment steps with example commands
- [ ] README.md includes validation/testing steps
- [ ] **AI-specific**: README includes sample API calls and expected responses
- [ ] README.md documents cleanup procedure with actual commands
- [ ] Parameter file example provided (`.tfvars.example` or `.bicepparam`)

### Code Quality

- [ ] Header comment section included with exam context
- [ ] **Terraform:** Using AzureRM provider (not AzAPI) unless specific feature requires it
- [ ] **Terraform:** Version constraints specified (`>= 1.0`)
- [ ] **Terraform:** `terraform.tfvars` in `.gitignore`
- [ ] **Bicep:** `bicepconfig.json` present with linter rules
- [ ] **Bicep:** Deployment script (`bicep.ps1`) included
- [ ] Sensitive values (keys, passwords) use appropriate security mechanisms
- [ ] API keys outputted as sensitive for AI services

### Testing

- [ ] Deployment tested and validates successfully
- [ ] **AI-specific**: API endpoints tested with sample calls
- [ ] **AI-specific**: Model availability confirmed in target region
- [ ] Cleanup/destroy commands tested and verified
- [ ] No orphaned resources remain after cleanup

---

## Common AI Service Deployment Patterns

### Pattern 1: Azure OpenAI with Multiple Models

Deploy OpenAI account with chat (GPT-4) and embeddings models:

```hcl
# Azure OpenAI account
resource "azurerm_cognitive_account" "openai" {
  name                = "oai-multimodel-${random_string.suffix.result}"
  location            = var.location
  resource_group_name = azurerm_resource_group.lab.name
  kind                = "OpenAI"
  sku_name            = "S0"
  public_network_access_enabled = true
  tags = local.common_tags
}

# GPT-4 deployment
resource "azurerm_cognitive_deployment" "gpt4" {
  name                 = "deploy-gpt4"
  cognitive_account_id = azurerm_cognitive_account.openai.id
  model {
    format  = "OpenAI"
    name    = "gpt-4"
    version = "0613"
  }
  scale {
    type = "Standard"
  }
}

# Embeddings deployment
resource "azurerm_cognitive_deployment" "embeddings" {
  name                 = "deploy-embeddings"
  cognitive_account_id = azurerm_cognitive_account.openai.id
  model {
    format  = "OpenAI"
    name    = "text-embedding-ada-002"
    version = "2"
  }
  scale {
    type = "Standard"
  }
}
```

### Pattern 2: Multi-Service Cognitive Services Account

Single account for multiple AI capabilities (Vision, Language, Speech):

```hcl
# Multi-service Cognitive Services account
resource "azurerm_cognitive_account" "multi" {
  name                = "cog-multiservice-${random_string.suffix.result}"
  location            = var.location
  resource_group_name = azurerm_resource_group.lab.name
  kind                = "CognitiveServices"  # Multi-service
  sku_name            = "S0"
  public_network_access_enabled = true
  tags = local.common_tags
}

output "multi_service_endpoint" {
  value = azurerm_cognitive_account.multi.endpoint
}

output "multi_service_key" {
  value     = azurerm_cognitive_account.multi.primary_access_key
  sensitive = true
}
```

Single endpoint/key for Vision, Language, Speech, Translation APIs.

### Pattern 3: Custom Vision (Training + Prediction)

Separate resources for training and prediction:

```hcl
# Custom Vision training resource
resource "azurerm_cognitive_account" "cv_training" {
  name                = "cvtr-classifier-${random_string.suffix.result}"
  location            = var.location
  resource_group_name = azurerm_resource_group.lab.name
  kind                = "CustomVision.Training"
  sku_name            = "F0"  # Free tier for lab
  tags = local.common_tags
}

# Custom Vision prediction resource
resource "azurerm_cognitive_account" "cv_prediction" {
  name                = "cvpr-classifier-${random_string.suffix.result}"
  location            = var.location
  resource_group_name = azurerm_resource_group.lab.name
  kind                = "CustomVision.Prediction"
  sku_name            = "F0"  # Free tier for lab
  tags = local.common_tags
}
```

---

## Azure Resource Configuration Best Practices

These standards prevent common deployment errors and ensure reliable infrastructure code.

### Load Balancers with Outbound Rules

**CRITICAL**: When configuring Standard Load Balancers with BOTH load balancing rules AND outbound rules that share the same frontend IP configuration:

- **Always set `disableOutboundSnat: true`** (Bicep) or `disable_outbound_snat = true` (Terraform) on the load balancing rule
- This prevents SNAT port allocation conflicts between the two rule types
- Azure requires this when a frontend IP is referenced by both rule types

**Error if omitted**: `LoadBalancingRuleMustDisableSNATSinceSameFrontendIPConfigurationIsReferencedByOutboundRule`

### Network Interfaces and Backend Pools

**CRITICAL**: A VM's Network Interface (NIC) with an instance-level public IP address **cannot** be added to a Load Balancer's outbound rule backend pool.

- **Problem**: Azure does not allow NICs with direct public IPs in outbound rule backend pools
- **Solution**: Use separate backend pools for inbound and outbound rules when VMs have instance public IPs
- **Alternative**: Remove instance public IPs from VMs if they will use Load Balancer outbound rules for internet access
- **Common scenario**: VM with Bastion access (no public IP needed) can safely use outbound rule backend pool

### Network Security Groups

- Ensure required ports are open for service functionality:
  - Port 80 for HTTP
  - Port 443 for HTTPS
  - Port 22 for SSH (Linux)
  - Port 3389 for RDP (Windows)
- Document any custom ports in README
- Use specific source IP ranges when possible (avoid 0.0.0.0/0 except for public-facing services)

### Public IP SKU Compatibility

- **Standard Load Balancers** require **Standard SKU** public IPs (not Basic)
- **Basic Load Balancers** can use **Basic SKU** public IPs
- Standard SKU IPs support availability zones; Basic SKU does not

### Storage Containers and File Shares

**CRITICAL**: `azurerm_storage_container` and `azurerm_storage_share` resources require `storage_account_id` (not `storage_account_name`). The `storage_account_name` argument is deprecated and will be removed in AzureRM provider v5.0.

- **Always use `storage_account_id`** referencing the storage account's `.id` attribute
- **Do not use `storage_account_name`** referencing the storage account's `.name` attribute

**Correct:**

```hcl
resource "azurerm_storage_container" "example" {
  name                  = "documents"
  storage_account_id    = azurerm_storage_account.data.id
  container_access_type = "private"
}

resource "azurerm_storage_share" "example" {
  name                 = "fileshare"
  storage_account_id   = azurerm_storage_account.data.id
  quota                = 5
}
```

**Incorrect (deprecated):**

```hcl
resource "azurerm_storage_container" "example" {
  name                  = "documents"
  storage_account_name  = azurerm_storage_account.data.name  # DEPRECATED
  container_access_type = "private"
}
```

### Azure AI Services Configuration

#### Cognitive Services / OpenAI Accounts

- **Public network access**: Enable for lab environments (`public_network_access_enabled = true`)
- **Private endpoints**: Optional for advanced scenarios; adds complexity
- **Authentication**:
  - **Key-based auth**: Default for labs (easiest to test)
  - **Managed identity**: Better for production patterns; requires RBAC setup
- **SKU selection**: Use S0 for OpenAI (no free tier); F0/S0 for other Cognitive Services

#### Model Deployments (Azure OpenAI)

- **Model name and version**: Region-dependent; validate availability before deployment
  - Common models: `gpt-4`, `gpt-4-turbo`, `gpt-35-turbo`, `dall-e-3`, `text-embedding-ada-002`
  - Versions vary: `0613`, `1.0`, `2024-02-15-preview`, etc.
- **Deployment name**: Descriptive, matches model purpose (e.g., `deploy-gpt4`, `img-dalle`)
- **Scale type**: `Standard` for most labs; `Provisioned` for high-throughput scenarios
- **Capacity**: Start minimal; Azure OpenAI uses token-based throttling
- **API version**: Pin in client code/scripts (e.g., `2024-10-21`); changes frequently

#### Storage for AI Outputs

- Use dedicated storage account for AI-generated content (images, documents, etc.)
- Create blob container with private access
- Consider lifecycle management for cleanup of generated outputs

#### Managed Identity RBAC for AI Agent Service

**CRITICAL**: When deploying Azure AI Agent Service (standard setup with BYOS), the project's System-Assigned Managed Identity requires **both control plane and data plane permissions**. Missing control plane roles will cause capability host creation to fail with `CapabilityHostOperationFailed` or authorization errors.

| Service | Data Plane Role | Control Plane Role (Azure RBAC) | Why Control Plane Is Needed |
|---------|-----------------|--------------------------------|-----------------------------|
| Cosmos DB | Cosmos DB SQL Data Contributor (`sqlRoleAssignments`) | **Cosmos DB Operator** (`230815da-be43-4aae-9cb4-875f7bd000aa`) | Capability host must create the `enterprise_memory` database via ARM APIs |
| Storage | Storage Blob Data Contributor + Storage Blob Data Owner (with ABAC condition) | (none required) | Data plane sufficient for blob operations |
| AI Search | Search Index Data Contributor | Search Service Contributor | Both planes needed for index management |

**Key points:**

- **Data plane** roles allow read/write of data within the service (documents, blobs, indexes)
- **Control plane** roles allow reading metadata, creating databases, and managing service configuration via ARM
- The Cosmos DB Operator role is **not documented** in official AI Agent Service setup guides but is **required** — without it, the capability host cannot verify or create the Cosmos DB database and the deployment fails
- The Storage Blob Data Owner role **must** include an ABAC condition restricting access to containers matching `<workspaceId>*-azureml-agent` — this is the container pattern used by the agent service for file uploads

#### Cognitive Services Soft-Delete and Purge (Bicep)

**CRITICAL**: Cognitive Services accounts (Azure OpenAI, AI Services multi-service accounts, etc.) are **soft-deleted** when destroyed and remain in a deleted-but-not-purged state for a retention period. Attempting to redeploy with the same name during this period fails with `FlagMustBeSetForRestore` error.

**Problem**: This breaks the deploy/destroy/redeploy cycle essential for lab development and testing.

**Solution**: Implement automatic purge in Bicep deployment scripts (`bicep.ps1`) to ensure clean redeployment cycles:

1. **Before stack deletion**: Query and capture Cognitive Services account metadata (name, location, resource group)
2. **After stack deletion**: Automatically purge soft-deleted accounts

**Implementation pattern** (add to `bicep.ps1`):

```powershell
function Invoke-DestroyAction {
    # Capture Cognitive Services accounts before destroy
    $cogAccounts = Get-CognitiveServicesAccounts -StackName $script:StackName

    # Destroy the stack
    $command = New-StackCommand -Action 'destroy' -StackName $script:StackName
    Invoke-Expression $command
    $destroyExitCode = $LASTEXITCODE

    # Purge soft-deleted accounts after successful destroy
    if ($destroyExitCode -eq 0 -and $cogAccounts.Count -gt 0) {
        Invoke-PurgeCognitiveServices -Accounts $cogAccounts
    }

    exit $destroyExitCode
}

function Get-CognitiveServicesAccounts {
    param([string]$StackName)

    $stackJson = az stack sub show --name $StackName -o json 2>$null
    if ($LASTEXITCODE -ne 0) { return @() }

    $stack = $stackJson | ConvertFrom-Json
    $cogResources = $stack.resources |
        Where-Object { $_.id -match 'Microsoft.CognitiveServices/accounts' -and $_.id -notmatch '/projects/' }

    $accounts = @()
    foreach ($res in $cogResources) {
        # Extract name and resource group from resource ID
        $parts = $res.id -split '/'
        $rgIndex = [array]::IndexOf($parts, 'resourceGroups') + 1
        $nameIndex = [array]::IndexOf($parts, 'accounts') + 1

        $accountJson = az cognitiveservices account show `
            --name $parts[$nameIndex] `
            --resource-group $parts[$rgIndex] `
            --query '{name:name, location:location, resourceGroup:resourceGroup}' `
            -o json 2>$null

        if ($LASTEXITCODE -eq 0 -and $accountJson) {
            $accounts += ($accountJson | ConvertFrom-Json)
        }
    }

    return $accounts
}

function Invoke-PurgeCognitiveServices {
    param([array]$Accounts)

    Write-Host "`n🧹 Purging soft-deleted Cognitive Services accounts..." -ForegroundColor Cyan

    foreach ($account in $Accounts) {
        Write-Host "   Purging: $($account.name) in $($account.location)" -ForegroundColor Gray

        az cognitiveservices account purge `
            --name $account.name `
            --resource-group $account.resourceGroup `
            --location $account.location 2>$null

        if ($LASTEXITCODE -eq 0) {
            Write-Host "   ✅ Purged: $($account.name)" -ForegroundColor Green
        } else {
            Write-Host "   ⚠️  Could not purge: $($account.name) (may need manual cleanup)" -ForegroundColor Yellow
        }
    }
}
```

**Key points:**

- **Do not use `restore: true` in Bicep** — this causes `CanNotRestoreANonExistingResource` error on first deployment or after successful purge
- **Purge command**: `az cognitiveservices account purge --name <name> --resource-group <rg> --location <location>`
- **Manual cleanup**: If purge automation fails, manually list and purge: `az cognitiveservices account list-deleted` and `az cognitiveservices account purge`
- **Applies to**: Azure OpenAI accounts, AI Services multi-service accounts, and all Cognitive Services single-service accounts
- **Retention period**: Varies by service; purge makes the name immediately available for reuse

**Why this matters for labs**: AI-102 labs frequently iterate on deployments during development. Without automatic purge, developers must manually clean up soft-deleted resources or wait for retention periods to expire, which disrupts the development workflow.

### Subnet Delegation

Some services require subnet delegation:

- Azure Container Instances: `Microsoft.ContainerInstance/containerGroups`
- Azure Databricks: `Microsoft.Databricks/workspaces`
- Azure NetApp Files: `Microsoft.NetApp/volumes`
- Document delegation requirements in README

### Resource Dependencies

- Prefer **implicit dependencies** (resource references) over explicit `depends_on`/`dependsOn`
- Use **explicit dependencies** only when:
  - Relationship is not captured by resource references
  - Timing/sequencing is critical (e.g., role assignments after resource creation)
- Document why explicit dependencies are needed with comments

### Preview API Resources and Failed Provisioning States

**CRITICAL**: Resources deployed using preview API versions (e.g., `2025-04-01-preview`) can enter an unrecoverable `provisioningState: "Failed"` state. When this happens, subsequent deployment retries will fail with generic errors like `"Update operation failed"` because Azure cannot update a resource stuck in a failed state.

**Symptoms:**

- Deployment fails, retry produces the same error even after fixing the root cause
- `az resource list` shows the resource with `provisioningState: "Failed"`
- Deployment stack reports `CapabilityHostOperationFailed` or similar with no actionable detail

**Resolution pattern:**

1. Identify the failed resource:

   ```powershell
   az resource list --resource-group <rg> \
     --query "[?properties.provisioningState=='Failed'].{name:name, type:type}" -o table
   ```

2. Delete the stuck resource via REST API (deployment stacks may not auto-clean these):

   ```powershell
   az rest --method DELETE \
     --url "https://management.azure.com/<resource-id>?api-version=<preview-version>"
   ```

3. Wait 30–60 seconds for backend cleanup and RBAC propagation
4. Retry the deployment

**Applies to:** Capability hosts, preview Cognitive Services features, AI Foundry project resources, and other resources using preview API versions.

**Prevention:**

- When a module depends on RBAC assignments (e.g., capability hosts depending on role assignments), use explicit `dependsOn` to ensure permissions propagate before the dependent resource is created
- For Bicep deployment stacks, failed resources from a preview API sometimes need manual deletion before the stack can successfully update
- Cosmos DB accounts that fail during provisioning often cannot be updated and must be deleted before retrying (use `az cosmosdb delete` or delete the containing resource group)

### Validation Script Requirements

**Child resource name handling**: Azure REST APIs may return child resource names in hierarchical format (e.g., `parentName/childName` instead of just `childName`). Validation scripts that use these names in subsequent REST calls must extract only the child segment.

**Pattern:**

```powershell
# Azure may return 'parentAccount/projectName' — extract child segment
$projectFullName = az rest --method get --url "<list-url>" --query "value[0].name" -o tsv
$project = ($projectFullName -split '/')[-1]
```

**Best practices for validation scripts:**

- Always validate that discovery steps return non-empty values before running tests
- Use defensive parsing for all REST API responses (null checks, array bounds)
- Test validation scripts against actual deployed resources immediately after first successful deployment
- Don't assume consistent name formats across different API versions

---

## Version History

| Date | Version | Changes |
|------|---------|---------|
| 2026-02-13 | 2.2 | Added AI Agent Service RBAC requirements (control plane + data plane); preview API failed state recovery; Cosmos DB naming; validation script best practices; regional capacity validation guidance |
| 2026-02-11 | 2.1 | Added Storage Container/Share `storage_account_id` migration guidance; deprecated `storage_account_name` usage |
| 2026-02-09 | 2.0 | Extended governance to AI-102; added Azure AI services naming; multi-exam support |
| 2026-01-15 | 1.0 | Initial AZ-104 governance policy |
