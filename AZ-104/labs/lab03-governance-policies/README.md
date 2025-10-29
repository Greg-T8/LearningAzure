# Lab 03 – Governance & Policies

This lab focuses on implementing Azure governance using policies, resource locks, tags, and management groups.

## 📁 Directory Structure

```
lab03-governance-policies/
├── Lab03_Governance-Policies.md    # Main lab guide
├── README.md                       # This file
├── bicep/                          # Bicep templates for policy assignments
├── cli/                            # Azure CLI scripts and policy definitions
├── powershell/                     # PowerShell scripts and policy definitions
├── terraform/                      # Terraform configurations
└── images/                         # Screenshots and diagrams
```

## 🎯 What You'll Learn

- Understand Azure Policy fundamentals (definitions, assignments, effects)
- Create and assign built-in Azure policies
- Create custom policy definitions
- Implement policy initiatives (policy sets)
- Configure policy remediation for non-compliant resources
- Protect resources using resource locks (CanNotDelete, ReadOnly)
- Implement tagging strategies for cost allocation and organization
- Move resources between resource groups and subscriptions
- Configure management groups for hierarchical governance

## 🚀 Quick Start

1. Review the [main lab guide](Lab03_Governance-Policies.md)
2. Complete the Environment Setup section
3. Work through exercises sequentially
4. Use the implementation method that matches your learning goals:
   - **Azure Portal**: Visual, intuitive interface
   - **PowerShell**: Windows automation
   - **Azure CLI**: Cross-platform scripting
   - **Bicep**: Declarative IaC (Azure-native)
   - **Terraform**: Multi-cloud IaC

## 📋 Prerequisites

- Active Azure subscription with appropriate permissions
- Completion of Lab 01 (Identity Baseline) and Lab 02 (RBAC) recommended
- Azure PowerShell or Azure CLI installed (for automation exercises)
- Basic understanding of JSON (for custom policy definitions)

## ⏱️ Estimated Duration

**8–10 hours** (including all exercises and implementation methods)

## 🔗 Related Labs

- **Previous**: [Lab 02 – Role-Based Access & Scoping](../lab02-rbac-scoping/Lab02_Role-Based-Access-Scoping.md)
- **Next**: Lab 04 – Subscription & Cost Management

## 📚 Additional Resources

- [Azure Policy Documentation](https://learn.microsoft.com/en-us/azure/governance/policy/)
- [Azure Resource Manager Overview](https://learn.microsoft.com/en-us/azure/azure-resource-manager/management/overview)
- [Management Groups Documentation](https://learn.microsoft.com/en-us/azure/governance/management-groups/)

---

*Lab created: 2025-10-29*
