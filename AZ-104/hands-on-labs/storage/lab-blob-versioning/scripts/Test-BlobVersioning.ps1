# -------------------------------------------------------------------------
# Program: Test-BlobVersioning.ps1
# Description: Test which blob write operations create new versions
# Context: AZ-104 lab - blob versioning and write operations
# Author: Greg Tate
# -------------------------------------------------------------------------
#
# OVERVIEW:
# This script empirically tests all seven blob write operations from the
# AZ-104 exam question to determine which ones create new blob versions
# when versioning is enabled on a storage account.
#
# TESTING METHODOLOGY:
# - Each operation is tested in isolation against a unique test blob
# - Version counts are measured before and after each operation
# - Results definitively show which operations trigger version creation
#
# BLOB VERSIONING BEHAVIOR:
# - When versioning is enabled, Azure automatically preserves previous states
# - Version creation depends on the NATURE of the operation:
#   * FULL REPLACEMENT operations → Create versions (Put Blob, Put Block List, Copy Blob, Put Blob From URL)
#   * IN-PLACE MODIFICATIONS → No versions (Append Block, Put Page)
#   * METADATA-ONLY changes → No versions (Set Blob Metadata)
#
# - Versions are immutable - once created, they cannot be modified
# - Each version has a unique version ID (timestamp-based)
# - Versions consume storage space and incur costs
# - Versions can be restored, deleted, or set as the current version
#
# EXPECTED RESULTS (EXAM ANSWER):
# The four operations that CREATE new versions are:
#   1. Put Blob
#   2. Put Block List
#   3. Copy Blob
#   4. Put Blob From URL
#
# WHY THIS MATTERS:
# - Understanding versioning behavior is critical for data protection strategies
# - Affects storage costs (every version consumes space)
# - Impacts compliance and audit requirements
# - Influences backup and recovery procedures
# - Determines appropriate blob types for different scenarios

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
    #
    # TESTING STRATEGY:
    # Each test follows the same pattern:
    #   1. Create or prepare a blob for testing
    #   2. Count existing versions (baseline)
    #   3. Perform the specific write operation
    #   4. Count versions again
    #   5. Compare counts to determine if a version was created
    #
    # This approach isolates each operation and provides clear evidence
    # of versioning behavior through direct before/after comparison.

    function Initialize-TestEnvironment {
        # Verify storage account exists and prepare test environment
        #
        # WHAT IT DOES:
        #   - Validates the storage account exists and is accessible
        #   - Creates a storage context for subsequent operations
        #   - Ensures the test container exists (creates if missing)
        #
        # WHY IT'S NEEDED:
        #   - Prevents failures due to missing resources
        #   - Establishes connection credentials for all blob operations
        #   - Provides early detection of permission or connectivity issues

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
        #
        # WHAT IT DOES:
        #   - Queries Azure Storage for all versions of a blob (including current)
        #   - Returns the total count of versions
        #
        # HOW VERSIONING WORKS:
        #   - When versioning is enabled, Azure keeps all previous versions
        #   - The current blob is version N, previous states are versions 1 through N-1
        #   - Each version has a unique version ID (timestamp-based)
        #   - Deleting the current blob doesn't delete versions (soft delete)
        #
        # USE IN TESTS:
        #   - Called before and after each operation to detect version creation
        #   - If count increases, the operation created a new version
        #   - If count stays same, the operation modified in-place without versioning

        param (
            [string]$BlobName
        )

        # Note: -Blob and -IncludeVersion cannot be used together
        # Use -Prefix instead and filter for exact match
        $versions = Get-AzStorageBlob `
            -Container $ContainerName `
            -Prefix $BlobName `
            -Context $script:context `
            -IncludeVersion `
            -ErrorAction SilentlyContinue |
            Where-Object { $_.Name -eq $BlobName }

        return ($versions | Measure-Object).Count
    }

    function Test-PutBlob {
        # Test Put Blob operation for version creation
        #
        # OPERATION: Put Blob - Uploads a new blob or replaces an existing blob's entire content
        # USE CASES:
        #   - Uploading files (documents, images, videos) to cloud storage
        #   - Replacing configuration files with new versions
        #   - Updating static website content (HTML, CSS, JS files)
        #   - Storing backup files or archives
        # VERSIONING: Creates a new version because it replaces the ENTIRE blob content
        # WHY: When you overwrite a blob, the previous content needs to be preserved as a version

        $testName = "Put Blob"
        $blobName = "test-putblob.txt"

        Write-Host "Testing: $testName..." -ForegroundColor Yellow

        try {
            # Clean up any existing blob from previous test runs
            Remove-AzStorageBlob -Container $ContainerName -Blob $blobName -Context $script:context -Force -ErrorAction SilentlyContinue | Out-Null
            Start-Sleep -Seconds 1

            # Create initial blob
            $content = "Initial content - $(Get-Date)"
            $tempFile = New-TemporaryFile
            Set-Content -Path $tempFile.FullName -Value $content -NoNewline

            # Upload the initial blob content
            Set-AzStorageBlobContent `
                -File $tempFile.FullName `
                -Container $ContainerName `
                -Blob $blobName `
                -Context $script:context `
                -Force | Out-Null

            Remove-Item -Path $tempFile.FullName -Force

            # Wait for Azure to process the operation
            Start-Sleep -Seconds 2

            # Capture baseline: How many versions exist before the test operation?
            $versionsBefore = Get-BlobVersionCount -BlobName $blobName

            # Perform the actual test: Overwrite the blob with new content
            # This simulates replacing a file in storage (e.g., updating a config file)
            $newContent = "Updated content - $(Get-Date)"
            $tempFile2 = New-TemporaryFile
            Set-Content -Path $tempFile2.FullName -Value $newContent -NoNewline

            Set-AzStorageBlobContent `
                -File $tempFile2.FullName `
                -Container $ContainerName `
                -Blob $blobName `
                -Context $script:context `
                -Force | Out-Null

            Remove-Item -Path $tempFile2.FullName -Force

            # Wait for Azure to process the operation
            Start-Sleep -Seconds 2

            # Measure result: How many versions exist after the operation?
            $versionsAfter = Get-BlobVersionCount -BlobName $blobName

            # Determine if a new version was created
            # If versionsAfter > versionsBefore, then Put Blob created a version
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
        #
        # OPERATION: Append Block - Adds data to the end of an append blob without replacing existing content
        # USE CASES:
        #   - Log file aggregation (application logs, audit trails, event streams)
        #   - Time-series data collection (sensor data, telemetry)
        #   - Sequential data writes where order matters
        #   - Building large files incrementally (batch processing outputs)
        # VERSIONING: Does NOT create a new version
        # WHY: Append operations add to existing content without modifying what's already there
        #      Creating versions for every log entry would be extremely wasteful
        #      Append blobs are optimized for sequential write scenarios

        $testName = "Append Block"
        $blobName = "test-appendblock.txt"

        Write-Host "Testing: $testName..." -ForegroundColor Yellow

        try {
            # Clean up any existing blob from previous test runs
            Remove-AzStorageBlob -Container $ContainerName -Blob $blobName -Context $script:context -Force -ErrorAction SilentlyContinue | Out-Null
            Start-Sleep -Seconds 1

            # Create append blob - a special blob type optimized for sequential writes
            # Append blobs are commonly used for log files and event streams
            $tempFile = New-TemporaryFile
            "Initial append content" | Set-Content -Path $tempFile.FullName -NoNewline

            $null = Set-AzStorageBlobContent `
                -File $tempFile.FullName `
                -Container $ContainerName `
                -Blob $blobName `
                -Context $script:context `
                -BlobType Append `
                -Force

            Remove-Item -Path $tempFile.FullName -Force

            # Wait for Azure to process the blob creation
            Start-Sleep -Seconds 2

            # Capture baseline: Count versions before appending data
            $versionsBefore = Get-BlobVersionCount -BlobName $blobName

            # Get reference to the blob object for low-level operations
            $cloudBlob = Get-AzStorageBlob `
                -Container $ContainerName `
                -Blob $blobName `
                -Context $script:context

            # Perform the actual test: Append new data to the end of the blob
            # This simulates adding a new log entry or event to an existing log file
            # Key difference: This ADDS to the blob without replacing existing content
            $appendData = [System.Text.Encoding]::UTF8.GetBytes("Appended data - $(Get-Date)")

            $cloudBlob.ICloudBlob.AppendBlock(
                (New-Object System.IO.MemoryStream(, $appendData)),
                $null
            ) | Out-Null

            # Wait for Azure to process the append operation
            Start-Sleep -Seconds 2

            # Measure result: Count versions after the append
            $versionsAfter = Get-BlobVersionCount -BlobName $blobName

            # Determine if a new version was created
            # Expected: versionsAfter = versionsBefore (no new version)
            # Why: Append operations don't replace content, so no version is needed
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
        #
        # OPERATION: Put Block List - Commits a list of block IDs to create or update a block blob
        # USE CASES:
        #   - Uploading large files in parallel chunks (multi-part uploads)
        #   - Resumable uploads (can retry failed blocks without re-uploading entire file)
        #   - Optimizing network utilization by uploading blocks concurrently
        #   - Building blobs from multiple sources or processing streams
        # VERSIONING: Creates a new version because it commits a final blob state
        # WHY: When you commit a block list, you're creating/replacing the entire blob
        #      Even though uploaded in parts, the final commit replaces the blob entirely
        #      Azure sees this as a complete blob replacement, triggering versioning

        $testName = "Put Block List"
        $blobName = "test-putblocklist.txt"

        Write-Host "Testing: $testName..." -ForegroundColor Yellow

        try {
            # Clean up any existing blob from previous test runs
            Remove-AzStorageBlob -Container $ContainerName -Blob $blobName -Context $script:context -Force -ErrorAction SilentlyContinue | Out-Null
            Start-Sleep -Seconds 1

            # Create initial blob
            $tempFile = New-TemporaryFile
            "Initial content" | Set-Content -Path $tempFile.FullName -NoNewline

            Set-AzStorageBlobContent `
                -File $tempFile.FullName `
                -Container $ContainerName `
                -Blob $blobName `
                -Context $script:context `
                -Force | Out-Null

            Remove-Item -Path $tempFile.FullName -Force

            Start-Sleep -Seconds 2

            $versionsBefore = Get-BlobVersionCount -BlobName $blobName

            # Upload using block operations - explicitly call Put Block followed by Put Block List
            $blockId1 = [Convert]::ToBase64String([Text.Encoding]::UTF8.GetBytes("block1"))
            $blockId2 = [Convert]::ToBase64String([Text.Encoding]::UTF8.GetBytes("block2"))
            $content1 = "Block content 1 - $(Get-Date)"
            $content2 = "Block content 2 - $(Get-Date)"
            $bytes1 = [System.Text.Encoding]::UTF8.GetBytes($content1)
            $bytes2 = [System.Text.Encoding]::UTF8.GetBytes($content2)

            # Get the block blob object to use Put Block REST operations
            $blockBlob = Get-AzStorageBlob `
                -Container $ContainerName `
                -Blob $blobName `
                -Context $script:context

            # Step 1: Upload blocks individually using Put Block REST operation
            # This stages the blocks but doesn't commit them to the blob yet
            $stream1 = New-Object System.IO.MemoryStream(, $bytes1)
            $blockBlob.ICloudBlob.PutBlock($blockId1, $stream1)
            $stream1.Dispose()

            $stream2 = New-Object System.IO.MemoryStream(, $bytes2)
            $blockBlob.ICloudBlob.PutBlock($blockId2, $stream2)
            $stream2.Dispose()

            # Step 2: Commit the block list using Put Block List REST operation
            # This creates the final blob from the committed blocks
            $blockBlob.ICloudBlob.PutBlockList(@($blockId1, $blockId2))

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
        #
        # OPERATION: Copy Blob - Copies a blob from one location to another (can be same or different storage account)
        # USE CASES:
        #   - Creating backups or duplicates of important blobs
        #   - Replicating data across regions for disaster recovery
        #   - Promoting content (copying from dev to production storage)
        #   - Migrating data between storage accounts or containers
        #   - Creating snapshots for point-in-time consistency
        # VERSIONING: Creates a new version at the DESTINATION blob
        # WHY: The destination blob receives new content (even if identical to source)
        #      This is treated as overwriting the destination, creating a version
        #      The source blob is unchanged and doesn't get a new version

        $testName = "Copy Blob"
        $sourceBlobName = "test-source.txt"
        $destBlobName = "test-copyblob.txt"

        Write-Host "Testing: $testName..." -ForegroundColor Yellow

        try {
            # Clean up any existing blobs from previous test runs
            Remove-AzStorageBlob -Container $ContainerName -Blob $sourceBlobName -Context $script:context -Force -ErrorAction SilentlyContinue | Out-Null
            Remove-AzStorageBlob -Container $ContainerName -Blob $destBlobName -Context $script:context -Force -ErrorAction SilentlyContinue | Out-Null
            Start-Sleep -Seconds 1

            # Create source blob
            $content = "Source content - $(Get-Date)"
            $tempFile1 = New-TemporaryFile
            Set-Content -Path $tempFile1.FullName -Value $content -NoNewline

            Set-AzStorageBlobContent `
                -File $tempFile1.FullName `
                -Container $ContainerName `
                -Blob $sourceBlobName `
                -Context $script:context `
                -Force | Out-Null

            Remove-Item -Path $tempFile1.FullName -Force

            # Create destination blob
            $tempFile2 = New-TemporaryFile
            "Destination content" | Set-Content -Path $tempFile2.FullName -NoNewline

            Set-AzStorageBlobContent `
                -File $tempFile2.FullName `
                -Container $ContainerName `
                -Blob $destBlobName `
                -Context $script:context `
                -Force | Out-Null

            Remove-Item -Path $tempFile2.FullName -Force

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
        #
        # OPERATION: Set Blob Metadata - Updates key-value metadata pairs associated with a blob
        # USE CASES:
        #   - Adding searchable tags to blobs (categories, keywords, classifications)
        #   - Storing processing status (processed, pending, error)
        #   - Recording custom attributes (original filename, content owner, expiry date)
        #   - Tracking metadata without modifying the actual blob content
        #   - Content management and organization systems
        # VERSIONING: Does NOT create a new version
        # WHY: Metadata changes don't modify the actual blob CONTENT
        #      Creating versions for metadata-only changes would create excessive versions
        #      The blob data itself remains unchanged, only metadata properties are updated
        #      Metadata is meant to be lightweight and frequently updated

        $testName = "Set Blob Metadata"
        $blobName = "test-metadata.txt"

        Write-Host "Testing: $testName..." -ForegroundColor Yellow

        try {
            # Clean up any existing blob from previous test runs
            Remove-AzStorageBlob -Container $ContainerName -Blob $blobName -Context $script:context -Force -ErrorAction SilentlyContinue | Out-Null
            Start-Sleep -Seconds 1

            # Create blob
            $tempFile = New-TemporaryFile
            "Initial content" | Set-Content -Path $tempFile.FullName -NoNewline

            Set-AzStorageBlobContent `
                -File $tempFile.FullName `
                -Container $ContainerName `
                -Blob $blobName `
                -Context $script:context `
                -Force | Out-Null

            Remove-Item -Path $tempFile.FullName -Force

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
        #
        # OPERATION: Put Blob From URL - Creates/updates a blob by copying content from a URL in a single operation
        # USE CASES:
        #   - Server-side copy without downloading to client (bandwidth optimization)
        #   - Importing content from external URLs or other Azure storage
        #   - Migrating data between storage accounts efficiently
        #   - Ingesting data from public URLs (CDN, public datasets)
        #   - Synchronizing content from remote sources
        # VERSIONING: Creates a new version because it replaces the blob content
        # WHY: Similar to Put Blob, it creates/replaces the entire blob content
        #      The difference is the source (URL vs. local upload), but the result is the same
        #      The destination blob gets completely overwritten, triggering versioning

        $testName = "Put Blob From URL"
        $sourceBlobName = "test-source-url.txt"
        $destBlobName = "test-fromiurl.txt"

        Write-Host "Testing: $testName..." -ForegroundColor Yellow

        try {
            # Clean up any existing blobs from previous test runs
            Remove-AzStorageBlob -Container $ContainerName -Blob $sourceBlobName -Context $script:context -Force -ErrorAction SilentlyContinue | Out-Null
            Remove-AzStorageBlob -Container $ContainerName -Blob $destBlobName -Context $script:context -Force -ErrorAction SilentlyContinue | Out-Null
            Start-Sleep -Seconds 1

            # Create source blob
            $tempFile1 = New-TemporaryFile
            "Source content" | Set-Content -Path $tempFile1.FullName -NoNewline

            Set-AzStorageBlobContent `
                -File $tempFile1.FullName `
                -Container $ContainerName `
                -Blob $sourceBlobName `
                -Context $script:context `
                -Force | Out-Null

            Remove-Item -Path $tempFile1.FullName -Force

            # Create destination blob
            $tempFile2 = New-TemporaryFile
            "Destination content" | Set-Content -Path $tempFile2.FullName -NoNewline

            Set-AzStorageBlobContent `
                -File $tempFile2.FullName `
                -Container $ContainerName `
                -Blob $destBlobName `
                -Context $script:context `
                -Force | Out-Null

            Remove-Item -Path $tempFile2.FullName -Force

            Start-Sleep -Seconds 2

            $versionsBefore = Get-BlobVersionCount -BlobName $destBlobName

            # Get source blob URL with SAS token
            # Set start time 15 minutes in past to account for clock skew between client and Azure servers
            $startTime = (Get-Date).AddMinutes(-15)
            $expiryTime = (Get-Date).AddHours(1)

            $sasToken = New-AzStorageBlobSASToken `
                -Container $ContainerName `
                -Blob $sourceBlobName `
                -Permission r `
                -StartTime $startTime `
                -ExpiryTime $expiryTime `
                -Context $script:context

            $sourceUrl = "https://$($StorageAccountName).blob.core.windows.net/$($ContainerName)/$($sourceBlobName)?$($sasToken)"

            # Perform Put Blob From URL operation - server-side copy from URL without client bandwidth
            # This REST operation creates/replaces the destination blob with content from a URL
            $destBlob = Get-AzStorageBlob `
                -Container $ContainerName `
                -Blob $destBlobName `
                -Context $script:context

            # Call the REST operation equivalent through the cloud blob object
            $destBlob.ICloudBlob.StartCopy($sourceUrl) | Out-Null

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
        #
        # OPERATION: Put Page - Writes or updates a range of 512-byte pages within a page blob
        # USE CASES:
        #   - Virtual machine disk storage (VHDs and VHDX files)
        #   - Database files requiring random access patterns
        #   - Memory dumps and crash dumps
        #   - Sparse file storage where only specific ranges need updates
        #   - Applications requiring random read/write to large files
        # VERSIONING: Does NOT create a new version for updates to existing pages
        # WHY: Page blobs are designed for random-access, in-place updates
        #      Creating versions for every 512-byte page write would be extremely inefficient
        #      VM disks would generate millions of versions with every OS operation
        #      However, CREATING a new page blob DOES create a version (initial creation)

        $testName = "Put Page"
        $blobName = "test-putpage.vhd"

        Write-Host "Testing: $testName..." -ForegroundColor Yellow

        try {
            # Check if page blob already exists from a previous test run
            # Page blobs must be created with a specific size (512-byte aligned)
            $pageBlob = Get-AzStorageBlob `
                -Container $ContainerName `
                -Blob $blobName `
                -Context $script:context `
                -ErrorAction SilentlyContinue

            if (-not $pageBlob) {
                # Create new page blob - the .vhd extension hints at its primary use case
                # Page blobs are the underlying storage for Azure VM disks
                $tempFile = New-TemporaryFile
                # Page blobs require 512-byte alignment - create a 512-byte file
                $initialData = New-Object byte[] 512
                [System.IO.File]::WriteAllBytes($tempFile.FullName, $initialData)

                $null = Set-AzStorageBlobContent `
                    -File $tempFile.FullName `
                    -Container $ContainerName `
                    -Blob $blobName `
                    -BlobType Page `
                    -Context $script:context `
                    -Force

                Remove-Item -Path $tempFile.FullName -Force
            }

            # Wait for Azure to process the blob creation
            Start-Sleep -Seconds 2

            # Capture baseline: Count versions before writing pages
            $versionsBefore = Get-BlobVersionCount -BlobName $blobName

            # Get reference to the page blob for low-level operations
            $pageBlob = Get-AzStorageBlob `
                -Container $ContainerName `
                -Blob $blobName `
                -Context $script:context

            # Perform the actual test: Write a 512-byte page at a specific offset using Put Page REST operation
            # This simulates how VM disks work - writing specific sectors without touching others
            # Key difference from Put Blob: This updates a SPECIFIC RANGE, not the entire blob
            # Create 512-byte aligned data (page blobs require 512-byte alignment)
            $pageData = New-Object byte[] 512

            for ($i = 0; $i -lt 512; $i++) {
                $pageData[$i] = [byte]($i % 256)
            }

            $stream = New-Object System.IO.MemoryStream(, $pageData)

            # Write to page offset 0 (first 512 bytes of the blob) using Put Page REST operation
            # In a real VM disk, this could be writing to a specific file system sector
            # This is an in-place update that doesn't create a version - critical for VM performance
            $pageBlob.ICloudBlob.WritePages($stream, 0)
            $stream.Dispose()

            # Wait for Azure to process the page write
            Start-Sleep -Seconds 2

            # Measure result: Count versions after the page write
            $versionsAfter = Get-BlobVersionCount -BlobName $blobName

            # Determine if a new version was created
            # Expected: versionsAfter = versionsBefore (no new version)
            # Why: Page writes are in-place updates, crucial for VM performance
            #      Creating a version for every disk sector write would be catastrophic
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
        #
        # WHAT IT DOES:
        #   - Formats test results into a readable table
        #   - Separates operations into two categories:
        #     * Operations that CREATE versions (answer to exam question)
        #     * Operations that DO NOT create versions
        #
        # OUTPUT FORMAT:
        #   - Table shows: Operation name, Version created (✓/✗), Before/After counts, Status
        #   - Summary sections clearly identify versioning vs. non-versioning operations
        #   - Color-coded for easy visual identification (Green = versions, Yellow = no versions)

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
                @{
                    Name       = 'Status'
                    Expression = {
                        # Truncate status to prevent wrapping issues
                        if ($_.Status.Length -gt 50) {
                            $_.Status.Substring(0, 47) + '...'
                        } else {
                            $_.Status
                        }
                    }
                    Width      = 50
                } `
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
