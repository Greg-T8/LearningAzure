<#
# -------------------------------------------------------------------------
# Program: bicep.ps1
# Description: Wrapper script for Azure Deployment Stacks with subscription validation
# Context: AI-102 Lab - Document Intelligence prebuilt invoice model
# Author: Greg Tate
# -------------------------------------------------------------------------
#>

[CmdletBinding()]
param(
    [Parameter(Mandatory = $true, Position = 0)]
    [ValidateSet('apply', 'destroy', 'show', 'list', 'validate', 'plan', 'output')]
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

# Configuration - REPLACE with your lab subscription details
$LabSubscriptionId   = "e091f6e7-031a-4924-97bb-8c983ca5d21a"
$LabSubscriptionName = "sub-gtate-mpn-lab"

$Main = {
    # Main execution logic for Azure Deployment Stack operations

    # Dot-source helper functions
    . $Helpers

    # Validate subscription before any deployment operation
    if ($Action -in @('apply', 'destroy', 'plan')) {
        if (-not (Test-Subscription)) {
            exit 1
        }

        Confirm-SubscriptionContext
    }

    # Auto-derive stack name from parameters file if not provided
    if ([string]::IsNullOrEmpty($script:StackName)) {
        $script:StackName = Get-DerivedStackName -ParametersFile $ParametersFile

        if (-not [string]::IsNullOrEmpty($script:StackName)) {
            Write-Host "📋 Auto-derived stack name: $($script:StackName)" -ForegroundColor Cyan
        }
    }

    # Execute the requested action
    switch ($Action) {
        'apply' { Invoke-ApplyAction }
        'destroy' { Invoke-DestroyAction }
        'show' { Invoke-ShowAction }
        'output' { Invoke-OutputAction }
        'list' { Invoke-ListAction }
        'validate' { Invoke-ValidateAction }
        'plan' { Invoke-PlanAction }
    }
}

$Helpers = {
    # Helper functions for Azure Deployment Stack operations

    function Get-BicepParamValue {
        # Parse parameters file to extract parameter values (supports .json and .bicepparam)

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
        if ($content -match "param\s+$ParamName\s*=\s*['\""]([^'\""]+)['\""]") {
            return $Matches[1]
        }

        return $null
    }

    function Get-DerivedStackName {
        # Derive stack name from parameters file

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

    function Test-Subscription {
        # Pre-flight subscription validation

        try {
            $currentSub = az account show `
                --query "{id:id, name:name, tenantId:tenantId}" `
                -o json 2>$null |
                ConvertFrom-Json
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

        if ($currentSub.id -ne $script:LabSubscriptionId) {
            Write-Host ""
            Write-Host "╔══════════════════════════════════════════════════════════════════╗" -ForegroundColor Red
            Write-Host "║  ⛔ BLOCKED - WRONG AZURE SUBSCRIPTION                            ║" -ForegroundColor Red
            Write-Host "╠══════════════════════════════════════════════════════════════════╣" -ForegroundColor Red
            Write-Host "║  Current:  $($currentSub.name)" -ForegroundColor Yellow
            Write-Host "║  Expected: $script:LabSubscriptionName" -ForegroundColor Green
            Write-Host "╠══════════════════════════════════════════════════════════════════╣" -ForegroundColor Red
            Write-Host "║  To switch subscriptions, run:" -ForegroundColor White
            Write-Host "║  az account set --subscription '$script:LabSubscriptionId'" -ForegroundColor Cyan
            Write-Host "╚══════════════════════════════════════════════════════════════════╝" -ForegroundColor Red
            Write-Host ""
            return $false
        }

        return $true
    }

    function Confirm-SubscriptionContext {
        # Display current subscription for confirmation

        $currentSub = az account show `
            --query "{id:id, name:name}" `
            -o json |
            ConvertFrom-Json

        Write-Host "✅ Subscription verified: $($currentSub.name)" -ForegroundColor Green
    }

    function New-StackCommand {
        # Build az stack sub command

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
            'validate' {
                $command += "az bicep build"
                $command += "--file `"$TemplateFile`""
                $command += "&& az deployment sub validate"
                $command += "--location `"$Location`""
                $command += "--template-file `"$TemplateFile`""

                if (-not [string]::IsNullOrEmpty($ParametersFile)) {
                    $command += "--parameters `"$ParametersFile`""
                }
            }

            'plan' {
                $command += "az deployment sub what-if"
                $command += "--location `"$Location`""
                $command += "--template-file `"$TemplateFile`""

                if (-not [string]::IsNullOrEmpty($ParametersFile)) {
                    $command += "--parameters `"$ParametersFile`""
                }
            }

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

            'show' {
                $command += "az stack sub show"
                $command += "--name `"$StackName`""
            }

            'list' {
                $command += "az stack sub list"
                $command += "-o table"
            }

            'destroy' {
                $command += "az stack sub delete"
                $command += "--name `"$StackName`""
                $command += "--action-on-unmanage deleteAll"
                $command += "--yes"
            }
        }

        # Add any additional arguments passed through
        if ($AdditionalArgs.Count -gt 0) {
            $command += $AdditionalArgs
        }

        return $command -join ' '
    }

    function Invoke-ApplyAction {
        # Apply deployment stack (create or update)

        if ([string]::IsNullOrEmpty($script:StackName)) {
            Write-Host "⛔ ERROR: Could not derive stack name. Provide -StackName or ensure parameters file has domain/topic." -ForegroundColor Red
            exit 1
        }

        Write-Host "`n📦 Applying subscription-scoped stack (creates RG and resources)..." -ForegroundColor Cyan

        $command = New-StackCommand `
            -Action 'apply' `
            -StackName $script:StackName `
            -TemplateFile $TemplateFile `
            -ParametersFile $ParametersFile `
            -Location $Location `
            -AdditionalArgs $AdditionalArgs

        Write-Host "🚀 Running: $command" -ForegroundColor Gray
        Write-Host ""
        Invoke-Expression $command
        exit $LASTEXITCODE
    }

    function Invoke-DestroyAction {
        # Destroy deployment stack and all managed resources

        if ([string]::IsNullOrEmpty($script:StackName)) {
            Write-Host "⛔ ERROR: Could not derive stack name. Provide -StackName or ensure parameters file has domain/topic." -ForegroundColor Red
            exit 1
        }

        Write-Host "`n🗑️  Destroying subscription-scoped stack (removes RG and all resources)..." -ForegroundColor Cyan
        $command = New-StackCommand -Action 'destroy' -StackName $script:StackName
        Write-Host "🚀 Running: $command" -ForegroundColor Gray
        Write-Host ""
        Invoke-Expression $command
        exit $LASTEXITCODE
    }

    function Invoke-ShowAction {
        # Show deployment stack details with state

        if ([string]::IsNullOrEmpty($script:StackName)) {
            Write-Host "⛔ ERROR: -StackName required for 'show'" -ForegroundColor Red
            exit 1
        }

        # Default query includes name, state, and resource count
        $defaultQuery = '{name:name, state:provisioningState, resources:resources.length(@)}'

        # If user provided custom query via AdditionalArgs, use raw show command
        if ($AdditionalArgs -match '--query') {
            $command = New-StackCommand -Action 'show' -StackName $script:StackName
        }
        else {
            # Use enhanced default query
            $command = "az stack sub show --name `"$script:StackName`" --query `"$defaultQuery`" -o table"
        }

        Write-Host "🚀 Running: $command" -ForegroundColor Gray
        Write-Host ""
        Invoke-Expression $command
        exit $LASTEXITCODE
    }

    function Invoke-OutputAction {
        # Retrieve deployment outputs as PSCustomObject

        # Auto-derive stack name if not provided
        if ([string]::IsNullOrEmpty($script:StackName)) {
            $script:StackName = Get-DerivedStackName -ParametersFile $ParametersFile

            if ([string]::IsNullOrEmpty($script:StackName)) {
                Write-Host "⛔ ERROR: Could not derive stack name. Provide -StackName or ensure parameters file has domain/topic." -ForegroundColor Red
                exit 1
            }

            Write-Host "📋 Auto-derived stack name: $($script:StackName)" -ForegroundColor Cyan
        }

        Write-Host "📤 Retrieving deployment outputs from stack: $($script:StackName)" -ForegroundColor Cyan

        # Get stack info to retrieve deploymentId
        $stackJson = az stack sub show --name $script:StackName -o json 2>&1

        if ($LASTEXITCODE -ne 0) {
            Write-Host "⛔ ERROR: Failed to retrieve stack information" -ForegroundColor Red
            exit 1
        }

        $stack = $stackJson | ConvertFrom-Json
        $deploymentId = $stack.deploymentId

        if ([string]::IsNullOrEmpty($deploymentId)) {
            Write-Host "⛔ ERROR: No deploymentId found in stack" -ForegroundColor Red
            exit 1
        }

        # Extract deployment name from the deployment ID
        $deploymentName = $deploymentId.Split('/')[-1]

        Write-Host "🔍 Querying deployment: $deploymentName" -ForegroundColor Gray

        # Query the actual deployment to get outputs with values
        $outputsJson = az deployment sub show `
            --name $deploymentName `
            --query 'properties.outputs' `
            -o json 2>&1

        if ($LASTEXITCODE -ne 0) {
            Write-Host "⛔ ERROR: Failed to retrieve deployment outputs" -ForegroundColor Red
            exit 1
        }

        # Parse JSON and convert to PSCustomObject with direct property access
        $outputs = $outputsJson | ConvertFrom-Json

        # Create a custom object with simplified property access (remove .value wrapper)
        $outputObject = [PSCustomObject]@{}

        foreach ($property in $outputs.PSObject.Properties) {
            $outputObject |
                Add-Member `
                    -MemberType NoteProperty `
                    -Name $property.Name `
                    -Value $property.Value.value
        }

        Write-Host ""
        Write-Output $outputObject
        exit 0
    }

    function Invoke-ListAction {
        # List all deployment stacks

        $command = New-StackCommand -Action 'list'
        Write-Host "🚀 Running: $command" -ForegroundColor Gray
        Write-Host ""
        Invoke-Expression $command
        exit $LASTEXITCODE
    }

    function Invoke-ValidateAction {
        # Validate Bicep template

        if ([string]::IsNullOrEmpty($TemplateFile)) {
            Write-Host "⛔ ERROR: -TemplateFile required for 'validate'" -ForegroundColor Red
            exit 1
        }

        Write-Host "📋 Validating: $TemplateFile" -ForegroundColor Cyan

        $command = New-StackCommand `
            -Action 'validate' `
            -TemplateFile $TemplateFile `
            -ParametersFile $ParametersFile `
            -Location $Location `
            -AdditionalArgs $AdditionalArgs

        Write-Host "🚀 Running: $command" -ForegroundColor Gray
        Write-Host ""
        Invoke-Expression $command
        exit $LASTEXITCODE
    }

    function Invoke-PlanAction {
        # Show what-if analysis for deployment

        if ([string]::IsNullOrEmpty($TemplateFile)) {
            Write-Host "⛔ ERROR: -TemplateFile required for 'plan'" -ForegroundColor Red
            exit 1
        }

        Write-Host "📋 Planning (What-If): $TemplateFile" -ForegroundColor Cyan

        $command = New-StackCommand `
            -Action 'plan' `
            -TemplateFile $TemplateFile `
            -ParametersFile $ParametersFile `
            -Location $Location `
            -AdditionalArgs $AdditionalArgs

        Write-Host "🚀 Running: $command" -ForegroundColor Gray
        Write-Host ""
        Invoke-Expression $command
        exit $LASTEXITCODE
    }
}

try {
    Push-Location -Path $PSScriptRoot
    & $Main
}
finally {
    Pop-Location
}
