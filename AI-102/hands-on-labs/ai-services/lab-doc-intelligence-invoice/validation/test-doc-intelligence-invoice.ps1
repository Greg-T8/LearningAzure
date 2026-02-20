<#
.SYNOPSIS
Validate Azure AI Document Intelligence deployment and prebuilt invoice model.

.DESCRIPTION
Confirms resource deployment, subscription context, and validates the prebuilt invoice model
via the REST API using a public sample invoice URL. Verifies JSON output format.

.CONTEXT
AI-102 Lab - Document Intelligence prebuilt invoice model

.AUTHOR
Greg Tate

.NOTES
Program: test-doc-intelligence-invoice.ps1
Date: 2026-02-20
#>

[CmdletBinding()]
param()

$script:ExpectedSubscriptionId = 'e091f6e7-031a-4924-97bb-8c983ca5d21a'
$script:SampleInvoiceUrl = 'https://raw.githubusercontent.com/Azure-Samples/cognitive-services-REST-api-samples/master/curl/form-recognizer/sample-invoice.pdf'

$Main = {
    . $Helpers

    Show-ValidationHeader
    Confirm-LabSubscription
    $outputs = Get-TerraformOutputs
    $resourceExists = Test-ResourceExists `
        -ResourceGroupName $outputs.ResourceGroupName `
        -ResourceName $outputs.Name
    $invoiceResult = Test-PrebuiltInvoiceModel `
        -Endpoint $outputs.Endpoint `
        -Key $outputs.Key
    Show-ValidationSummary -ResourceExists $resourceExists -InvoiceAnalysis $invoiceResult
}

$Helpers = {
    function Show-ValidationHeader {
        # Display the main validation header

        Write-Host "=== Azure AI Document Intelligence Lab Validation ===" -ForegroundColor Magenta
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

        $endpoint = terraform output -raw doc_intelligence_endpoint
        $key = terraform output -raw doc_intelligence_primary_key
        $name = terraform output -raw doc_intelligence_name
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
        # Validate Document Intelligence resource exists and display its properties

        param(
            [string]$ResourceGroupName,
            [string]$ResourceName
        )

        Write-Host "`n--- Testing Resource Existence ---" -ForegroundColor Cyan

        try {
            $resource = Get-AzCognitiveServicesAccount `
                -ResourceGroupName $ResourceGroupName `
                -Name $ResourceName

            Write-Host "Document Intelligence resource found: $($resource.AccountName)" -ForegroundColor Green
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

    function Test-PrebuiltInvoiceModel {
        # Analyze a sample invoice with the prebuilt invoice model and verify JSON output

        param(
            [string]$Endpoint,
            [string]$Key
        )

        Write-Host "`n--- Testing Prebuilt Invoice Model ---" -ForegroundColor Cyan

        # Submit the invoice for analysis
        $analyzeUri = "${Endpoint}/formrecognizer/documentModels/prebuilt-invoice:analyze?api-version=2023-07-31"

        $headers = @{
            'Ocp-Apim-Subscription-Key' = $Key
            'Content-Type'              = 'application/json'
        }

        $body = @{
            urlSource = $script:SampleInvoiceUrl
        } | ConvertTo-Json

        try {
            # Submit analysis request
            $response = Invoke-WebRequest -Uri $analyzeUri -Method Post -Headers $headers -Body $body
            $operationLocation = $response.Headers['Operation-Location']

            if (-not $operationLocation) {
                Write-Error "No Operation-Location header returned"
                return $false
            }

            Write-Host "Analysis submitted. Polling for results..." -ForegroundColor Yellow

            # Poll for results
            $maxAttempts = 30
            $attempt = 0
            $result = $null

            while ($attempt -lt $maxAttempts) {
                Start-Sleep -Seconds 2
                $attempt++

                $pollHeaders = @{
                    'Ocp-Apim-Subscription-Key' = $Key
                }

                $pollResponse = Invoke-RestMethod -Uri $operationLocation -Method Get -Headers $pollHeaders

                if ($pollResponse.status -eq 'succeeded') {
                    $result = $pollResponse
                    break
                }
                elseif ($pollResponse.status -eq 'failed') {
                    Write-Error "Analysis failed: $($pollResponse.error.message)"
                    return $false
                }

                Write-Host "  Attempt ${attempt}: Status = $($pollResponse.status)" -ForegroundColor Gray
            }

            # Verify results
            if (-not $result) {
                Write-Error "Analysis timed out after $maxAttempts attempts"
                return $false
            }

            Write-Host "Invoice analysis succeeded!" -ForegroundColor Green
            Write-Host "  Output format: JSON (as expected)" -ForegroundColor Green

            # Display extracted invoice fields
            $invoice = $result.analyzeResult.documents[0].fields

            if ($invoice) {
                Write-Host "`n  Extracted Invoice Fields:" -ForegroundColor Yellow

                # Display vendor name if present
                if ($invoice.VendorName.content) {
                    Write-Host "    Vendor: $($invoice.VendorName.content)"
                }

                # Display invoice total if present
                if ($invoice.InvoiceTotal.content) {
                    Write-Host "    Total: $($invoice.InvoiceTotal.content)"
                }

                # Display invoice date if present
                if ($invoice.InvoiceDate.content) {
                    Write-Host "    Date: $($invoice.InvoiceDate.content)"
                }

                # Display invoice ID if present
                if ($invoice.InvoiceId.content) {
                    Write-Host "    Invoice ID: $($invoice.InvoiceId.content)"
                }
            }

            # Confirm output is JSON, not XML
            Write-Host "`n  Key Finding: Results returned in JSON format" -ForegroundColor Cyan
            Write-Host "  XML format is NOT supported for invoice analysis results" -ForegroundColor Cyan

            return $true
        }
        catch {
            Write-Error "Invoice analysis API call failed: $_"
            return $false
        }
    }

    function Show-ValidationSummary {
        # Display pass/fail status for all validation tests

        param(
            [bool]$ResourceExists,
            [bool]$InvoiceAnalysis
        )

        Write-Host "`n=== Validation Summary ===" -ForegroundColor Magenta
        Write-Host "Resource Exists:      $(if ($ResourceExists) { 'PASS' } else { 'FAIL' })" `
            -ForegroundColor $(if ($ResourceExists) { 'Green' } else { 'Red' })
        Write-Host "Invoice Analysis API: $(if ($InvoiceAnalysis) { 'PASS' } else { 'FAIL' })" `
            -ForegroundColor $(if ($InvoiceAnalysis) { 'Green' } else { 'Red' })
    }
}

try {
    Push-Location -Path $PSScriptRoot
    & $Main
}
finally {
    Pop-Location
}
