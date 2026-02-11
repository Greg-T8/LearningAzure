# -------------------------------------------------------------------------
# Program: Test-BlobVersioning.ps1
# Description: Test which blob write operations create new versions
# Context: AZ-104 lab - blob versioning and write operations
# Author: Greg Tate
# -------------------------------------------------------------------------

<#
.SYNOPSIS
    Tests which Azure Blob write operations create new versions.

.DESCRIPTION
    This script tests various blob write operations against a storage account
    with blob versioning enabled to identify which operations create new versions.

.PARAMETER ResourceGroupName
    Name of the resource group containing the storage account.

.PARAMETER StorageAccountName
    Name of the storage account to test.

.PARAMETER ContainerName
    Name of the container to use for testing. Defaults to 'test-container'.

.EXAMPLE
    .\Test-BlobVersioning.ps1 -ResourceGroupName 'rg-lab' -StorageAccountName 'mystorageaccount'
#>

[CmdletBinding()]
param (
    [Parameter(Mandatory = $true)]
    [string]$ResourceGroupName,

    [Parameter(Mandatory = $true)]
    [string]$StorageAccountName,

    [Parameter(Mandatory = $false)]
    [string]$ContainerName = 'test-container'
)

$Main = {
    # Main function that orchestrates all blob versioning tests

    # Dot-source the helper functions
    . $Helpers

    Write-Host "`n========================================" -ForegroundColor Cyan
    Write-Host "Blob Versioning Test Script" -ForegroundColor Cyan
    Write-Host "========================================`n" -ForegroundColor Cyan

    Initialize-TestEnvironment

    $results = @()

    # Test each write operation
    $results += Test-PutBlob
    $results += Test-AppendBlock
    $results += Test-PutBlockList
    $results += Test-CopyBlob
    $results += Test-SetBlobMetadata
    $results += Test-PutBlobFromUrl
    $results += Test-PutPage

    Show-TestResult -Results $results
}

