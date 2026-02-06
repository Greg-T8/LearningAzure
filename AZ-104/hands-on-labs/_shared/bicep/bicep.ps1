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
    [ValidateSet('apply', 'destroy', 'show', 'list', 'validate', 'plan')]
    [string]$Action,

    [Parameter(Mandatory = $false)]
    [string]$StackName,

    [Parameter(Mandatory = $false)]
    [string]$TemplateFile = "main.bicep",

    [Parameter(Mandatory = $false)]
    [string]$ParametersFile = "main.bicepparam",

    [Parameter(Mandatory = $false)]
    [string]$Location = "eastus",

    [Parameter(Position = 1, ValueFromRemainingArguments = $true)]
    [string[]]$AdditionalArgs
)

# -------------------------------------------------------------------------
# Configuration - REPLACE with your lab subscription details
# -------------------------------------------------------------------------
$LabSubscriptionId   = "e091f6e7-031a-4924-97bb-8c983ca5d21a"
$LabSubscriptionName = "sub-gtate-mpn-lab"

# -------------------------------------------------------------------------
# Parse parameters file to extract parameter values (supports .json and .bicepparam)
# -------------------------------------------------------------------------
function Get-BicepParamValue {
    param(
        [string]$FilePath,
        [string]$ParamName
    )

    if (-not (Test-Path $FilePath)) {
        return $null
    }

    $content = Get-Content $FilePath -Raw

    # JSON format: "paramName": { "value": "actualValue" }
    if ($FilePath -match '\.json$') {
        try {
            $json = $content | ConvertFrom-Json
            if ($json.parameters.$ParamName.value) {
                return $json.parameters.$ParamName.value
            }
        }
        catch {
            return $null
        }
    }

    # Bicepparam format: param paramName = 'value' or param paramName = "value"
    if ($content -match "param\s+$ParamName\s*=\s*['""]([^'""]+)['""]") {
        return $Matches[1]
    }

    return $null
}

# -------------------------------------------------------------------------
# Derive stack name from parameters file
# -------------------------------------------------------------------------
function Get-DerivedStackName {
    param(
        [string]$ParametersFile
    )

    if (-not (Test-Path $ParametersFile)) {
        return $null
    }

    $domain = Get-BicepParamValue -FilePath $ParametersFile -ParamName "domain"
    $topic = Get-BicepParamValue -FilePath $ParametersFile -ParamName "topic"

    if ($domain -and $topic) {
        return "stack-$domain-$topic"
    }

    return $null
}

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
# Build az stack sub command
# -------------------------------------------------------------------------
function Build-StackCommand {
    param(
        [string]$Action,
        [string]$StackName,
        [string]$TemplateFile,
        [string]$ParametersFile,
        [string]$Location,
        [string[]]$AdditionalArgs
    )

    $command = @()

    switch ($Action) {
        'apply' {
            $command += "az stack sub create"
            $command += "--name `"$StackName`""
            $command += "--location `"$Location`""
            $command += "--template-file `"$TemplateFile`""

            if (-not [string]::IsNullOrEmpty($ParametersFile)) {
                $command += "--parameters `"$ParametersFile`""
            }

            $command += "--action-on-unmanage deleteAll"
            $command += "--deny-settings-mode none"
            $command += "--yes"
        }

        'destroy' {
            $command += "az stack sub delete"
            $command += "--name `"$StackName`""
            $command += "--action-on-unmanage deleteAll"
            $command += "--yes"
        }

        'show' {
            $command += "az stack sub show"
            $command += "--name `"$StackName`""
        }

        'list' {
            $command += "az stack sub list"
            $command += "-o table"
        }

        'validate' {
            $command += "az bicep build"
            $command += "--file `"$TemplateFile`""
        }
        'plan' {
            $command += "az deployment sub what-if"
            $command += "--location `"$Location`""
            $command += "--template-file `"$TemplateFile`""
            if (-not [string]::IsNullOrEmpty($ParametersFile)) {
                $command += "--parameters `"$ParametersFile`""
            }
            $command += "--what-if-result-format FullResourcePayloads"
        }
    }

    # Add any additional arguments passed through
    if ($AdditionalArgs.Count -gt 0) {
        $command += $AdditionalArgs
    }

    return $command -join ' '
}

