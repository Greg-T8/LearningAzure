# -------------------------------------------------------------------------
# Program: validate-keda-scaling-rule.ps1
# Description: Validate KEDA scaling rule resources for the Container Apps lab deployment
# Context: AZ-104 Lab - Configure KEDA Scaling Rule for Azure Container Apps
# Author: Greg Tate
# Date: 2026-03-05
# -------------------------------------------------------------------------

<#
.SYNOPSIS
Validates resources deployed for the KEDA scaling rule lab.

.DESCRIPTION
Confirms lab subscription context, checks required resources, and validates the
Container App scale rule metadata used for the Service Bus KEDA trigger.

.CONTEXT
AZ-104 Lab - Configure KEDA Scaling Rule for Azure Container Apps

.AUTHOR
Greg Tate

.NOTES
Program: validate-keda-scaling-rule.ps1
#>

[CmdletBinding()]
param()

# Static resource names from the approved lab design.
$ResourceGroupName = 'az104-compute-keda-scaling-rule-bicep'
$ContainerAppName = 'ca-order-processor'
$ContainerAppEnvironmentName = 'cae-lab'
$LogAnalyticsWorkspaceName = 'law-monitoring'
$ServiceBusNamespaceName = 'sbns-orders'
$QueueName = 'my-sample-queue'

$Main = {
    . $Helpers

    # Validate active subscription before running resource checks.
    Confirm-LabSubscription

    # Validate deployment resources and configuration.
    $results = @()
    $results += Test-ResourceGroup
    $results += Test-ServiceBusNamespace
    $results += Test-ServiceBusQueue
    $results += Test-LogAnalyticsWorkspace
    $results += Test-ContainerAppsEnvironment
    $results += Test-ContainerApp
    $results += Test-KedaScaleRule

    # Print summary and fail if any required checks failed.
    Show-ValidationResult -Results $results
}

