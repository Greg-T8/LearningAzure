---
name: Lab
description: Creates a hands-on lab from an exam question scenario using Terraform or Bicep, following governance standards
---

# Hands-on Lab Generator

Create a working, validated hands-on lab from an exam-question scenario using the **most appropriate deployment method**, strictly compliant with `Governance-Lab.md` (workspace root). Treat `Governance-Lab.md` as the single source of truth for naming, tagging, locations, versions, structure, and deployment standards.

## Deployment method evaluation

**Analyze the exam question to determine the best-fit deployment method. Preference order: IaaC > Scripted > Manual (UI).**

### When to use Infrastructure as Code (Terraform or Bicep) - **PREFERRED**

Use when:

* Question involves deploying/provisioning Azure resources
* Scenario requires repeatable infrastructure deployment
* Focus is on resource configuration and architecture
* Example: "Deploy a VM with specific networking configuration"

### When to use Scripted (PowerShell/Azure CLI)

Use when:

* Question explicitly asks for command sequences
* Scenario involves imperative operations or workflows
* Focus is on operational tasks, not resource provisioning
* Example: "Run these commands to configure deployment slots" or "Prepare App Service for republication"

### When to use Manual (Portal/UI)

Use when:

* Question tests knowledge of Azure Portal navigation
* Scenario requires interactive UI features (e.g., specific portal blades)
* Focus is on understanding portal workflows
* Example: "Configure monitoring alerts through Azure Portal"

**Default to IaaC unless the exam question clearly requires scripting or manual steps.**

### IaaC choice selection

When IaaC is determined to be the appropriate deployment method, **ask the user** whether they want to use:

* **Terraform**, or
* **Bicep**

Do not assume or auto-select between Terraform and Bicep—always prompt for user preference.

## Non-negotiables

### Bicep wrapper script

* For **Bicep labs only**: **Do not create or modify** `bicep.ps1`.
* **Always copy** it from: `.assets/shared/bicep/bicep.ps1` (workspace root) into the lab's `bicep/` folder.

### README.md rules

* README must use the **required section set** in the order specified below.

**README required sections (in this order)**

* Exam Question Scenario (verbatim options, **DO NOT mark or reveal the correct answer**)
* Solution Architecture
* Architecture Diagram (Mermaid) **only if** 3+ interconnected resources
* Lab Objectives (3–5)
* Lab Structure (directory tree showing key files - **keep brief**)
* Prerequisites
* Deployment (deployment commands/steps - **keep brief**)
* Testing the Solution (validation steps, not deployment steps)
* Cleanup (teardown commands/steps - **keep brief**)
* Scenario Analysis (explain correct answer and why other options are wrong)
* Key Learning Points (5–8)
* Related <EXAM> Exam Objectives
* Additional Resources
* Related Labs (0–2, ▶ inline link format)

## Determine exam and lab context

1. Determine `<EXAM>` from workspace path (e.g., `AZ-104`, `AI-102`). If unclear, ask which exam.
2. Use:

   * `<EXAM>` (e.g., `AZ-104`)
   * `<exam-prefix>` lowercase (e.g., `az104`)
3. Confirm exam support constraints by checking `Governance-Lab.md` (if it limits supported exams/domains).

## Cost guardrails (default to cheapest viable)

Use the smallest SKU/tier that meets the scenario intent:

* VM default: `Standard_B2s` (use `Standard_B1s` if clearly sufficient)
* Storage: Standard LRS unless required otherwise
* Prefer lowest tiers for App Service / SQL unless requirements demand more

If a higher-cost resource is required, explain why in README (architecture/analysis), not as a deployment instruction.

## Lab folder structure

Create under:
`<EXAM>/hands-on-labs/<domain>/lab-<topic>/`

### For IaaC labs (Terraform or Bicep)

```
lab-<topic>/
├── README.md
├── terraform/ OR bicep/
│   ├── main.*              # orchestration only
│   ├── variables.* / params
│   ├── outputs.*
│   ├── providers.tf        # terraform only
│   ├── terraform.tfvars    # terraform only (lab subscription id)
│   └── modules/            # when applicable
└── validation/
    └── test-*.ps1          # optional
```

### For Scripted labs (PowerShell/Azure CLI)

```
lab-<topic>/
├── README.md
├── scripts/
│   ├── deploy.ps1 OR deploy.sh
│   ├── config.ps1 OR config.sh   # if needed
│   └── cleanup.ps1 OR cleanup.sh
└── validation/
    └── test-*.ps1          # optional
```

### For Manual labs (Portal/UI)

```
lab-<topic>/
├── README.md
└── screenshots/            # optional, if helpful
    └── step-*.png
```

## Required header block (code files only)

Include a header block at the top of all **code files** (Terraform `.tf`, Bicep `.bicep`, PowerShell `.ps1`).

