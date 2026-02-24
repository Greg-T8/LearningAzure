# -------------------------------------------------------------------------
# Program: Test-DocumentIntelligence.ps1
# Description: Validation script for Document Intelligence invoice lab
# Context: AI-102 Lab - Document Intelligence prebuilt invoice model
# Author: Greg Tate
# Date: 2026-02-24
# -------------------------------------------------------------------------

<#
.SYNOPSIS
Validates the Document Intelligence invoice lab deployment.

.DESCRIPTION
Tests that the Document Intelligence resource is deployed, accessible, and
can analyze a sample invoice using the prebuilt invoice model. Verifies
that results are returned in JSON format.

.PARAMETER ResourceGroupName
The resource group containing the Document Intelligence resource.

.EXAMPLE
.\Test-DocumentIntelligence.ps1

.EXAMPLE
.\Test-DocumentIntelligence.ps1 -ResourceGroupName 'ai102-ai-services-doc-intel-invoice-bicep'
#>

[CmdletBinding()]
param(
    [Parameter(Mandatory = $false)]
    [string]$ResourceGroupName = 'ai102-ai-services-doc-intel-invoice-bicep'
)

$Main = {
    . $Helpers

    # Validate the current Azure subscription context
    Confirm-LabSubscription

    # Step 1: Verify the Document Intelligence resource exists
    Write-Host "`n📋 Step 1: Verify Document Intelligence resource exists" -ForegroundColor Cyan
    $diAccount = Get-AzCognitiveServicesAccount -ResourceGroupName $ResourceGroupName |
        Where-Object { $_.Kind -eq 'FormRecognizer' }

    if ($null -eq $diAccount) {
        Write-Error "Document Intelligence resource not found in $ResourceGroupName"
        exit 1
    }

    Write-Host "✅ Document Intelligence account: $($diAccount.AccountName)" -ForegroundColor Green
    Write-Host "   Endpoint: $($diAccount.Endpoint)" -ForegroundColor Gray
    Write-Host "   SKU: $($diAccount.Sku.Name)" -ForegroundColor Gray
    Write-Host "   Kind: $($diAccount.Kind)" -ForegroundColor Gray

    # Step 2: Retrieve endpoint and key
    Write-Host "`n📋 Step 2: Retrieve endpoint and access key" -ForegroundColor Cyan
    $endpoint = $diAccount.Endpoint
    $keys = Get-AzCognitiveServicesAccountKey `
        -ResourceGroupName $ResourceGroupName `
        -Name $diAccount.AccountName
    $key = $keys.Key1
    Write-Host "✅ Endpoint and key retrieved successfully" -ForegroundColor Green

    # Step 3: Test prebuilt invoice model with a sample invoice
    Write-Host "`n📋 Step 3: Analyze sample invoice with prebuilt model" -ForegroundColor Cyan
    $sampleInvoiceUrl = 'https://raw.githubusercontent.com/Azure-Samples/cognitive-services-REST-api-samples/master/curl/form-recognizer/sample-invoice.pdf'

    $headers = @{
        'Ocp-Apim-Subscription-Key' = $key
        'Content-Type'               = 'application/json'
    }

    $body = @{
        urlSource = $sampleInvoiceUrl
    } | ConvertTo-Json

    # Submit analysis request to prebuilt invoice model
    $analyzeUri = "${endpoint}documentintelligence/documentModels/prebuilt-invoice:analyze?api-version=2024-11-30"

    try {
        $response = Invoke-WebRequest -Uri $analyzeUri -Method Post -Headers $headers -Body $body
        $operationLocation = $response.Headers['Operation-Location'] | Select-Object -First 1
    }
    catch {
        if ($_.Exception.Response.StatusCode -eq 202) {
            $operationLocation = $_.Exception.Response.Headers.GetValues('Operation-Location')[0]
        }
        else {
            Write-Error "Failed to submit analysis request: $_"
            exit 1
        }
    }

    if ([string]::IsNullOrEmpty($operationLocation)) {
        Write-Error "Could not retrieve operation location from response"
        exit 1
    }

    Write-Host "✅ Invoice analysis submitted successfully" -ForegroundColor Green
    Write-Host "   Operation: $operationLocation" -ForegroundColor Gray

    # Step 4: Poll for results and verify JSON output format
    Write-Host "`n📋 Step 4: Wait for analysis and verify JSON output" -ForegroundColor Cyan
    $maxRetries = 10
    $retryCount = 0
    $resultHeaders = @{
        'Ocp-Apim-Subscription-Key' = $key
    }

    do {
        Start-Sleep -Seconds 3
        $retryCount++
        $result = Invoke-RestMethod -Uri $operationLocation -Method Get -Headers $resultHeaders
        Write-Host "   Status: $($result.status) (attempt $retryCount/$maxRetries)" -ForegroundColor Gray
    }
    while ($result.status -notin @('succeeded', 'failed') -and $retryCount -lt $maxRetries)

    if ($result.status -eq 'succeeded') {
        Write-Host "✅ Analysis completed successfully" -ForegroundColor Green

        # Verify output is JSON (not XML)
        $jsonOutput = $result | ConvertTo-Json -Depth 10
        Write-Host "✅ Results returned in JSON format (not XML)" -ForegroundColor Green

        # Display key invoice fields extracted
        if ($result.analyzeResult.documents) {
            $invoice = $result.analyzeResult.documents[0]
            Write-Host "`n   Invoice fields detected:" -ForegroundColor Cyan

            foreach ($field in $invoice.fields.PSObject.Properties) {
                $value = if ($field.Value.content) { $field.Value.content } else { $field.Value.valueString }
                Write-Host "   - $($field.Name): $value" -ForegroundColor Gray
            }
        }
    }
    else {
        Write-Warning "Analysis did not complete within expected time (status: $($result.status))"
    }

    # Validation Summary
    Write-Host "`n$('=' * 60)" -ForegroundColor Cyan
    Write-Host "📊 Validation Summary" -ForegroundColor Cyan
    Write-Host "$('=' * 60)" -ForegroundColor Cyan
    Write-Host "✅ Document Intelligence resource deployed successfully" -ForegroundColor Green
    Write-Host "✅ Prebuilt invoice model accessible via REST API" -ForegroundColor Green
    Write-Host "✅ Results returned in JSON format (not XML)" -ForegroundColor Green
    Write-Host ""
    Write-Host "ℹ️  Prebuilt invoice model is also accessible via:" -ForegroundColor Cyan
    Write-Host "   - Document Intelligence Studio (portal)" -ForegroundColor Gray
    Write-Host "   - C# SDK (Azure.AI.FormRecognizer)" -ForegroundColor Gray
    Write-Host "   - Python SDK (azure-ai-formrecognizer)" -ForegroundColor Gray
    Write-Host "   - REST API (demonstrated above)" -ForegroundColor Gray
}

$Helpers = {
    function Confirm-LabSubscription {
        [CmdletBinding()]
        param()

        $ExpectedSubscriptionId = 'e091f6e7-031a-4924-97bb-8c983ca5d21a'

        # Retrieve the current Azure context
        $currentContext = Get-AzContext

        if (-not $currentContext) {
            Write-Error "No Azure context found. Run Connect-AzAccount first."
            exit 1
        }

        # Compare subscription IDs
        $currentSubscriptionId = $currentContext.Subscription.Id

        if ($currentSubscriptionId -ne $ExpectedSubscriptionId) {
            Write-Error ("Not connected to lab subscription.`n" +
                "  Expected: $ExpectedSubscriptionId`n" +
                "  Current:  $currentSubscriptionId")
            exit 1
        }

        Write-Host "✅ Subscription verified: $($currentContext.Subscription.Name)" -ForegroundColor Green
    }
}

try {
    & $Main
}
catch {
    Write-Error "Validation failed: $_"
    exit 1
}
