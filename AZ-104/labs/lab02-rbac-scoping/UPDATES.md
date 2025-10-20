# Lab 02 Update Summary - Custom Roles Added

**Date:** October 20, 2025  
**Update:** Added comprehensive custom roles coverage to Lab 02

---

## 📋 What Was Added

### 1. New Exercise 8: Create and Manage Custom Roles

A complete exercise covering:

- **What are Custom Roles?** - When and why to use them
- **Custom Role Structure** - JSON schema and property definitions
- **Creation Methods:**
  - Modify existing built-in roles
  - Create from scratch using PowerShell objects
  - Create from JSON files
  - Create using Azure Portal
  - Create using Azure CLI
- **Management Operations:**
  - Assign custom roles
  - Update custom roles
  - Delete custom roles
  - Export to JSON
- **Best Practices** - 7 key guidelines for custom role management
- **Exam Insights** - 10 exam-focused tips

### 2. Updated Lab Objectives

- Added "Create custom roles with specific permissions" to objectives
- Updated "Skills Measured" to include "Create and manage custom Azure roles"

### 3. New PowerShell Scripts

**`Manage-CustomRoles.ps1`** - Complete custom role management functions:
- `New-CustomRoleFromBuiltIn` - Start from existing role
- `New-CustomRoleFromScratch` - Build from ground up
- `New-CustomRoleFromJson` - Deploy from JSON file
- `Get-CustomRoles` - List all custom roles
- `Update-CustomRole` - Modify existing roles
- `Remove-CustomRole` - Delete with safety checks
- `Export-CustomRole` - Save to JSON

### 4. Example Custom Role Definitions (JSON)

Four real-world scenarios with complete JSON definitions:

1. **VM Operator** - Manage VM power state without configuration access
2. **Storage Blob Operator** - Read/write blobs without key access
3. **Network Security Reader** - Audit network configs (read-only)
4. **Resource Group Admin No Delete** - Full admin except deletions

Each includes:
- Use case description
- Full permissions breakdown
- Deployment instructions
- Important notes

### 5. Custom Roles Documentation

**`custom-roles/README.md`** - Complete guide including:
- Role descriptions and use cases
- Permission breakdowns (what's allowed/denied)
- Quick start deployment guide
- Best practices
- Validation commands
- Cleanup procedures
- Important limitations

### 6. Updated Reflection Questions

Added 3 new comprehensive questions about custom roles:

7. When should you create a custom role? (with 4 scenarios)
8. What's the maximum number of custom roles per tenant?
9. Can custom roles with DataActions be assigned at management group scope?

### 7. Updated References

Added official Microsoft documentation links:
- Azure custom roles
- Tutorial: Create custom role (PowerShell)
- Tutorial: Create custom role (CLI)
- Create custom roles using Portal

---

## 🎯 Key Learning Points Covered

### Custom Role Fundamentals
- 5,000 custom role limit per tenant
- Cannot use root scope (`"/"`)
- Only one management group in AssignableScopes
- Requires `Microsoft.Authorization/roleDefinitions/write` permission

### DataActions Limitations
- Custom roles with DataActions cannot be assigned at management group scope
- Data plane operations are resource-specific
- Must use subscription or resource group scope

### Permission Structure
- `Actions` vs `NotActions` (control plane)
- `DataActions` vs `NotDataActions` (data plane)
- Wildcard (`*`) usage and implications
- Permission inheritance behavior

### Best Practices
- Least privilege principle
- Meaningful naming conventions
- Appropriate scope selection
- Version control and testing
- Regular audits and reviews

---

## 📂 File Structure

```
lab02-rbac-scoping/
├── Lab02_Role-Based-Access-Scoping.md (UPDATED - Added Exercise 8)
├── README.md (UPDATED - Added custom roles objective)
├── powershell/
│   ├── Manage-RBAC.ps1 (existing)
│   ├── Manage-CustomRoles.ps1 (NEW)
│   └── custom-roles/
│       ├── README.md (NEW)
│       ├── vm-operator.json (NEW)
│       ├── storage-blob-operator.json (NEW)
│       ├── network-security-reader.json (NEW)
│       └── rg-admin-no-delete.json (NEW)
├── bicep/
│   └── role-assignment.bicep (existing)
├── terraform/
│   └── role-assignment.tf (existing)
└── cli/
    └── manage-rbac.sh (existing)
```

---

## 🎓 Exam Alignment (AZ-104)

This update directly addresses the AZ-104 exam objective:

**"Manage Azure identities and governance (20-25%)"**
- ✅ Manage built-in Azure roles
- ✅ **Create and manage custom Azure roles** ← NEW COVERAGE
- ✅ Assign roles at different scopes
- ✅ Interpret access assignments

---

## ✅ Testing Recommendations

1. **Deploy a Custom Role:**
   ```powershell
   New-AzRoleDefinition -InputFile ".\custom-roles\vm-operator.json"
   ```

2. **Assign and Test:**
   ```powershell
   New-AzRoleAssignment -SignInName "user@domain.com" -RoleDefinitionName "Virtual Machine Operator" -ResourceGroupName "rg-test"
   ```

3. **Verify Permissions:**
   - User CAN start/restart VMs
   - User CANNOT delete or modify VMs

4. **Cleanup:**
   ```powershell
   Remove-AzRoleAssignment # Remove assignments first
   Remove-AzRoleDefinition -Name "Virtual Machine Operator" -Force
   ```

---

## 📊 Content Metrics

- **Added Content:** ~600 lines in main lab guide
- **New Code Examples:** 15+ PowerShell snippets
- **JSON Definitions:** 4 complete role definitions
- **Exam Tips:** 10 custom role-specific insights
- **Functions:** 7 PowerShell management functions

---

## 🔗 Integration with Existing Labs

- **Lab 01 (Identity Baseline):** Users and groups created can be used for custom role assignments
- **Lab 03 (Policy & Locks):** Custom roles complement governance policies
- **Future Labs:** Custom roles can be used throughout compute, storage, and networking labs

---

## 💡 Usage Tips

1. **Start with Examples:** Use provided JSON files as templates
2. **Test in Dev:** Always test custom roles in non-production first
3. **Document Use Cases:** Maintain a registry of why each custom role exists
4. **Review Regularly:** Audit custom roles quarterly for relevance
5. **Version Control:** Store role definitions in Git for change tracking

---

## 🎯 Next Steps for Students

1. Complete Exercise 8 hands-on
2. Create a custom role for their specific scenario
3. Test the custom role with a test user
4. Answer the new reflection questions
5. Export and save custom role definitions

---

*Update completed: 2025-10-20*
*Lab now covers complete RBAC spectrum: Built-in → Custom → Assignment → Management*
