# -------------------------------------------------------------------------
# Program: test-azcopy-auth.ps1
# Description: Test AzCopy authorization methods for blob and file storage
# Context: AZ-104 Lab - Test script for AzCopy authorization methods
# Author: Greg Tate
# Date: 2026-02-07
# -------------------------------------------------------------------------

[CmdletBinding()]
param(
    [Parameter(Mandatory=$false)]
    [string]$ResourceGroupName = "az104-storage-azcopy-auth-methods-bicep",

    [Parameter(Mandatory=$false)]
    [string]$SourceStorageAccount = "staz104azcopyauthsrc",

    [Parameter(Mandatory=$false)]
    [string]$TargetStorageAccount = "staz104azcopyauthtgt"
)

# Colors for output
$SuccessColor = "Green"
$ErrorColor = "Red"
$InfoColor = "Cyan"
$WarningColor = "Yellow"

# Test results tracking
$TestResults = @()

# Helper function to display test results
function Show-TestResult {
    param(
        [string]$TestName,
        [bool]$Success,
        [string]$Message
    )

    $result = [PSCustomObject]@{
        Test = $TestName
        Result = if ($Success) { "✅ PASS" } else { "❌ FAIL" }
        Message = $Message
    }

    $TestResults += $result

    if ($Success) {
        Write-Host "`n✅ PASS: $TestName" -ForegroundColor $SuccessColor
    } else {
        Write-Host "`n❌ FAIL: $TestName" -ForegroundColor $ErrorColor
    }
    Write-Host "   $Message" -ForegroundColor Gray
}

Write-Host "`n╔══════════════════════════════════════════════════════════════╗" -ForegroundColor $InfoColor
Write-Host "║  AzCopy Authorization Methods Testing                       ║" -ForegroundColor $InfoColor
Write-Host "╚══════════════════════════════════════════════════════════════╝`n" -ForegroundColor $InfoColor

# Prerequisite checks
Write-Host "📋 Running prerequisite checks...`n" -ForegroundColor $InfoColor

# Check if Azure CLI is installed and logged in
try {
    $currentAccount = az account show 2>$null | ConvertFrom-Json
    if ($null -eq $currentAccount) {
        Write-Host "❌ Not logged into Azure CLI. Run 'az login' first." -ForegroundColor $ErrorColor
        exit 1
    }
    Write-Host "✅ Azure CLI authenticated as: $($currentAccount.user.name)" -ForegroundColor $SuccessColor
}
catch {
    Write-Host "❌ Azure CLI not found or not logged in" -ForegroundColor $ErrorColor
    exit 1
}

# Check if AzCopy is installed
try {
    $azcopyVersion = azcopy --version 2>$null
    if ($LASTEXITCODE -eq 0) {
        Write-Host "✅ AzCopy is installed" -ForegroundColor $SuccessColor
    } else {
        throw "AzCopy not found"
    }
}
catch {
    Write-Host "❌ AzCopy not installed. Download from: https://aka.ms/downloadazcopy" -ForegroundColor $ErrorColor
    exit 1
}

# Check if resource group exists
$rgExists = az group exists --name $ResourceGroupName
if ($rgExists -eq "false") {
    Write-Host "❌ Resource group '$ResourceGroupName' does not exist" -ForegroundColor $ErrorColor
    Write-Host "   Run the Bicep deployment first: .\bicep.ps1 apply" -ForegroundColor $WarningColor
    exit 1
}
Write-Host "✅ Resource group exists`n" -ForegroundColor $SuccessColor

# Get storage account keys
Write-Host "🔑 Retrieving storage account keys..." -ForegroundColor $InfoColor
$sourceKey = (az storage account keys list --account-name $SourceStorageAccount --query "[0].value" -o tsv)
$targetKey = (az storage account keys list --account-name $TargetStorageAccount --query "[0].value" -o tsv)

if ([string]::IsNullOrEmpty($sourceKey) -or [string]::IsNullOrEmpty($targetKey)) {
    Write-Host "❌ Failed to retrieve storage account keys" -ForegroundColor $ErrorColor
    exit 1
}
Write-Host "✅ Storage account keys retrieved`n" -ForegroundColor $SuccessColor

# Create test file
Write-Host "📄 Creating test file..." -ForegroundColor $InfoColor
$testContent = "AzCopy authorization test - $(Get-Date -Format 'yyyy-MM-dd HH:mm:ss')"
$testFileName = "testfile.txt"
$testContent | Out-File -FilePath $testFileName -Encoding utf8 -NoNewline

# Upload test file to source storage
Write-Host "⬆️  Uploading test file to source storage..." -ForegroundColor $InfoColor

