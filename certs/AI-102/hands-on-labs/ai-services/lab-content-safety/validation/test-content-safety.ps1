<#
.SYNOPSIS
Validate Azure AI Content Safety deployment and API functionality.

.DESCRIPTION
Confirms resource deployment, subscription context, and validates Content Safety API endpoints for text moderation.

.CONTEXT
AI-102 Lab - Azure AI Content Safety text and image moderation

.PARAMETER Text
The text string to analyze for content safety. Defaults to a safe sample text.

.AUTHOR
Greg Tate

.NOTES
Program: test-content-safety.ps1
Date: 2026-02-12
#>

[CmdletBinding()]
param(
    [string]$Text = "This is a safe sample text for content safety analysis."
)

$script:ExpectedSubscriptionId = 'e091f6e7-031a-4924-97bb-8c983ca5d21a'

$Main = {
    . $Helpers

    Show-ValidationHeader
    Confirm-LabSubscription
    $outputs = Get-TerraformOutputs
    $resourceExists = Test-ResourceExists `
        -ResourceGroupName $outputs.ResourceGroupName `
        -ResourceName $outputs.Name
    $textModeration = Test-TextModeration `
        -Endpoint $outputs.Endpoint `
        -Key $outputs.Key `
        -Text $Text
    Show-ValidationSummary -ResourceExists $resourceExists -TextModeration $textModeration
}

$Helpers = {
    function Show-ValidationHeader {
        # Display the main validation header

        Write-Host "=== Azure AI Content Safety Lab Validation ===" -ForegroundColor Magenta
        Write-Host ""
    }

    function Confirm-LabSubscription {
        # Validate that the current Azure context is the expected lab subscription

        $currentSubscription = (Get-AzContext).Subscription.Id

        if ($currentSubscription -ne $script:ExpectedSubscriptionId) {
            Write-Error "Not connected to lab subscription. Expected: $script:ExpectedSubscriptionId, Current: $currentSubscription"
            exit 1
        }

        Write-Host "Subscription validated: $currentSubscription" -ForegroundColor Green
    }

    function Get-TerraformOutputs {
        # Retrieve Terraform outputs from the infrastructure configuration

        $terraformDir = Join-Path $PSScriptRoot '..' 'terraform'

        Push-Location $terraformDir

        $endpoint = terraform output -raw content_safety_endpoint
        $key = terraform output -raw content_safety_primary_key
        $name = terraform output -raw content_safety_name
        $rgName = terraform output -raw resource_group_name

        Pop-Location

        return @{
            Endpoint          = $endpoint
            Key               = $key
            Name              = $name
            ResourceGroupName = $rgName
        }
    }

    function Test-ResourceExists {
        # Validate Content Safety resource exists and display its properties

        param(
            [string]$ResourceGroupName,
            [string]$ResourceName
        )

        Write-Host "`n--- Testing Resource Existence ---" -ForegroundColor Cyan

        try {
            $resource = Get-AzCognitiveServicesAccount `
                -ResourceGroupName $ResourceGroupName `
                -Name $ResourceName

            Write-Host "Content Safety resource found: $($resource.AccountName)" -ForegroundColor Green
            Write-Host "  Kind: $($resource.Kind)"
            Write-Host "  SKU: $($resource.Sku.Name)"
            Write-Host "  Location: $($resource.Location)"
            Write-Host "  Endpoint: $($resource.Endpoint)"
            Write-Host "  Provisioning State: $($resource.ProvisioningState)"

            return $true
        }
        catch {
            Write-Error "Resource validation failed: $_"
            return $false
        }
    }

    function Test-TextModeration {
        # Invoke the Content Safety text moderation API and display category analysis results

        param(
            [string]$Endpoint,
            [string]$Key,
            [string]$Text
        )

        Write-Host "`n--- Testing Text Moderation ---" -ForegroundColor Cyan

        $uri = "${Endpoint}/contentsafety/text:analyze?api-version=2024-09-01"

        $headers = @{
            'Ocp-Apim-Subscription-Key' = $Key
            'Content-Type'              = 'application/json'
        }

        $body = @{
            text       = $Text
            categories = @("Hate", "SelfHarm", "Sexual", "Violence")
        } | ConvertTo-Json

        try {
            $response = Invoke-RestMethod -Uri $uri -Method Post -Headers $headers -Body $body
            Write-Host "Text moderation API call succeeded" -ForegroundColor Green
            Write-Host "Categories analyzed:"

            foreach ($category in $response.categoriesAnalysis) {
                Write-Host "  $($category.category): Severity $($category.severity)" -ForegroundColor Yellow
            }

            return $true
        }
        catch {
            Write-Error "Text moderation API call failed: $_"
            return $false
        }
    }

    function Show-ValidationSummary {
        # Display pass/fail status for all validation tests

        param(
            [bool]$ResourceExists,
            [bool]$TextModeration
        )

        Write-Host "`n=== Validation Summary ===" -ForegroundColor Magenta
        Write-Host "Resource Exists: $(if ($ResourceExists) { 'PASS' } else { 'FAIL' })" `
            -ForegroundColor $(if ($ResourceExists) { 'Green' } else { 'Red' })
        Write-Host "Text Moderation API: $(if ($TextModeration) { 'PASS' } else { 'FAIL' })" `
            -ForegroundColor $(if ($TextModeration) { 'Green' } else { 'Red' })
    }
}

try {
    Push-Location -Path $PSScriptRoot
    & $Main
}
finally {
    Pop-Location
}