# -------------------------------------------------------------------------
# Main execution
# -------------------------------------------------------------------------

# Validate subscription before any deployment operation
    if ($Action -in @('apply', 'destroy', 'plan')) {
    if (-not (Test-Subscription)) {
        exit 1
    }

    # Get current subscription for confirmation display
    $currentSub = az account show --query "{id:id, name:name}" -o json | ConvertFrom-Json
    Write-Host "✅ Subscription verified: $($currentSub.name)" -ForegroundColor Green
}

# Auto-derive stack name from parameters file if not provided
if ([string]::IsNullOrEmpty($StackName)) {
    $StackName = Get-DerivedStackName -ParametersFile $ParametersFile

    if (-not [string]::IsNullOrEmpty($StackName)) {
        Write-Host "📋 Auto-derived stack name: $StackName" -ForegroundColor Cyan
    }
}

switch ($Action) {
    'apply' {
        if ([string]::IsNullOrEmpty($StackName)) {
            Write-Host "⛔ ERROR: Could not derive stack name. Provide -StackName or ensure parameters file has domain/topic." -ForegroundColor Red
            exit 1
        }

        Write-Host "`n📦 Applying subscription-scoped stack (creates RG and resources)..." -ForegroundColor Cyan
        $command = Build-StackCommand -Action 'apply' -StackName $StackName `
                                      -TemplateFile $TemplateFile -ParametersFile $ParametersFile `
                                      -Location $Location -AdditionalArgs $AdditionalArgs
        Write-Host "🚀 Running: $command" -ForegroundColor Gray
        Write-Host ""
        Invoke-Expression $command
        exit $LASTEXITCODE
    }

    'destroy' {
        if ([string]::IsNullOrEmpty($StackName)) {
            Write-Host "⛔ ERROR: Could not derive stack name. Provide -StackName or ensure parameters file has domain/topic." -ForegroundColor Red
            exit 1
        }

        Write-Host "`n🗑️  Destroying subscription-scoped stack (removes RG and all resources)..." -ForegroundColor Cyan
        $command = Build-StackCommand -Action 'destroy' -StackName $StackName
        Write-Host "🚀 Running: $command" -ForegroundColor Gray
        Write-Host ""
        Invoke-Expression $command
        exit $LASTEXITCODE
    }

    'show' {
        if ([string]::IsNullOrEmpty($StackName)) {
            Write-Host "⛔ ERROR: -StackName required for 'show'" -ForegroundColor Red
            exit 1
        }

        $command = Build-StackCommand -Action 'show' -StackName $StackName
        Write-Host "🚀 Running: $command" -ForegroundColor Gray
        Write-Host ""
        Invoke-Expression $command
        exit $LASTEXITCODE
    }

    'list' {
        $command = Build-StackCommand -Action 'list'
        Write-Host "🚀 Running: $command" -ForegroundColor Gray
        Write-Host ""
        Invoke-Expression $command
        exit $LASTEXITCODE
    }

    'validate' {
        if ([string]::IsNullOrEmpty($TemplateFile)) {
            Write-Host "⛔ ERROR: -TemplateFile required for 'validate'" -ForegroundColor Red
            exit 1
        }

        Write-Host "📋 Validating: $TemplateFile" -ForegroundColor Cyan
        $command = Build-StackCommand -Action 'validate' -TemplateFile $TemplateFile
        Write-Host "🚀 Running: $command" -ForegroundColor Gray
        Write-Host ""
        Invoke-Expression $command
        exit $LASTEXITCODE
    }
    'plan' {
        if ([string]::IsNullOrEmpty($TemplateFile)) {
            Write-Host "⛔ ERROR: -TemplateFile required for 'plan'" -ForegroundColor Red
            exit 1
        }
        Write-Host "📋 Planning (What-If): $TemplateFile" -ForegroundColor Cyan
        $command = Build-StackCommand -Action 'plan' -TemplateFile $TemplateFile `
                                      -ParametersFile $ParametersFile -Location $Location `
                                      -AdditionalArgs $AdditionalArgs
        Write-Host "🚀 Running: $command" -ForegroundColor Gray
        Write-Host ""
        Invoke-Expression $command
        exit $LASTEXITCODE
    }
}