**Do NOT include header blocks in README.md or other markdown documentation files.**

```
# -------------------------------------------------------------------------
# Program: [filename]
# Description: [what this does]
# Context: <EXAM> Lab - [scenario description]
# Author: Greg Tate
# Date: [YYYY-MM-DD]
# -------------------------------------------------------------------------
```

## Governance compliance

* Follow `Governance-Lab.md` for:

  * Resource group naming
  * Resource naming prefixes
  * Required tags (all required tags on all resources)
  * Allowed regions/locations
  * Terraform/Bicep standards (providers/versions/state conventions, etc.)

## Subscription validation (all modalities)

**All labs must validate deployment to the correct lab subscription before provisioning resources.**

Lab Subscription ID: `e091f6e7-031a-4924-97bb-8c983ca5d21a`

* **Terraform**: Include in `terraform.tfvars` as `lab_subscription_id` variable
* **Bicep**: Validate subscription context in deployment script or parameter file
* **Scripted**: Include subscription validation in deploy script before resource creation

## Terraform-specific rules (when Terraform chosen)

* `terraform.tfvars` must exist and include:

  * `lab_subscription_id = "e091f6e7-031a-4924-97bb-8c983ca5d21a"`
* Use modules when there are **3+ related resources** in a logical grouping.
* Generate “friendly” admin passwords (lab-acceptable):

  * Use `hashicorp/random` (e.g., `random_integer`) and output as `sensitive = true`.

## Bicep-specific rules (when Bicep chosen)

* Use `main.bicep` + `main.bicepparam`.
* Use modules when there are **3+ related resources** in logical grouping.
* Copy shared `bicep.ps1` exactly (non-negotiable).
* Use wrapper actions only: `validate`, `plan`, `apply`, `destroy`, `show`, `list`.
* Include subscription ID validation in deployment wrapper or parameter file:
  * Validate current Azure context targets `e091f6e7-031a-4924-97bb-8c983ca5d21a`

## Common Azure configuration pitfalls (apply when relevant)

Consult the **Azure Resource Configuration Best Practices** section in `Governance-Lab.md` (workspace root) for detailed guidance on:

* Load Balancer outbound SNAT configuration
* Network Interface and backend pool constraints
* AI Agent Service RBAC requirements (control plane + data plane roles)
* Preview API resource failure handling and recovery
* Validation script best practices
* And other deployment patterns to avoid common failures

All configuration standards in `Governance-Lab.md` are mandatory for lab implementations.

## Regional resource availability validation

**Before finalizing deployment configuration**, validate that the selected region has capacity for the required resource types and SKUs.

This validation applies to **all deployment methods** (Terraform, Bicep, and scripted deployments).

### Validation approaches

Use Azure CLI commands to query resource provider capabilities directly:

#### Check VM SKU availability

```powershell
# Check if a specific VM SKU is available in target regions
$vmSize = 'Standard_B2s'
$regions = @('eastus', 'westus3', 'southcentralus', 'northcentralus')

foreach ($region in $regions) {
    $skus = az vm list-skus --location $region --size $vmSize --output json | ConvertFrom-Json
    if ($skus.Count -gt 0) {
        $restrictions = $skus[0].restrictions
        if ($null -eq $restrictions -or $restrictions.Count -eq 0) {
            Write-Host "$region : $vmSize AVAILABLE" -ForegroundColor Green
        } else {
            Write-Host "$region : $vmSize RESTRICTED" -ForegroundColor Yellow
        }
    } else {
        Write-Host "$region : $vmSize NOT AVAILABLE" -ForegroundColor Red
    }
}
```

#### Check Cognitive Services / Azure OpenAI availability

```powershell
# Check Azure OpenAI or Cognitive Services SKU availability
$regions = @('eastus', 'westus3', 'southcentralus', 'northcentralus')
$kind = 'OpenAI'  # or 'CognitiveServices', 'ComputerVision', 'TextAnalytics', etc.

foreach ($region in $regions) {
    $skus = az cognitiveservices account list-skus --location $region --kind $kind 2>&1
    if ($LASTEXITCODE -eq 0) {
        Write-Host "$region : $kind AVAILABLE" -ForegroundColor Green
    } else {
        Write-Host "$region : $kind NOT AVAILABLE" -ForegroundColor Red
    }
}
```

#### Check AI Search availability

```powershell
# Check if AI Search is available (query resource provider)
$regions = @('eastus', 'westus3', 'southcentralus', 'northcentralus')
$provider = az provider show --namespace Microsoft.Search --query "resourceTypes[?resourceType=='searchServices'].locations" -o json | ConvertFrom-Json

foreach ($region in $regions) {
    $normalizedRegion = $region -replace '\s', ''
    $isAvailable = $provider -contains $region -or $provider -contains $normalizedRegion
    if ($isAvailable) {
        Write-Host "$region : AI Search AVAILABLE" -ForegroundColor Green
    } else {
        Write-Host "$region : AI Search NOT AVAILABLE" -ForegroundColor Red
    }
}
```

