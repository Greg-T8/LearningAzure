# Hands-On Labs Governance Policy

Standards and naming conventions for all Terraform and Bicep implementations across Azure certification labs (AI-102, AI-900, AZ-104, etc.).

---

## General Policies

### Location Policy

| Setting | Value | Rationale |
|---------|-------|-----------|
| Default Region | `eastus` | Cost-effective, wide service availability |
| Allowed Regions | `eastus`, `eastus2`, `westus2` | Limit to minimize latency and cost |

### Tagging Policy

All resources **must** include these tags:

| Tag | Description | Example |
|-----|-------------|---------|
| `Environment` | Fixed value | `Lab` |
| `Project` | Certification context | `AI-102`, `AI-900`, `AZ-104` |
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
| `ai-services` | Cognitive Services (OpenAI, Vision, Language, Speech, etc.), AI Foundry, Cognitive Deployments | AI-102, AI-900 |
| `generative-ai` | Azure OpenAI, Model Deployments (GPT-4, DALL-E, etc.), Prompt Flow | AI-102, AI-900 |
| `computer-vision` | Computer Vision, Custom Vision, Face API, Form Recognizer/Document Intelligence | AI-102, AI-900 |
| `nlp` | Language Service, Translator, Speech Services | AI-102, AI-900 |

---

## Naming Conventions

### Resource Group Naming

**Pattern:** `<exam>-<domain>-<topic>-<deployment_method>`

| Segment | Description | Allowed Values |
|---------|-------------|----------------|
| `<exam>` | Certification exam code (lowercase) | `ai102`, `ai900`, `az104` |
| `<domain>` | Exam domain or service area | AZ-104: `identity`, `networking`, `storage`, `compute`, `monitoring`<br>AI-102/AI-900: `ai-services`, `generative-ai`, `computer-vision`, `nlp`, `knowledge-mining` |
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

#### Azure AI Services Resources (AI-102, AI-900)

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
| Cognitive Deployment (Model) | `deploy` | `deploy-gpt4`, `deploy-dalle3` | Model deployment within OpenAI account |
| AI Foundry Hub | `aih` | `aih-project-hub` | AI Foundry hub resource |
| AI Foundry Project | `aip` | `aip-genai-lab` | AI Foundry project resource |
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

#### Azure AI Services Resources (AI-102, AI-900)

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

## Azure Resource Configuration Best Practices

These standards prevent common deployment errors and ensure reliable infrastructure code.

### Load Balancers with Outbound Rules

**CRITICAL**: When configuring Standard Load Balancers with BOTH load balancing rules AND outbound rules that share the same frontend IP configuration:

- **Always set `disableOutboundSnat: true`** (Bicep) or `disable_outbound_snat = true` (Terraform) on the load balancing rule
- This prevents SNAT port allocation conflicts between the two rule types
- Azure requires this when a frontend IP is referenced by both rule types

**Error if omitted**: `LoadBalancingRuleMustDisableSNATSinceSameFrontendIPConfigurationIsReferencedByOutboundRule`

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
   - For AI labs: API version requirements, model availability

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

5. **Testing AI Services** (AI-102/AI-900 specific)
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
  location = "eastus"
  owner    = "Greg Tate"
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

- **Always copy** `bicep.ps1` from exam-specific `_shared/bicep/bicep.ps1` folder to lab's `bicep/` folder
  - Example: `AZ-104/hands-on-labs/_shared/bicep/bicep.ps1`
  - Example: `AI-102/hands-on-labs/_shared/bicep/bicep.ps1`
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
    condition     = contains(["ai102", "ai900", "az104"], var.exam)
    error_message = "Exam must be: ai102, ai900, or az104."
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

locals {
  resource_group_name = "${var.exam}-${var.domain}-${var.topic}-tf"
  
  common_tags = {
    Environment = "Lab"
    Project     = upper(var.exam)
    Domain      = title(var.domain)
    Purpose     = replace(title(var.topic), "-", " ")
    Owner       = var.owner
    DateCreated = formatdate("YYYY-MM-DD", timestamp())
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
    condition     = contains(["ai102", "ai900", "az104"], var.exam)
    error_message = "Exam must be: ai102, ai900, or az104."
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
    DateCreated      = formatdate("YYYY-MM-DD", timestamp())
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
  storage_account_name  = azurerm_storage_account.images.name
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

@allowed(['ai102', 'ai900', 'az104'])
param exam string = 'ai102'

@allowed(['ai-services', 'generative-ai', 'computer-vision', 'nlp', 'knowledge-mining'])
param domain string = 'generative-ai'

param topic string = 'dalle-image-gen'
param location string = 'eastus'
param owner string = 'Greg Tate'
param dateCreated string = utcNow('yyyy-MM-dd')

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
- [ ] `Project` tag uses uppercase exam code (AI-102, AI-900, AZ-104)
- [ ] `DateCreated` set to current date for cleanup tracking

### Configuration

- [ ] Location is in allowed regions (`eastus`, `eastus2`, `westus2`)
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

## Version History

| Date | Version | Changes |
|------|---------|---------|
| 2026-02-09 | 2.0 | Extended governance to AI-102 and AI-900; added Azure AI services naming; multi-exam support |
| 2026-01-15 | 1.0 | Initial AZ-104 governance policy |
