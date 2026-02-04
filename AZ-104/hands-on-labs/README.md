# AZ-104 Hands-On Labs

Practice environments for AZ-104 exam topics using Terraform and Azure Bicep.

## Folder Structure

| Folder | AZ-104 Domain |
|--------|---------------|
| `identity-governance/` | Manage identities and governance |
| `networking/` | Configure and manage virtual networking |
| `storage/` | Implement and manage storage |
| `compute/` | Deploy and manage Azure compute resources |
| `monitoring/` | Monitor and backup Azure resources |
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

# Deploy
az stack group create --name "<lab-name>" --resource-group "<rg-name>" `
    --template-file main.bicep --action-on-unmanage deleteAll --deny-settings-mode none

# Destroy
az stack group delete --name "<lab-name>" --resource-group "<rg-name>" `
    --action-on-unmanage deleteAll --yes
```

## Cost Management

⚠️ **Always destroy resources immediately after capturing documentation to minimize costs.**