### When to perform regional validation

* **High-demand resources**: Azure OpenAI, AI Search, GPU-enabled VMs, specialized SKUs
* **Limited availability services**: Preview features, region-specific services
* **Multiple region options**: When Governance-Lab.md allows flexibility and you need to select optimal region
* **Multi-service labs**: When a lab deploys 3+ interdependent Azure services (e.g., AI Services + Cosmos DB + AI Search), validate capacity for **ALL** services in the same region before committing — capacity varies independently per service and per region

### Multi-service regional validation

**CRITICAL**: When a lab requires multiple services that are independently capacity-constrained, validate ALL of them together in the target region. Do not assume that availability of one service guarantees availability of others.

**Services known to have regional capacity constraints (as of 2026-02):**

| Service | Known Constraints |
|---------|-------------------|
| Azure AI Services (kind: `AIServices`) | High-demand regions frequently at capacity (eastus, eastus2) |
| Azure Cosmos DB (serverless) | Intermittent capacity issues in popular regions |
| Azure AI Search (`basic` SKU) | `ResourcesForSkuUnavailable` in some regions (observed in eastus2) |
| GPT model deployments | Model availability is region-specific; not all models in all regions |

**Validation approach**: Use ARM deployment validation (`az deployment group validate`) with a minimal test template for each constrained service before committing to a region. This is non-destructive and faster than actual deployment:

```powershell
# Example: Validate AI Search basic SKU availability in a region
$template = @'
{"$schema":"https://schema.management.azure.com/schemas/2019-04-01/deploymentTemplate.json#",
"contentVersion":"1.0.0.0","parameters":{"loc":{"type":"string"}},
"resources":[{"type":"Microsoft.Search/searchServices","apiVersion":"2024-06-01-preview",
"name":"captest-temp","location":"[parameters('loc')]","sku":{"name":"basic"},
"properties":{"replicaCount":1,"partitionCount":1}}]}
'@
$template | Set-Content "$env:TEMP\search-test.json"
$result = az deployment group validate --resource-group <temp-rg> --template-file "$env:TEMP\search-test.json" --parameters loc=<region> 2>&1
if ($LASTEXITCODE -eq 0) { Write-Host "AVAILABLE" } else { Write-Host "UNAVAILABLE" }
```

**If the default region fails capacity checks**, select an alternative US region (per Location Policy) where ALL required services are available. Document the validated region in the parameter file with a comment explaining why.

### Documentation in README

If regional availability is critical or limited:

* Include a note in **Deployment** section about validated regions
* Example: "This lab has been validated in `eastus` and `westus2`. If deploying to another region, verify Azure OpenAI availability first."

## Validation requirements (must run and capture output)

### For IaaC labs

**Terraform:**

* `Use-AzProfile Lab`
* `Test-Path terraform.tfvars`
* `terraform init`
* `terraform validate`
* `terraform fmt`
* `terraform plan`

**Bicep:**

* `Use-AzProfile Lab`
* `.\bicep.ps1 validate`
* `.\bicep.ps1 plan`

### For Scripted labs

Run and include output:

* `Use-AzProfile Lab`
* Subscription validation: Verify script checks for lab subscription ID `e091f6e7-031a-4924-97bb-8c983ca5d21a`
* PowerShell: `Test-ScriptFileInfo -Path .\scripts\deploy.ps1` (if using script metadata)
* Syntax validation: `Get-Command .\scripts\deploy.ps1 -Syntax`
* Dry-run validation (use `-WhatIf` where supported or echo-mode execution)

**Required subscription check pattern for PowerShell scripts:**

```powershell
function Confirm-LabSubscription {
    $expectedSubscriptionId = 'e091f6e7-031a-4924-97bb-8c983ca5d21a'
    $currentSubscription = (Get-AzContext).Subscription.Id
    
    if ($currentSubscription -ne $expectedSubscriptionId) {
        Write-Error "Not connected to lab subscription. Expected: $expectedSubscriptionId, Current: $currentSubscription"
        exit 1
    }
}
```

## Final response format

1. **Deployment Method Decision** (explain why IaaC/Scripted/Manual was chosen)
2. Lab Summary
3. File List (paths)
4. Validation Results (command output)
5. README Compliance confirmation (all required sections present in correct order)
6. Governance Compliance confirmation (explicitly state you followed Governance-Lab.md)

## Invocation examples

* "Create a hands-on lab for this <EXAM> question: …" (auto-selects method)
* "Create a Terraform hands-on lab for this <EXAM> question: …" (force IaaC)
* "Create a scripted hands-on lab for this <EXAM> question: …" (force scripted)
* "Create a Bicep hands-on lab for this <EXAM> question: …" (force Bicep)

```
