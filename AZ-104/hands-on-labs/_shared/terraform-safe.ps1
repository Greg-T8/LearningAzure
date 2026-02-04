<#
# -------------------------------------------------------------------------
# Program: terraform-safe.ps1
# Description: Wrapper script that validates Azure subscription before running Terraform
# Context: AZ-104 hands-on labs - Safety wrapper for Terraform commands
# Author: Greg Tate
# -------------------------------------------------------------------------
#>

[CmdletBinding()]
param(
    [Parameter(Position = 0, ValueFromRemainingArguments = $true)]
    [string[]]$TerraformArgs
)

# -------------------------------------------------------------------------
# Configuration - REPLACE with your lab subscription details
# -------------------------------------------------------------------------
$LabSubscriptionId   = "e091f6e7-031a-4924-97bb-8c983ca5d21a"
$LabSubscriptionName = "sub-gtate-mpn-lab"

# -------------------------------------------------------------------------
# Pre-flight subscription validation
# -------------------------------------------------------------------------
function Test-Subscription {
    try {
        $currentSub = az account show --query "{id:id, name:name, tenantId:tenantId}" -o json 2>$null | ConvertFrom-Json
    }
    catch {
        Write-Host "`n⛔ ERROR: Not logged into Azure CLI" -ForegroundColor Red
        Write-Host "   Run: az login`n" -ForegroundColor Cyan
        return $false
    }

    if ($null -eq $currentSub) {
        Write-Host "`n⛔ ERROR: Not logged into Azure CLI" -ForegroundColor Red
        Write-Host "   Run: az login`n" -ForegroundColor Cyan
        return $false
    }

    if ($currentSub.id -ne $LabSubscriptionId) {
        Write-Host ""
        Write-Host "╔══════════════════════════════════════════════════════════════════╗" -ForegroundColor Red
        Write-Host "║  ⛔ BLOCKED - WRONG AZURE SUBSCRIPTION                            ║" -ForegroundColor Red
        Write-Host "╠══════════════════════════════════════════════════════════════════╣" -ForegroundColor Red
        Write-Host "║  Current:  $($currentSub.name)" -ForegroundColor Yellow
        Write-Host "║  Expected: $LabSubscriptionName" -ForegroundColor Green
        Write-Host "╠══════════════════════════════════════════════════════════════════╣" -ForegroundColor Red
        Write-Host "║  To switch subscriptions, run:" -ForegroundColor White
        Write-Host "║  az account set --subscription '$LabSubscriptionId'" -ForegroundColor Cyan
        Write-Host "╚══════════════════════════════════════════════════════════════════╝" -ForegroundColor Red
        Write-Host ""
        return $false
    }

    return $true
}

# -------------------------------------------------------------------------
# Main execution
# -------------------------------------------------------------------------

# Validate subscription before any Terraform operation
if (-not (Test-Subscription)) {
    exit 1
}

# Get current subscription for confirmation display
$currentSub = az account show --query "{id:id, name:name}" -o json | ConvertFrom-Json

Write-Host "✅ Subscription verified: $($currentSub.name)" -ForegroundColor Green
Write-Host "   Running: terraform $($TerraformArgs -join ' ')" -ForegroundColor Gray
Write-Host ""

# Execute Terraform with passed arguments
terraform @TerraformArgs

# Capture and return Terraform's exit code
exit $LASTEXITCODE
