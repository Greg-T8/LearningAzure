# AI-102 Hands-On Labs

Practice environments for AI-102 exam topics using Terraform and Azure Bicep.

## Folder Structure

| Folder | AI-102 Domain |
|--------|---------------|
| `generative-ai/` | Implement generative AI solutions |
| `agentic/` | Implement an agentic solution |
| `computer-vision/` | Implement computer vision solutions |
| `nlp/` | Implement natural language processing solutions |
| `knowledge-mining/` | Implement knowledge mining and information extraction solutions |
| `_shared/` | Reusable modules for Terraform and Bicep |

## Prerequisites

- Azure subscription
- [Azure CLI](https://docs.microsoft.com/en-us/cli/azure/install-azure-cli) with Bicep
- [Terraform CLI](https://developer.hashicorp.com/terraform/downloads)

## Lab Structure

Each lab follows this pattern:

```
lab-name/
├── README.md          # Objectives, exam reference, validation steps
├── terraform/         # Terraform implementation
│   ├── main.tf
│   ├── variables.tf
│   └── outputs.tf
└── bicep/             # Bicep implementation
    ├── main.bicep
    └── main.bicepparam
```

## Lifecycle Commands

### Terraform

```powershell
cd <domain>/<lab>/terraform
terraform init && terraform apply
# ... capture documentation ...
terraform destroy -auto-approve
```

### Bicep with Deployment Stacks

```powershell
cd <domain>/<lab>/bicep
.\bicep.ps1
```

---