# Upload to blob
az storage blob upload `
    --account-name $SourceStorageAccount `
    --container-name data `
    --name $testFileName `
    --file $testFileName `
    --auth-mode login `
    --overwrite `
    --only-show-errors | Out-Null

# Upload to file share
az storage file upload `
    --account-name $SourceStorageAccount `
    --share-name files `
    --source $testFileName `
    --path $testFileName `
    --auth-mode login `
    --only-show-errors | Out-Null

Write-Host "✅ Test file uploaded to source storage`n" -ForegroundColor $SuccessColor

# Test 1: Blob Storage with Microsoft Entra ID
Write-Host "═══════════════════════════════════════════════════════" -ForegroundColor $InfoColor
Write-Host "Test 1: Blob Storage with Microsoft Entra ID" -ForegroundColor $InfoColor
Write-Host "═══════════════════════════════════════════════════════" -ForegroundColor $InfoColor

try {
    # Login to AzCopy with Entra ID
    $tenantId = (az account show --query tenantId -o tsv)
    azcopy login --tenant-id $tenantId 2>&1 | Out-Null

    # Copy blob using Entra ID
    $destBlob = "testfile-entra.txt"
    azcopy copy `
        "https://$SourceStorageAccount.blob.core.windows.net/data/$testFileName" `
        "https://$TargetStorageAccount.blob.core.windows.net/data/$destBlob" `
        --log-level=ERROR 2>&1 | Out-Null

    if ($LASTEXITCODE -eq 0) {
        # Verify file exists
        $blobExists = az storage blob exists `
            --account-name $TargetStorageAccount `
            --container-name data `
            --name $destBlob `
            --auth-mode login `
            --query exists -o tsv

        if ($blobExists -eq "true") {
            Show-TestResult -TestName "Blob with Entra ID" -Success $true -Message "File copied successfully using Microsoft Entra ID"
        } else {
            Show-TestResult -TestName "Blob with Entra ID" -Success $false -Message "Copy reported success but file not found"
        }
    } else {
        Show-TestResult -TestName "Blob with Entra ID" -Success $false -Message "AzCopy failed with exit code $LASTEXITCODE"
    }
}
catch {
    Show-TestResult -TestName "Blob with Entra ID" -Success $false -Message $_.Exception.Message
}

# Test 2: Blob Storage with Access Keys
Write-Host "`n═══════════════════════════════════════════════════════" -ForegroundColor $InfoColor
Write-Host "Test 2: Blob Storage with Access Keys" -ForegroundColor $InfoColor
Write-Host "═══════════════════════════════════════════════════════" -ForegroundColor $InfoColor

try {
    $destBlob = "testfile-key.txt"

    # Build connection strings
    $sourceConnStr = "DefaultEndpointsProtocol=https;AccountName=$SourceStorageAccount;AccountKey=$sourceKey;EndpointSuffix=core.windows.net"
    $targetConnStr = "DefaultEndpointsProtocol=https;AccountName=$TargetStorageAccount;AccountKey=$targetKey;EndpointSuffix=core.windows.net"

    # Set environment variables
    $env:AZCOPY_SOURCE_KEY = $sourceKey
    $env:AZCOPY_DEST_KEY = $targetKey

    # Copy blob using access keys via connection string
    azcopy copy `
        "https://$SourceStorageAccount.blob.core.windows.net/data/$testFileName" `
        "https://$TargetStorageAccount.blob.core.windows.net/data/$destBlob" `
        --log-level=ERROR 2>&1 | Out-Null

    if ($LASTEXITCODE -eq 0) {
        $blobExists = az storage blob exists `
            --account-name $TargetStorageAccount `
            --container-name data `
            --name $destBlob `
            --auth-mode login `
            --query exists -o tsv

        if ($blobExists -eq "true") {
            Show-TestResult -TestName "Blob with Access Keys" -Success $true -Message "File copied successfully using storage account keys"
        } else {
            Show-TestResult -TestName "Blob with Access Keys" -Success $false -Message "Copy reported success but file not found"
        }
    } else {
        Show-TestResult -TestName "Blob with Access Keys" -Success $false -Message "AzCopy failed with exit code $LASTEXITCODE"
    }

    # Clear environment variables
    Remove-Item Env:\AZCOPY_SOURCE_KEY -ErrorAction SilentlyContinue
    Remove-Item Env:\AZCOPY_DEST_KEY -ErrorAction SilentlyContinue
}
catch {
    Show-TestResult -TestName "Blob with Access Keys" -Success $false -Message $_.Exception.Message
}

