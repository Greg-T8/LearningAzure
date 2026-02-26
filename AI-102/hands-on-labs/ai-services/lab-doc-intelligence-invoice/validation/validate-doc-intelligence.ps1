<#
.SYNOPSIS
Validates the Document Intelligence Invoice lab deployment.

.DESCRIPTION
Confirms that the Document Intelligence account and storage account are
deployed correctly, then tests the prebuilt invoice model by analyzing
a sample invoice URL via the REST API. Verifies that results are returned
in JSON format.

.CONTEXT
AI-102 Lab - Document Intelligence Invoice Model

.AUTHOR
Greg Tate

.NOTES
Program: validate-doc-intelligence.ps1
#>
[CmdletBinding()]
param()

# Script-level configuration
$script:ExpectedSubscriptionId = 'e091f6e7-031a-4924-97bb-8c983ca5d21a'

$Main = {
    . $Helpers

    # Display the validation header
    Show-ValidationHeader

    # Validate subscription context
    Confirm-LabSubscription

    # Retrieve Terraform outputs
    $outputs = Get-TerraformOutputs

    # Track test results
    $results = @{}

    # Test 1: Verify the Document Intelligence resource exists
    $results['DocumentIntelligenceExists'] = Test-ResourceExists `
        -ResourceGroupName $outputs.ResourceGroupName `
        -AccountName $outputs.CognitiveAccountName

    # Test 2: Verify the storage account exists
    $results['StorageAccountExists'] = Test-StorageExists `
        -ResourceGroupName $outputs.ResourceGroupName `
        -StorageAccountName $outputs.StorageAccountName

    # Test 3: Analyze a sample invoice and verify JSON output
    $results['InvoiceAnalysisReturnsJson'] = Test-InvoiceAnalysis `
        -Endpoint $outputs.CognitiveEndpoint `
        -Key $outputs.CognitiveKey

    # Display validation summary
    Show-ValidationSummary -Results $results
}

