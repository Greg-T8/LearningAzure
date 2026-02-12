# -------------------------------------------------------------------------
# Program: test-content-safety.ps1
# Description: Validate Azure AI Content Safety deployment and API functionality
# Context: AI-102 Lab - Azure AI Content Safety text and image moderation
# Author: Greg Tate
# Date: 2026-02-12
# -------------------------------------------------------------------------

# Validate lab subscription context
function Confirm-LabSubscription {
    $expectedSubscriptionId = 'e091f6e7-031a-4924-97bb-8c983ca5d21a'
    $currentSubscription = (Get-AzContext).Subscription.Id

    if ($currentSubscription -ne $expectedSubscriptionId) {
        Write-Error "Not connected to lab subscription. Expected: $expectedSubscriptionId, Current: $currentSubscription"
        exit 1
    }

    Write-Host "Subscription validated: $currentSubscription" -ForegroundColor Green
}

# Retrieve Terraform outputs
function Get-TerraformOutputs {
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

# Test text moderation API
function Test-TextModeration {
    param(
        [string]$Endpoint,
        [string]$Key
    )

    Write-Host "`n--- Testing Text Moderation ---" -ForegroundColor Cyan

    # Build the request
    $uri = "${Endpoint}/contentsafety/text:analyze?api-version=2024-09-01"

    $headers = @{
        'Ocp-Apim-Subscription-Key' = $Key
        'Content-Type'              = 'application/json'
    }

    $body = @{
        text       = "This is a safe sample text for content safety analysis."
        categories = @("Hate", "SelfHarm", "Sexual", "Violence")
    } | ConvertTo-Json

    try {
        $response = Invoke-RestMethod -Uri $uri -Method Post -Headers $headers -Body $body
        Write-Host "Text moderation API call succeeded" -ForegroundColor Green
        Write-Host "Categories analyzed:"

        # Display category results
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

# Test resource existence
function Test-ResourceExists {
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

# Main validation
Write-Host "=== Azure AI Content Safety Lab Validation ===" -ForegroundColor Magenta
Write-Host ""

# Validate subscription
Confirm-LabSubscription

# Get Terraform outputs
$outputs = Get-TerraformOutputs

# Run tests
$resourceExists = Test-ResourceExists `
    -ResourceGroupName $outputs.ResourceGroupName `
    -ResourceName $outputs.Name

$textModeration = Test-TextModeration `
    -Endpoint $outputs.Endpoint `
    -Key $outputs.Key

# Summary
Write-Host "`n=== Validation Summary ===" -ForegroundColor Magenta
Write-Host "Resource Exists: $(if ($resourceExists) { 'PASS' } else { 'FAIL' })" `
    -ForegroundColor $(if ($resourceExists) { 'Green' } else { 'Red' })
Write-Host "Text Moderation API: $(if ($textModeration) { 'PASS' } else { 'FAIL' })" `
    -ForegroundColor $(if ($textModeration) { 'Green' } else { 'Red' })