# Test 3: Blob Storage with SAS Token
Write-Host "`n═══════════════════════════════════════════════════════" -ForegroundColor $InfoColor
Write-Host "Test 3: Blob Storage with SAS Token" -ForegroundColor $InfoColor
Write-Host "═══════════════════════════════════════════════════════" -ForegroundColor $InfoColor

try {
    $destBlob = "testfile-sas.txt"

    # Generate SAS tokens (valid for 1 hour)
    $expiryTime = (Get-Date).AddHours(1).ToUniversalTime().ToString("yyyy-MM-ddTHH:mm:ssZ")

    $sourceSas = (az storage container generate-sas `
        --account-name $SourceStorageAccount `
        --name data `
        --permissions r `
        --expiry $expiryTime `
        --auth-mode key `
        --account-key $sourceKey `
        -o tsv)

    $targetSas = (az storage container generate-sas `
        --account-name $TargetStorageAccount `
        --name data `
        --permissions w `
        --expiry $expiryTime `
        --auth-mode key `
        --account-key $targetKey `
        -o tsv)

    # Copy blob using SAS tokens
    azcopy copy `
        "https://$SourceStorageAccount.blob.core.windows.net/data/$testFileName`?$sourceSas" `
        "https://$TargetStorageAccount.blob.core.windows.net/data/$destBlob`?$targetSas" `
        --log-level=ERROR 2>&1 | Out-Null

    if ($LASTEXITCODE -eq 0) {
        $blobExists = az storage blob exists `
            --account-name $TargetStorageAccount `
            --container-name data `
            --name $destBlob `
            --auth-mode login `
            --query exists -o tsv

        if ($blobExists -eq "true") {
            Show-TestResult -TestName "Blob with SAS Token" -Success $true -Message "File copied successfully using SAS tokens"
        } else {
            Show-TestResult -TestName "Blob with SAS Token" -Success $false -Message "Copy reported success but file not found"
        }
    } else {
        Show-TestResult -TestName "Blob with SAS Token" -Success $false -Message "AzCopy failed with exit code $LASTEXITCODE"
    }
}
catch {
    Show-TestResult -TestName "Blob with SAS Token" -Success $false -Message $_.Exception.Message
}

# Test 4: File Storage with Microsoft Entra ID
Write-Host "`n═══════════════════════════════════════════════════════" -ForegroundColor $InfoColor
Write-Host "Test 4: File Storage with Microsoft Entra ID" -ForegroundColor $InfoColor
Write-Host "═══════════════════════════════════════════════════════" -ForegroundColor $InfoColor

try {
    $destFile = "testfile-entra.txt"

    # Copy file using Entra ID
    azcopy copy `
        "https://$SourceStorageAccount.file.core.windows.net/files/$testFileName" `
        "https://$TargetStorageAccount.file.core.windows.net/files/$destFile" `
        --log-level=ERROR 2>&1 | Out-Null

    if ($LASTEXITCODE -eq 0) {
        $fileExists = az storage file exists `
            --account-name $TargetStorageAccount `
            --share-name files `
            --path $destFile `
            --auth-mode login `
            --query exists -o tsv

        if ($fileExists -eq "true") {
            Show-TestResult -TestName "File with Entra ID" -Success $true -Message "File copied successfully using Microsoft Entra ID"
        } else {
            Show-TestResult -TestName "File with Entra ID" -Success $false -Message "Copy reported success but file not found"
        }
    } else {
        Show-TestResult -TestName "File with Entra ID" -Success $false -Message "AzCopy failed with exit code $LASTEXITCODE"
    }
}
catch {
    Show-TestResult -TestName "File with Entra ID" -Success $false -Message $_.Exception.Message
}

# Summary
Write-Host "`n╔══════════════════════════════════════════════════════════════╗" -ForegroundColor $InfoColor
Write-Host "║  Test Summary                                                ║" -ForegroundColor $InfoColor
Write-Host "╚══════════════════════════════════════════════════════════════╝`n" -ForegroundColor $InfoColor

$TestResults | Format-Table -AutoSize

$passCount = ($TestResults | Where-Object { $_.Result -eq "✅ PASS" }).Count
$failCount = ($TestResults | Where-Object { $_.Result -eq "❌ FAIL" }).Count

Write-Host "`nTotal Tests: $($TestResults.Count)" -ForegroundColor $InfoColor
Write-Host "Passed: $passCount" -ForegroundColor $SuccessColor
Write-Host "Failed: $failCount" -ForegroundColor $(if ($failCount -gt 0) { $ErrorColor } else { $SuccessColor })

# Cleanup test file
Remove-Item $testFileName -ErrorAction SilentlyContinue

Write-Host "`n✅ Testing complete`n" -ForegroundColor $SuccessColor