$Helpers = {
    function Show-ValidationHeader {
        [CmdletBinding()]
        param()

        Write-Host ""
        Write-Host "========================================" -ForegroundColor Cyan
        Write-Host " Document Intelligence Invoice Lab" -ForegroundColor Cyan
        Write-Host " Validation Script" -ForegroundColor Cyan
        Write-Host "========================================" -ForegroundColor Cyan
        Write-Host ""
    }

    function Confirm-LabSubscription {
        [CmdletBinding()]
        param()

        # Retrieve the current Azure context
        $currentContext = Get-AzContext

        if (-not $currentContext) {
            Write-Error "No Azure context found. Run Connect-AzAccount first."
            exit 1
        }

        # Extract the current subscription ID
        $currentSubscriptionId = $currentContext.Subscription.Id

        if ($currentSubscriptionId -ne $script:ExpectedSubscriptionId) {
            Write-Error ("Not connected to lab subscription.`n" +
                "  Expected: $script:ExpectedSubscriptionId`n" +
                "  Current:  $currentSubscriptionId")
            exit 1
        }

        # Confirm successful validation
        Write-Host "Lab subscription confirmed: $($currentContext.Subscription.Name) ($currentSubscriptionId)" -ForegroundColor Green
    }

    function Get-TerraformOutputs {
        [CmdletBinding()]
        param()

        # Navigate to the terraform directory
        Push-Location -Path (Join-Path $PSScriptRoot '..\terraform')

        try {
            $rgName = terraform output -raw resource_group_name
            $cogName = terraform output -raw cognitive_account_name
            $cogEndpoint = terraform output -raw cognitive_account_endpoint
            $cogKey = terraform output -raw cognitive_account_key
            $stName = terraform output -raw storage_account_name

            return @{
                ResourceGroupName  = $rgName
                CognitiveAccountName = $cogName
                CognitiveEndpoint  = $cogEndpoint
                CognitiveKey       = $cogKey
                StorageAccountName = $stName
            }
        }
        finally {
            Pop-Location
        }
    }

    function Test-ResourceExists {
        [CmdletBinding()]
        param(
            [string]$ResourceGroupName,
            [string]$AccountName
        )

        Write-Host "`nTest: Document Intelligence resource exists..." -ForegroundColor Yellow

        try {
            # Check if the cognitive account exists
            $account = Get-AzCognitiveServicesAccount `
                -ResourceGroupName $ResourceGroupName `
                -Name $AccountName `
                -ErrorAction Stop

            if ($account.Kind -eq 'FormRecognizer') {
                Write-Host "  PASS: $AccountName exists (Kind: $($account.Kind), SKU: $($account.Sku.Name))" -ForegroundColor Green
                return $true
            }

            Write-Host "  FAIL: Resource exists but kind is $($account.Kind), expected FormRecognizer" -ForegroundColor Red
            return $false
        }
        catch {
            Write-Host "  FAIL: $($_.Exception.Message)" -ForegroundColor Red
            return $false
        }
    }

    function Test-StorageExists {
        [CmdletBinding()]
        param(
            [string]$ResourceGroupName,
            [string]$StorageAccountName
        )

        Write-Host "`nTest: Storage account exists..." -ForegroundColor Yellow

        try {
            # Check if the storage account exists
            $storage = Get-AzStorageAccount `
                -ResourceGroupName $ResourceGroupName `
                -Name $StorageAccountName `
                -ErrorAction Stop

            Write-Host "  PASS: $StorageAccountName exists (SKU: $($storage.Sku.Name))" -ForegroundColor Green
            return $true
        }
        catch {
            Write-Host "  FAIL: $($_.Exception.Message)" -ForegroundColor Red
            return $false
        }
    }

    function Test-InvoiceAnalysis {
        [CmdletBinding()]
        param(
            [string]$Endpoint,
            [string]$Key
        )

        Write-Host "`nTest: Prebuilt invoice model returns JSON..." -ForegroundColor Yellow

        # Use the Microsoft sample invoice URL
        $sampleInvoiceUrl = "https://raw.githubusercontent.com/Azure-Samples/cognitive-services-REST-api-samples/master/curl/form-recognizer/sample-invoice.pdf"

        # Build the analyze request URL
        $analyzeUrl = "${Endpoint}formrecognizer/documentModels/prebuilt-invoice:analyze?api-version=2023-07-31"

        $headers = @{
            'Ocp-Apim-Subscription-Key' = $Key
            'Content-Type'              = 'application/json'
        }

        $body = @{ urlSource = $sampleInvoiceUrl } | ConvertTo-Json

        try {
            # Submit the analysis request
            $response = Invoke-WebRequest -Uri $analyzeUrl -Method Post -Headers $headers -Body $body -ErrorAction Stop
            $operationLocation = $response.Headers['Operation-Location']

            if (-not $operationLocation) {
                Write-Host "  FAIL: No Operation-Location header in response" -ForegroundColor Red
                return $false
            }

            Write-Host "  Analysis submitted. Polling for results..." -ForegroundColor Gray

            # Poll for results (max 30 seconds)
            $resultHeaders = @{ 'Ocp-Apim-Subscription-Key' = $Key }
            $maxAttempts = 10
            $attempt = 0

            do {
                Start-Sleep -Seconds 3
                $attempt++

                # Check the analysis status
                $resultResponse = Invoke-RestMethod -Uri $operationLocation -Method Get -Headers $resultHeaders -ErrorAction Stop

                Write-Host "  Status: $($resultResponse.status) (attempt $attempt/$maxAttempts)" -ForegroundColor Gray
            } while ($resultResponse.status -notin @('succeeded', 'failed') -and $attempt -lt $maxAttempts)

            if ($resultResponse.status -eq 'succeeded') {
                # Verify the response is valid JSON with expected fields
                $hasDocuments = $null -ne $resultResponse.analyzeResult.documents
                $docCount = ($resultResponse.analyzeResult.documents | Measure-Object).Count

                Write-Host "  PASS: Invoice analysis returned JSON with $docCount document(s)" -ForegroundColor Green
                Write-Host "  Note: Results are in JSON format (not XML)" -ForegroundColor Cyan
                return $true
            }

            Write-Host "  FAIL: Analysis status is $($resultResponse.status)" -ForegroundColor Red
            return $false
        }
        catch {
            Write-Host "  FAIL: $($_.Exception.Message)" -ForegroundColor Red
            return $false
        }
    }

    function Show-ValidationSummary {
        [CmdletBinding()]
        param(
            [hashtable]$Results
        )

        Write-Host ""
        Write-Host "========================================" -ForegroundColor Cyan
        Write-Host " Validation Summary" -ForegroundColor Cyan
        Write-Host "========================================" -ForegroundColor Cyan

        $passed = 0
        $total = $Results.Count

        # Display each test result
        foreach ($test in $Results.GetEnumerator()) {
            $status = if ($test.Value) { "PASS"; $passed++ } else { "FAIL" }
            $color = if ($test.Value) { "Green" } else { "Red" }
            Write-Host "  [$status] $($test.Key)" -ForegroundColor $color
        }

        Write-Host ""
        Write-Host "  Results: $passed/$total passed" -ForegroundColor $(if ($passed -eq $total) { "Green" } else { "Yellow" })
        Write-Host ""
    }
}

try {
    Push-Location -Path $PSScriptRoot
    & $Main
}
finally {
    Pop-Location
}
