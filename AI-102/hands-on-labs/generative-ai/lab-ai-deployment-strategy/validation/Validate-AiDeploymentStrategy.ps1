<#
.SYNOPSIS
Validates deployed Azure OpenAI resources for the AI deployment strategy lab.

.DESCRIPTION
Confirms lab subscription context, validates key resources, and checks
required model deployments for the Terraform lab environment.

.CONTEXT
AI-102 lab - select an Azure AI deployment strategy (Generative AI)

.AUTHOR
Greg Tate

.NOTES
Program: Validate-AiDeploymentStrategy.ps1
#>
# -------------------------------------------------------------------------
# Program: Validate-AiDeploymentStrategy.ps1
# Description: Validate Azure OpenAI resources and deployments for this lab.
# Context: AI-102 Lab - select an Azure AI deployment strategy (Generative AI)
# Author: Greg Tate
# Date: 2026-02-26
# -------------------------------------------------------------------------

[CmdletBinding()]
param(
    [string]$ResourceGroupName = 'ai102-generative-ai-ai-deployment-strategy-tf'
)

$Main = {
    . $Helpers

    Confirm-LabSubscriptionContext
    $openAiAccount = Get-OpenAiAccount -ResourceGroupName $ResourceGroupName
    Confirm-OpenAiDeployments -OpenAiAccountName $openAiAccount.Name
    Show-ValidationSuccess -OpenAiAccountName $openAiAccount.Name
}

$Helpers = {
    function Confirm-LabSubscriptionContext {
        # Run the shared subscription guardrail before validation checks.
        $repositoryRoot = Resolve-Path -Path (Join-Path -Path $PSScriptRoot -ChildPath '..\..\..\..\..')
        $confirmScriptPath = Join-Path -Path $repositoryRoot -ChildPath '.github\skills\azure-lab-governance\scripts\Confirm-LabSubscription.ps1'

        if (-not (Test-Path -Path $confirmScriptPath)) {
            throw "Required script not found: $confirmScriptPath"
        }

        & $confirmScriptPath
    }

    function Get-OpenAiAccount {
        [CmdletBinding()]
        param(
            [Parameter(Mandatory)]
            [string]$ResourceGroupName
        )

        # Locate the Azure OpenAI account deployed in the resource group.
        $account = Get-AzResource |
            Where-Object {
                $_.ResourceGroupName -eq $ResourceGroupName -and
                $_.ResourceType -eq 'Microsoft.CognitiveServices/accounts'
            } |
            Select-Object -First 1

        if (-not $account) {
            throw "Azure OpenAI account not found in resource group '$ResourceGroupName'."
        }

        Write-Host "Found OpenAI account: $($account.Name)" -ForegroundColor Cyan
        return $account
    }

    function Confirm-OpenAiDeployments {
        [CmdletBinding()]
        param(
            [Parameter(Mandatory)]
            [string]$OpenAiAccountName
        )

        # Validate all required deployments exist in the OpenAI account.
        $requiredDeploymentNames = @(
            'deploy-gpt4o-standard'
            'deploy-gpt4o-provisioned'
            'deploy-gpt4o-batch'
        )

        $deploymentResources = Get-AzResource |
            Where-Object {
                $_.ResourceGroupName -eq $ResourceGroupName -and
                $_.ResourceType -eq 'Microsoft.CognitiveServices/accounts/deployments' -and
                $_.Name -like "$OpenAiAccountName/*"
            }

        $existingDeploymentNames = $deploymentResources |
            ForEach-Object { ($_.Name -split '/')[1] }

        foreach ($deploymentName in $requiredDeploymentNames) {
            if ($deploymentName -notin $existingDeploymentNames) {
                throw "Missing deployment '$deploymentName' in OpenAI account '$OpenAiAccountName'."
            }
            Write-Host "Found deployment: $deploymentName" -ForegroundColor Cyan
        }
    }

    function Show-ValidationSuccess {
        [CmdletBinding()]
        param(
            [Parameter(Mandatory)]
            [string]$OpenAiAccountName
        )

        # Display final success state once all checks pass.
        Write-Host "Validation passed for resource group '$ResourceGroupName'." -ForegroundColor Green
        Write-Host "Validated OpenAI account: $OpenAiAccountName" -ForegroundColor Green
        Write-Host "Validated deployments: deploy-gpt4o-standard, deploy-gpt4o-provisioned, deploy-gpt4o-batch" -ForegroundColor Green
    }
}

try {
    # Execute from the script directory and run orchestration.
    Push-Location -Path $PSScriptRoot
    & $Main
}
finally {
    # Restore caller location after script execution.
    Pop-Location
}