$Helpers = {
    # Helper functions for blob versioning tests

    function Initialize-TestEnvironment {
        # Verify storage account and container exist

        Write-Host "Initializing test environment..." -ForegroundColor Yellow

        # Get storage account
        $script:storageAccount = Get-AzStorageAccount `
            -ResourceGroupName $ResourceGroupName `
            -Name $StorageAccountName `
            -ErrorAction Stop

        # Get storage context
        $script:context = $script:storageAccount.Context

        # Verify container exists
        $container = Get-AzStorageContainer `
            -Name $ContainerName `
            -Context $script:context `
            -ErrorAction SilentlyContinue

        if (-not $container) {
            Write-Host "Container '$ContainerName' not found. Creating..." -ForegroundColor Yellow

            New-AzStorageContainer `
                -Name $ContainerName `
                -Context $script:context `
                -Permission Off | Out-Null
        }

        Write-Host "Environment initialized successfully.`n" -ForegroundColor Green
    }

    function Get-BlobVersionCount {
        # Get the count of versions for a specific blob

        param (
            [string]$BlobName
        )

        $versions = Get-AzStorageBlob `
            -Container $ContainerName `
            -Blob $BlobName `
            -Context $script:context `
            -IncludeVersion `
            -ErrorAction SilentlyContinue

        return ($versions | Measure-Object).Count
    }

    function Test-PutBlob {
        # Test Put Blob operation for version creation

        $testName = "Put Blob"
        $blobName = "test-putblob.txt"

        Write-Host "Testing: $testName..." -ForegroundColor Yellow

        try {
            # Create initial blob
            $content = "Initial content - $(Get-Date)"
            $bytes = [System.Text.Encoding]::UTF8.GetBytes($content)

            Set-AzStorageBlobContent `
                -Container $ContainerName `
                -Blob $blobName `
                -Blob $blobName `
                -Context $script:context `
                -Force | Out-Null

            Start-Sleep -Seconds 2

            $versionsBefore = Get-BlobVersionCount -BlobName $blobName

            # Perform Put Blob operation (overwrite)
            $newContent = "Updated content - $(Get-Date)"

            Set-AzStorageBlobContent `
                -Container $ContainerName `
                -Blob $blobName `
                -Context $script:context `
                -Force | Out-Null

            Start-Sleep -Seconds 2

            $versionsAfter = Get-BlobVersionCount -BlobName $blobName

            $versionCreated = $versionsAfter -gt $versionsBefore

            return [PSCustomObject]@{
                Operation      = $testName
                VersionCreated = $versionCreated
                VersionsBefore = $versionsBefore
                VersionsAfter  = $versionsAfter
                Status         = 'Success'
            }
        }
        catch {
            return [PSCustomObject]@{
                Operation      = $testName
                VersionCreated = $false
                VersionsBefore = 0
                VersionsAfter  = 0
                Status         = "Error: $($_.Exception.Message)"
            }
        }
    }

    function Test-AppendBlock {
        # Test Append Block operation for version creation

        $testName = "Append Block"
        $blobName = "test-appendblock.txt"

        Write-Host "Testing: $testName..." -ForegroundColor Yellow

        try {
            # Create append blob
            $null = Set-AzStorageBlobContent `
                -Container $ContainerName `
                -Blob $blobName `
                -Context $script:context `
                -BlobType Append `
                -Force

            Start-Sleep -Seconds 2

            $versionsBefore = Get-BlobVersionCount -BlobName $blobName

            # Get blob reference and append data
            $cloudBlob = Get-AzStorageBlob `
                -Container $ContainerName `
                -Blob $blobName `
                -Context $script:context

            # Append block
            $appendData = [System.Text.Encoding]::UTF8.GetBytes("Appended data - $(Get-Date)")

            $cloudBlob.ICloudBlob.AppendBlock(
                (New-Object System.IO.MemoryStream(, $appendData)),
                $null
            )

            Start-Sleep -Seconds 2

            $versionsAfter = Get-BlobVersionCount -BlobName $blobName

            $versionCreated = $versionsAfter -gt $versionsBefore

            return [PSCustomObject]@{
                Operation      = $testName
                VersionCreated = $versionCreated
                VersionsBefore = $versionsBefore
                VersionsAfter  = $versionsAfter
                Status         = 'Success'
            }
        }
        catch {
            return [PSCustomObject]@{
                Operation      = $testName
                VersionCreated = $false
                VersionsBefore = 0
                VersionsAfter  = 0
                Status         = "Error: $($_.Exception.Message)"
            }
        }
    }

    function Test-PutBlockList {
        # Test Put Block List operation for version creation

        $testName = "Put Block List"
        $blobName = "test-putblocklist.txt"

        Write-Host "Testing: $testName..." -ForegroundColor Yellow

        try {
            # Create initial blob
            Set-AzStorageBlobContent `
                -Container $ContainerName `
                -Blob $blobName `
                -Context $script:context `
                -Force | Out-Null

            Start-Sleep -Seconds 2

            $versionsBefore = Get-BlobVersionCount -BlobName $blobName

            # Upload using block operations
            $blockId = [Convert]::ToBase64String([Text.Encoding]::UTF8.GetBytes("block1"))
            $content = "Block content - $(Get-Date)"
            $bytes = [System.Text.Encoding]::UTF8.GetBytes($content)

            # Note: PowerShell Az module abstracts this, so using Set-AzStorageBlobContent
            # which internally uses Put Block List for larger files
            $tempFile = New-TemporaryFile

            Set-Content -Path $tempFile.FullName -Value $content

            Set-AzStorageBlobContent `
                -File $tempFile.FullName `
                -Container $ContainerName `
                -Blob $blobName `
                -Context $script:context `
                -Force | Out-Null

            Remove-Item -Path $tempFile.FullName -Force

            Start-Sleep -Seconds 2

            $versionsAfter = Get-BlobVersionCount -BlobName $blobName

            $versionCreated = $versionsAfter -gt $versionsBefore

            return [PSCustomObject]@{
                Operation      = $testName
                VersionCreated = $versionCreated
                VersionsBefore = $versionsBefore
                VersionsAfter  = $versionsAfter
                Status         = 'Success'
            }
        }
        catch {
            return [PSCustomObject]@{
                Operation      = $testName
                VersionCreated = $false
                VersionsBefore = 0
                VersionsAfter  = 0
                Status         = "Error: $($_.Exception.Message)"
            }
        }
    }

    function Test-CopyBlob {
        # Test Copy Blob operation for version creation

        $testName = "Copy Blob"
        $sourceBlobName = "test-source.txt"
        $destBlobName = "test-copyblob.txt"

        Write-Host "Testing: $testName..." -ForegroundColor Yellow

        try {
            # Create source blob
            $content = "Source content - $(Get-Date)"

            Set-AzStorageBlobContent `
                -Container $ContainerName `
                -Blob $sourceBlobName `
                -Context $script:context `
                -Force | Out-Null

            # Create destination blob
            Set-AzStorageBlobContent `
                -Container $ContainerName `
                -Blob $destBlobName `
                -Context $script:context `
                -Force | Out-Null

            Start-Sleep -Seconds 2

            $versionsBefore = Get-BlobVersionCount -BlobName $destBlobName

            # Perform copy operation
            $sourceBlob = Get-AzStorageBlob `
                -Container $ContainerName `
                -Blob $sourceBlobName `
                -Context $script:context

            Start-AzStorageBlobCopy `
                -SrcBlob $sourceBlobName `
                -SrcContainer $ContainerName `
                -DestContainer $ContainerName `
                -DestBlob $destBlobName `
                -Context $script:context `
                -Force | Out-Null

            # Wait for copy to complete
            Start-Sleep -Seconds 3

            $versionsAfter = Get-BlobVersionCount -BlobName $destBlobName

            $versionCreated = $versionsAfter -gt $versionsBefore

            return [PSCustomObject]@{
                Operation      = $testName
                VersionCreated = $versionCreated
                VersionsBefore = $versionsBefore
                VersionsAfter  = $versionsAfter
                Status         = 'Success'
            }
        }
        catch {
            return [PSCustomObject]@{
                Operation      = $testName
                VersionCreated = $false
                VersionsBefore = 0
                VersionsAfter  = 0
                Status         = "Error: $($_.Exception.Message)"
            }
        }
    }

    function Test-SetBlobMetadata {
        # Test Set Blob Metadata operation for version creation

        $testName = "Set Blob Metadata"
        $blobName = "test-metadata.txt"

        Write-Host "Testing: $testName..." -ForegroundColor Yellow

        try {
            # Create blob
            Set-AzStorageBlobContent `
                -Container $ContainerName `
                -Blob $blobName `
                -Context $script:context `
                -Force | Out-Null

            Start-Sleep -Seconds 2

            $versionsBefore = Get-BlobVersionCount -BlobName $blobName

            # Set metadata
            $blob = Get-AzStorageBlob `
                -Container $ContainerName `
                -Blob $blobName `
                -Context $script:context

            $blob.ICloudBlob.Metadata["TestKey"] = "TestValue"
            $blob.ICloudBlob.Metadata["Timestamp"] = (Get-Date).ToString()
            $blob.ICloudBlob.SetMetadata()

            Start-Sleep -Seconds 2

            $versionsAfter = Get-BlobVersionCount -BlobName $blobName

            $versionCreated = $versionsAfter -gt $versionsBefore

            return [PSCustomObject]@{
                Operation      = $testName
                VersionCreated = $versionCreated
                VersionsBefore = $versionsBefore
                VersionsAfter  = $versionsAfter
                Status         = 'Success'
            }
        }
        catch {
            return [PSCustomObject]@{
                Operation      = $testName
                VersionCreated = $false
                VersionsBefore = 0
                VersionsAfter  = 0
                Status         = "Error: $($_.Exception.Message)"
            }
        }
    }

    function Test-PutBlobFromUrl {
        # Test Put Blob From URL operation for version creation

        $testName = "Put Blob From URL"
        $sourceBlobName = "test-source-url.txt"
        $destBlobName = "test-fromiurl.txt"

        Write-Host "Testing: $testName..." -ForegroundColor Yellow

        try {
            # Create source blob
            Set-AzStorageBlobContent `
                -Container $ContainerName `
                -Blob $sourceBlobName `
                -Context $script:context `
                -Force | Out-Null

            # Create destination blob
            Set-AzStorageBlobContent `
                -Container $ContainerName `
                -Blob $destBlobName `
                -Context $script:context `
                -Force | Out-Null

            Start-Sleep -Seconds 2

            $versionsBefore = Get-BlobVersionCount -BlobName $destBlobName

            # Get source blob URL with SAS token
            $startTime = Get-Date
            $expiryTime = $startTime.AddHours(1)

            $sasToken = New-AzStorageBlobSASToken `
                -Container $ContainerName `
                -Blob $sourceBlobName `
                -Permission r `
                -StartTime $startTime `
                -ExpiryTime $expiryTime `
                -Context $script:context

            $sourceUrl = "https://$StorageAccountName.blob.core.windows.net/$ContainerName/$sourceBlobName$sasToken"

            # Copy from URL (similar to Put Blob From URL)
            Start-AzStorageBlobCopy `
                -AbsoluteUri $sourceUrl `
                -DestContainer $ContainerName `
                -DestBlob $destBlobName `
                -Context $script:context `
                -Force | Out-Null

            Start-Sleep -Seconds 3

            $versionsAfter = Get-BlobVersionCount -BlobName $destBlobName

            $versionCreated = $versionsAfter -gt $versionsBefore

            return [PSCustomObject]@{
                Operation      = $testName
                VersionCreated = $versionCreated
                VersionsBefore = $versionsBefore
                VersionsAfter  = $versionsAfter
                Status         = 'Success'
            }
        }
        catch {
            return [PSCustomObject]@{
                Operation      = $testName
                VersionCreated = $false
                VersionsBefore = 0
                VersionsAfter  = 0
                Status         = "Error: $($_.Exception.Message)"
            }
        }
    }

    function Test-PutPage {
        # Test Put Page operation for version creation

        $testName = "Put Page"
        $blobName = "test-putpage.vhd"

        Write-Host "Testing: $testName..." -ForegroundColor Yellow

        try {
            # Create page blob
            $pageBlob = Get-AzStorageBlob `
                -Container $ContainerName `
                -Blob $blobName `
                -Context $script:context `
                -ErrorAction SilentlyContinue

            if (-not $pageBlob) {
                # Create new page blob
                $null = Set-AzStorageBlobContent `
                    -Container $ContainerName `
                    -Blob $blobName `
                    -BlobType Page `
                    -Context $script:context `
                    -Force
            }

            Start-Sleep -Seconds 2

            $versionsBefore = Get-BlobVersionCount -BlobName $blobName

            # Write page
            $pageBlob = Get-AzStorageBlob `
                -Container $ContainerName `
                -Blob $blobName `
                -Context $script:context

            # Create 512-byte aligned data
            $pageData = New-Object byte[] 512

            for ($i = 0; $i -lt 512; $i++) {
                $pageData[$i] = [byte]($i % 256)
            }

            $stream = New-Object System.IO.MemoryStream(, $pageData)

            $pageBlob.ICloudBlob.WritePages($stream, 0)

            Start-Sleep -Seconds 2

            $versionsAfter = Get-BlobVersionCount -BlobName $blobName

            $versionCreated = $versionsAfter -gt $versionsBefore

            return [PSCustomObject]@{
                Operation      = $testName
                VersionCreated = $versionCreated
                VersionsBefore = $versionsBefore
                VersionsAfter  = $versionsAfter
                Status         = 'Success'
            }
        }
        catch {
            return [PSCustomObject]@{
                Operation      = $testName
                VersionCreated = $false
                VersionsBefore = 0
                VersionsAfter  = 0
                Status         = "Error: $($_.Exception.Message)"
            }
        }
    }

    function Show-TestResult {
        # Display test results in a formatted table

        param (
            [Parameter(Mandatory = $true)]
            [array]$Results
        )

        Write-Host "`n========================================" -ForegroundColor Cyan
        Write-Host "Test Results Summary" -ForegroundColor Cyan
        Write-Host "========================================`n" -ForegroundColor Cyan

        $Results |
            Format-Table `
                Operation,
                @{
                    Name       = 'Version Created'
                    Expression = {
                        if ($_.VersionCreated) { '✓ Yes' } else { '✗ No' }
                    }
                },
                @{
                    Name       = 'Versions Before'
                    Expression = { $_.VersionsBefore }
                },
                @{
                    Name       = 'Versions After'
                    Expression = { $_.VersionsAfter }
                },
                Status `
                -AutoSize

        Write-Host "`nOperations that create new versions:" -ForegroundColor Green

        $Results |
            Where-Object VersionCreated -eq $true |
            ForEach-Object {
                Write-Host "  ✓ $($_.Operation)" -ForegroundColor Green
            }

        Write-Host "`nOperations that do NOT create new versions:" -ForegroundColor Yellow

        $Results |
            Where-Object VersionCreated -eq $false |
            ForEach-Object {
                Write-Host "  ✗ $($_.Operation)" -ForegroundColor Yellow
            }

        Write-Host "`n"
    }
}

try {
    Push-Location -Path $PSScriptRoot
    & $Main
}
finally {
    Pop-Location
}
