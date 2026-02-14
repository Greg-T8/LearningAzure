# Shared Utility Scripts

This directory contains utility scripts that work across all lab deployments (Terraform, Bicep, Azure CLI).

---

## Purge-SoftDeletedResources.ps1

**Purpose**: Purge soft-deleted Azure resources after lab cleanup to enable rapid redeploy cycles.

**When to use**: After destroying lab resources with any deployment tool (Terraform, Bicep, Azure CLI) to remove soft-deleted resources that would otherwise block redeployment for 48 hours to 90 days.

### Supported Resource Types

| Resource Type | Soft-Delete Period | Impact |
|---------------|-------------------|--------|
| Cognitive Services (AI Services) | 48 hours | Name collision on redeploy |
| Key Vault | 7-90 days | Name collision on redeploy |
| API Management | 48 hours | Name collision on redeploy |

### Usage Examples

**Purge all soft-deleted resources**:

```powershell
.\Purge-SoftDeletedResources.ps1 -SubscriptionId "e091f6e7-031a-4924-97bb-8c983ca5d21a"
```

**Purge specific resource types**:

```powershell
# Cognitive Services only (for AI-102 labs)
.\Purge-SoftDeletedResources.ps1 -SubscriptionId "your-sub-id" -ResourceTypes "CognitiveServices"

# Key Vaults only
.\Purge-SoftDeletedResources.ps1 -SubscriptionId "your-sub-id" -ResourceTypes "KeyVault"

# Multiple types
.\Purge-SoftDeletedResources.ps1 -SubscriptionId "your-sub-id" -ResourceTypes "CognitiveServices", "KeyVault"
```

**Filter by resource group pattern**:

```powershell
# Purge only AI-102 lab resources
.\Purge-SoftDeletedResources.ps1 -SubscriptionId "your-sub-id" -ResourceGroupFilter "ai102-*"

# Purge specific lab
.\Purge-SoftDeletedResources.ps1 -SubscriptionId "your-sub-id" -ResourceGroupFilter "ai102-generative-ai-dalle-*"
```

### Parameters

| Parameter | Required | Description | Example |
|-----------|----------|-------------|---------|
| `SubscriptionId` | ✅ Yes | Azure subscription ID | `"e091f6e7-031a-4924-97bb-8c983ca5d21a"` |
| `ResourceTypes` | No | Resource types to purge (default: All) | `@("CognitiveServices", "KeyVault")` |
| `ResourceGroupFilter` | No | Wildcard pattern for resource group names | `"ai102-*"` or `"az104-networking-*"` |

### Typical Lab Workflow

1. **Deploy** resources:

   ```powershell
   # Bicep
   .\bicep.ps1 apply

   # Terraform
   terraform apply
   ```

2. **Test and learn** with the deployed resources

3. **Destroy** resources:

   ```powershell
   # Bicep
   .\bicep.ps1 destroy

   # Terraform
   terraform destroy
   ```

4. **Purge** soft-deleted resources (run from workspace root):

   ```powershell
   .\.assets\shared\scripts\Purge-SoftDeletedResources.ps1 -SubscriptionId "your-sub-id"
   ```

5. **Redeploy** immediately without waiting 48 hours

### Exit Codes

- `0`: Success (resources purged or none found)
- `1`: Failed to set subscription context

### Notes

- Script uses Azure CLI (`az`) commands
- Purge failures are logged as warnings but don't fail the script
- Script handles cases where no soft-deleted resources exist
- Script requires Azure CLI authentication (`az login`)

---

## Future Scripts

Additional utility scripts will be added here as needed for common lab operations.
