<#
# -------------------------------------------------------------------------
# Program: bicep-safe.ps1
# Description: Wrapper script for Azure Deployment Stacks with subscription validation
# Context: AZ-104 hands-on labs - Safety wrapper for Bicep deployments
# Author: Greg Tate
# -------------------------------------------------------------------------
#>

[CmdletBinding()]
param(
    [Parameter(Mandatory = $true, Position = 0)]
    [ValidateSet('create', 'delete', 'show', 'list', 'validate', 'delete-rg')]
    [string]$Action,

    [Parameter(Mandatory = $false)]
    [string]$StackName,

    [Parameter(Mandatory = $false)]
    [string]$ResourceGroup,

    [Parameter(Mandatory = $false)]
    [string]$TemplateFile = "main.bicep",

    [Parameter(Mandatory = $false)]
    [string]$ParametersFile = "main.bicepparam",

    [Parameter(Position = 1, ValueFromRemainingArguments = $true)]
    [string[]]$AdditionalArgs
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
# Build az stack command
# -------------------------------------------------------------------------
function Invoke-StackCommand {
    param(
        [string]$Action,
        [string]$StackName,
        [string]$ResourceGroup,
        [string]$TemplateFile,
        [string]$ParametersFile,
        [string[]]$AdditionalArgs
    )

    $command = @()

    switch ($Action) {
        'create' {
            if ([string]::IsNullOrEmpty($StackName) -or [string]::IsNullOrEmpty($ResourceGroup)) {
                Write-Host "⛔ ERROR: --stack-name and --resource-group required for 'create'" -ForegroundColor Red
                exit 1
            }

            # Ensure resource group exists
            Write-Host "📦 Ensuring resource group exists..." -ForegroundColor Cyan
            $rgExists = az group exists --name $ResourceGroup
            if ($rgExists -eq 'false') {
                Write-Host "   Creating resource group: $ResourceGroup" -ForegroundColor Yellow
                az group create --name $ResourceGroup --location eastus | Out-Null
            }

            $command += "az stack group create"
            $command += "--name `"$StackName`""
            $command += "--resource-group `"$ResourceGroup`""
            $command += "--template-file `"$TemplateFile`""

            if (-not [string]::IsNullOrEmpty($ParametersFile)) {
                $command += "--parameters `"$ParametersFile`""
            }

            $command += "--action-on-unmanage deleteAll"
            $command += "--deny-settings-mode none"
            $command += "--yes"
        }

        'delete' {
            if ([string]::IsNullOrEmpty($StackName) -or [string]::IsNullOrEmpty($ResourceGroup)) {
                Write-Host "⛔ ERROR: --stack-name and --resource-group required for 'delete'" -ForegroundColor Red
                exit 1
            }

            $command += "az stack group delete"
            $command += "--name `"$StackName`""
            $command += "--resource-group `"$ResourceGroup`""
            $command += "--action-on-unmanage deleteAll"
            $command += "--yes"
        }

        'delete-rg' {
            if ([string]::IsNullOrEmpty($ResourceGroup)) {
                Write-Host "⛔ ERROR: --resource-group required for 'delete-rg'" -ForegroundColor Red
                exit 1
            }

            $command += "az group delete"
            $command += "--name `"$ResourceGroup`""
            $command += "--yes"
            $command += "--no-wait"
        }

        'show' {
            if ([string]::IsNullOrEmpty($StackName) -or [string]::IsNullOrEmpty($ResourceGroup)) {
                Write-Host "⛔ ERROR: --stack-name and --resource-group required for 'show'" -ForegroundColor Red
                exit 1
            }

            $command += "az stack group show"
            $command += "--name `"$StackName`""
            $command += "--resource-group `"$ResourceGroup`""
        }

        'list' {
            if ([string]::IsNullOrEmpty($ResourceGroup)) {
                Write-Host "⛔ ERROR: --resource-group required for 'list'" -ForegroundColor Red
                exit 1
            }

            $command += "az stack group list"
            $command += "--resource-group `"$ResourceGroup`""
            $command += "-o table"
        }

        'validate' {
            if ([string]::IsNullOrEmpty($TemplateFile)) {
                Write-Host "⛔ ERROR: --template-file required for 'validate'" -ForegroundColor Red
                exit 1
            }

            $command += "az bicep build"
            $command += "--file `"$TemplateFile`""
        }
    }

    # Add any additional arguments passed through
    if ($AdditionalArgs.Count -gt 0), 'delete-rg' {
        $command += $AdditionalArgs
    }

    return $command -join ' '
}

# -------------------------------------------------------------------------
# Main execution
# -------------------------------------------------------------------------

# Validate subscription before any deployment operation
if ($Action -in @('create', 'delete')) {
    if (-not (Test-Subscription)) {
        exit 1
    }

    # Get current subscription for confirmation display
    $currentSub = az account show --query "{id:id, name:name}" -o json | ConvertFrom-Json
    Write-Host "✅ Subscription verified: $($currentSub.name)" -ForegroundColor Green
}

# Build and execute command
$azCommand = Invoke-StackCommand -Action $Action -StackName $StackName -ResourceGroup $ResourceGroup `
                                 -TemplateFile $TemplateFile -ParametersFile $ParametersFile `
                                 -AdditionalArgs $AdditionalArgs

Write-Host "🚀 Running: $azCommand" -ForegroundColor Gray
Write-Host ""

# Execute the command
Invoke-Expression $azCommand

# Capture and return exit code
exit $LASTEXITCODE