$Helpers = {
    function Confirm-LabSubscription {
        # Execute shared subscription guardrail script before validation.
        $confirmScriptPath = Join-Path $PSScriptRoot '..\..\..\..\..\.github\skills\azure-lab-governance\scripts\Confirm-LabSubscription.ps1'

        if (-not (Test-Path $confirmScriptPath)) {
            Write-Error "Confirm-LabSubscription script not found: $confirmScriptPath"
            exit 1
        }

        & $confirmScriptPath
    }

    function Test-ResourceGroup {
        # Verify the expected resource group exists.
        Write-Host '[Test 1] Resource Group...' -NoNewline

        $resourceGroup = Get-AzResourceGroup -Name $ResourceGroupName -ErrorAction SilentlyContinue

        if (-not $resourceGroup) {
            Write-Host ' FAIL' -ForegroundColor Red
            return @{ Test = 'Resource Group'; Status = 'FAIL'; Detail = 'Not found' }
        }

        Write-Host ' PASS' -ForegroundColor Green
        return @{ Test = 'Resource Group'; Status = 'PASS'; Detail = "Location: $($resourceGroup.Location)" }
    }

    function Test-ServiceBusNamespace {
        # Verify the Service Bus namespace exists.
        Write-Host '[Test 2] Service Bus Namespace...' -NoNewline

        $namespace = Get-AzServiceBusNamespace -ResourceGroupName $ResourceGroupName -Name $ServiceBusNamespaceName -ErrorAction SilentlyContinue

        if (-not $namespace) {
            Write-Host ' FAIL' -ForegroundColor Red
            return @{ Test = 'Service Bus Namespace'; Status = 'FAIL'; Detail = 'Not found' }
        }

        Write-Host ' PASS' -ForegroundColor Green
        return @{ Test = 'Service Bus Namespace'; Status = 'PASS'; Detail = "Name: $($namespace.Name)" }
    }

    function Test-ServiceBusQueue {
        # Verify the target queue exists in the Service Bus namespace.
        Write-Host '[Test 3] Service Bus Queue...' -NoNewline

        $queue = Get-AzServiceBusQueue -ResourceGroupName $ResourceGroupName -NamespaceName $ServiceBusNamespaceName -Name $QueueName -ErrorAction SilentlyContinue

        if (-not $queue) {
            Write-Host ' FAIL' -ForegroundColor Red
            return @{ Test = 'Service Bus Queue'; Status = 'FAIL'; Detail = 'Not found' }
        }

        Write-Host ' PASS' -ForegroundColor Green
        return @{ Test = 'Service Bus Queue'; Status = 'PASS'; Detail = "Name: $($queue.Name)" }
    }

    function Test-LogAnalyticsWorkspace {
        # Verify the Log Analytics workspace exists.
        Write-Host '[Test 4] Log Analytics Workspace...' -NoNewline

        $workspace = Get-AzOperationalInsightsWorkspace -ResourceGroupName $ResourceGroupName -Name $LogAnalyticsWorkspaceName -ErrorAction SilentlyContinue

        if (-not $workspace) {
            Write-Host ' FAIL' -ForegroundColor Red
            return @{ Test = 'Log Analytics Workspace'; Status = 'FAIL'; Detail = 'Not found' }
        }

        Write-Host ' PASS' -ForegroundColor Green
        return @{ Test = 'Log Analytics Workspace'; Status = 'PASS'; Detail = "Name: $($workspace.Name)" }
    }

    function Test-ContainerAppsEnvironment {
        # Verify the Container Apps environment exists.
        Write-Host '[Test 5] Container Apps Environment...' -NoNewline

        $environment = az containerapp env show --name $ContainerAppEnvironmentName --resource-group $ResourceGroupName --query '{name:name, location:location}' -o json 2>$null

        if (-not $environment) {
            Write-Host ' FAIL' -ForegroundColor Red
            return @{ Test = 'Container Apps Environment'; Status = 'FAIL'; Detail = 'Not found' }
        }

        $environmentObject = $environment | ConvertFrom-Json

        Write-Host ' PASS' -ForegroundColor Green
        return @{ Test = 'Container Apps Environment'; Status = 'PASS'; Detail = "Name: $($environmentObject.name)" }
    }

    function Test-ContainerApp {
        # Verify the Container App exists.
        Write-Host '[Test 6] Container App...' -NoNewline

        $containerApp = az containerapp show --name $ContainerAppName --resource-group $ResourceGroupName --query '{name:name, minReplicas:properties.template.scale.minReplicas, maxReplicas:properties.template.scale.maxReplicas}' -o json 2>$null

        if (-not $containerApp) {
            Write-Host ' FAIL' -ForegroundColor Red
            return @{ Test = 'Container App'; Status = 'FAIL'; Detail = 'Not found' }
        }

        $containerAppObject = $containerApp | ConvertFrom-Json

        Write-Host ' PASS' -ForegroundColor Green
        return @{ Test = 'Container App'; Status = 'PASS'; Detail = "Name: $($containerAppObject.name), Min: $($containerAppObject.minReplicas), Max: $($containerAppObject.maxReplicas)" }
    }

    function Test-KedaScaleRule {
        # Validate scale rule metadata from the Container App template.
        Write-Host '[Test 7] KEDA Scale Rule...' -NoNewline

        $ruleJson = az containerapp show --name $ContainerAppName --resource-group $ResourceGroupName --query "properties.template.scale.rules[?name=='azure-servicebus-queue-rule'] | [0]" -o json 2>$null

        if (-not $ruleJson) {
            Write-Host ' FAIL' -ForegroundColor Red
            return @{ Test = 'KEDA Scale Rule'; Status = 'FAIL'; Detail = 'Scale rule not found' }
        }

        $rule = $ruleJson | ConvertFrom-Json

        if ($rule.custom.type -ne 'azure-servicebus') {
            Write-Host ' FAIL' -ForegroundColor Red
            return @{ Test = 'KEDA Scale Rule'; Status = 'FAIL'; Detail = "Unexpected scaler type: $($rule.custom.type)" }
        }

        if ($rule.custom.metadata.queueName -ne $QueueName -or $rule.custom.metadata.messageCount -ne '15') {
            Write-Host ' FAIL' -ForegroundColor Red
            return @{ Test = 'KEDA Scale Rule'; Status = 'FAIL'; Detail = 'Scale metadata mismatch' }
        }

        Write-Host ' PASS' -ForegroundColor Green
        return @{ Test = 'KEDA Scale Rule'; Status = 'PASS'; Detail = 'azure-servicebus with queueName and messageCount validated' }
    }

    function Show-ValidationResult {
        param(
            [Parameter(Mandatory)]
            [array]$Results
        )

        # Render validation summary and enforce failure on any failed check.
        Write-Host ""
        Write-Host '----------------------------------------'
        Write-Host ' Results Summary'
        Write-Host '----------------------------------------'

        foreach ($result in $Results) {
            $color = switch ($result.Status) {
                'PASS' { 'Green' }
                'WARN' { 'Yellow' }
                'FAIL' { 'Red' }
                default { 'White' }
            }

            Write-Host "  [$($result.Status)] $($result.Test): $($result.Detail)" -ForegroundColor $color
        }

        $failedCount = ($Results | Where-Object { $_.Status -eq 'FAIL' }).Count

        if ($failedCount -gt 0) {
            Write-Error "$failedCount validation check(s) failed."
            exit 1
        }

        Write-Host ""
        Write-Host 'All validation checks passed.' -ForegroundColor Green
    }
}

try {
    Push-Location -Path $PSScriptRoot
    & $Main
}
finally {
    Pop-Location
}
