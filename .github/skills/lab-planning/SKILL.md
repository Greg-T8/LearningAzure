---
name: lab-planning
description: 'Analyze Azure exam scenarios and produce structured lab plans with metadata extraction, architecture design, module breakdown, and file tree generation. Use when planning a new hands-on lab, analyzing an exam question for lab creation, or designing lab architecture for AI-102 or AZ-104.'
user-invokable: false
---

# Lab Planning

Methodology for analyzing exam question scenarios and producing structured, governance-compliant lab plans. This skill produces the blueprint that builder subagents implement — it does NOT generate code.

## When to Use

- Analyzing an exam question to determine lab requirements
- Extracting metadata (exam, domain, topic) from a scenario
- Designing Azure architecture for a lab
- Planning Terraform or Bicep module breakdown
- Generating a file tree for a new lab

## Planning Process

### Step 1: Extract Metadata

From the exam question, identify:

- **Exam**: AI-102 or AZ-104
- **Domain**: Azure domain area (e.g., Networking, Storage, Generative AI, Computer Vision)
- **Topic**: Specific topic slug for folder/resource naming (e.g., `vnet-peering`, `blob-versioning`, `dalle-image-gen`)
- **Correct Answer**: Identify but do NOT reveal in the README scenario section
- **Key Azure Services**: List all services the lab must deploy

### Step 2: Name Resources

Apply governance naming patterns from the `azure-lab-governance` skill:

- **Resource Group**: `<exam>-<domain>-<topic>-<deployment>` (e.g., `az104-networking-vnet-peering-tf`)
- **Resources**: `<type>-<topic>[-instance]` using governance prefix tables
- **Bicep Stack** (if applicable): `stack-<domain>-<topic>` (no exam code)

### Step 3: Select Deployment Method

Evaluate the scenario and choose the best-fit method.

**Priority Order: IaaC > Scripted > Manual (Portal/UI)**

Default to IaaC unless clearly inappropriate.

| Method | Use When |
|--------|----------|
| **IaaC** (Terraform/Bicep) | Deploying Azure resources, architecture/configuration focus, repeatable provisioning |
| **Scripted** (PowerShell/CLI) | Question explicitly requires commands, imperative workflows, operational focus |
| **Manual** (Portal/UI) | Portal navigation is tested, UI workflows are core to the question |

If IaaC is selected, **always ask the user** to choose between Terraform and Bicep. Never auto-select.

### Step 4: Design Architecture

- Describe the target architecture in 2–4 sentences
- Identify resource dependencies and relationships
- Determine if a Mermaid diagram is needed (2+ interconnected resources)
- If needed, draft the Mermaid diagram structure (not full code)

### Step 5: Plan Modules

Apply the module rule: use modules when 2+ related resource types are deployed.

- Group by domain (one concern per module)
- Each module must be self-contained with clear inputs/outputs
- Plan `common_tags` passthrough
- Thin orchestration in root `main.tf` / `main.bicep`

**Anti-pattern to avoid**: consolidating unrelated resource types into a single module.

Example module structure:

```
modules/
├── ai-foundry/      # AI Services, monitoring
├── storage/         # Storage Account + RBAC
├── ai-search/       # AI Search + RBAC
├── cosmos-db/       # Cosmos DB + RBAC
├── key-vault/       # Key Vault
└── orchestration/   # Project, connections, capability hosts
```

### Step 6: Generate File List

Produce the concrete file tree consistent with governance folder structure:

**IaaC (Terraform)**:

```
<EXAM>/hands-on-labs/<domain>/lab-<topic>/
├── README.md
├── terraform/
│   ├── main.tf
│   ├── variables.tf
│   ├── outputs.tf
│   ├── providers.tf
│   ├── terraform.tfvars
│   └── modules/
│       ├── <module-1>/
│       │   ├── main.tf
│       │   ├── variables.tf
│       │   └── outputs.tf
│       └── <module-2>/
└── validation/
    └── <validation-script>.ps1
```

**IaaC (Bicep)**:

```
<EXAM>/hands-on-labs/<domain>/lab-<topic>/
├── README.md
├── bicep/
│   ├── main.bicep
│   ├── main.bicepparam
│   ├── bicepconfig.json
│   ├── bicep.ps1
│   └── modules/
│       ├── <module-1>.bicep
│       └── <module-2>.bicep
└── validation/
    └── <validation-script>.ps1
```

**Scripted**:

```
<EXAM>/hands-on-labs/<domain>/lab-<topic>/
├── README.md
├── scripts/
│   ├── deploy.*
│   ├── config.* (if needed)
│   └── cleanup.*
└── validation/
```

**Manual**:

```
<EXAM>/hands-on-labs/<domain>/lab-<topic>/
├── README.md
└── screenshots/ (optional)
```

## Output Format

Return a structured plan with these exact sections:

```
## Metadata
- Exam: [AI-102 | AZ-104]
- Domain: [domain name]
- Topic: [topic-slug]
- Deployment Method: [Terraform | Bicep | Scripted | Manual | Pending]

## Resource Group
- Name: [full RG name]

## Architecture Summary
[2-4 sentence description]

## Mermaid Diagram
- Required: [Yes | No]
- [Draft structure if Yes]

## Azure Services
- [Service 1] — [SKU/tier]
- [Service 2] — [SKU/tier]

## Module Breakdown
- [module-name]: [resources it manages]
- [module-name]: [resources it manages]

## File List
[Full file tree]

## Capacity-Constrained Services
- [List any services requiring regional capacity validation, or "None"]

## Soft-Delete / Purge Considerations
- [List any services requiring purge management, or "None"]
```

## Rules

- Always use governance-compliant naming and SKUs (see `azure-lab-governance` skill)
- Default region: `eastus` with documented fallback chain
- Never exceed per-lab resource limits
- Flag capacity-constrained services for pre-deployment validation
- Flag soft-delete/purge services for cleanup consideration
