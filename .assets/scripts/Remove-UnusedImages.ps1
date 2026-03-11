<#
.SYNOPSIS
Remove unreferenced images from .img folders in the workspace.

.DESCRIPTION
Scans every .img directory under the workspace root, checks each image file
against all sibling markdown files in the parent directory, and removes any
image that is not referenced. Supports a -WhatIf preview mode to see what
would be deleted without actually removing files.

.CONTEXT
LearningAzure repository — workspace housekeeping and space optimization.

.AUTHOR
Greg Tate

.NOTES
Program: Remove-UnusedImages.ps1
#>

[CmdletBinding(SupportsShouldProcess)]
param(
    [Parameter()]
    [string]$Path
)

# Configuration
$ImageExtensions = @('.png', '.jpg', '.jpeg', '.gif', '.svg', '.webp')

$Main = {
    . $Helpers

    $repoRoot = Get-RepoRoot
    $imgDirectories = Get-ImgDirectory -Root $repoRoot
    $results = @(Find-UnusedImage -ImgDirectories $imgDirectories)
    Remove-UnusedImage -UnusedImages $results
    Show-Summary -UnusedImages $results
}

#region HELPER FUNCTIONS
$Helpers = {
    function Get-RepoRoot {
        # Resolve the workspace root from the -Path parameter or default to two levels above $PSScriptRoot
        if ($Path) {
            return (Resolve-Path -Path $Path).Path
        }

        # Prefer the actual Git repository root when no path is provided
        $gitRoot = & git -C $PSScriptRoot rev-parse --show-toplevel 2>$null

        if ($LASTEXITCODE -eq 0 -and -not [string]::IsNullOrWhiteSpace($gitRoot)) {
            return (Resolve-Path -Path $gitRoot.Trim()).Path
        }

        # Fallback to the expected repository layout relative to this script
        return (Resolve-Path -Path (Join-Path -Path $PSScriptRoot -ChildPath '..\..')).Path
    }

    function Get-ImgDirectory {
        # Discover all .img directories under the given root
        param(
            [Parameter(Mandatory)]
            [string]$Root
        )

        $dirs = Get-ChildItem -Path $Root -Directory -Recurse -Filter '.img'

        if (-not $dirs) {
            Write-Host 'No .img directories found.' -ForegroundColor Yellow
        }

        return $dirs
    }

    function Find-UnusedImage {
        # For each .img directory, identify images not referenced by any sibling markdown file
        param(
            [Parameter(Mandatory)]
            [AllowNull()]
            [object[]]$ImgDirectories
        )

        if (-not $ImgDirectories) {
            return @()
        }

        $unused = [System.Collections.Generic.List[object]]::new()

        foreach ($imgDir in $ImgDirectories) {
            $parentDir = $imgDir.Parent.FullName

            # Gather all sibling markdown files
            $mdFiles = Get-ChildItem -Path $parentDir -Filter '*.md' -File

            if (-not $mdFiles) {
                # No markdown files — every image in this .img folder is unreferenced
                $images = Get-ChildItem -Path $imgDir.FullName -File |
                    Where-Object { $ImageExtensions -contains $_.Extension.ToLower() }

                foreach ($image in $images) {
                    $unused.Add($image)
                }
                continue
            }

            # Read all markdown content once and combine into a single string for searching
            $combinedContent = ($mdFiles |
                ForEach-Object { Get-Content -Path $_.FullName -Raw }) -join "`n"

            # Check each image file for a reference in the combined content
            $images = Get-ChildItem -Path $imgDir.FullName -File |
                Where-Object { $ImageExtensions -contains $_.Extension.ToLower() }

            foreach ($image in $images) {
                $escapedName = [regex]::Escape($image.Name)

                if ($combinedContent -notmatch $escapedName) {
                    $unused.Add($image)
                }
            }
        }

        return $unused.ToArray()
    }

    function Remove-UnusedImage {
        # Delete each unreferenced image file, respecting -WhatIf
        [CmdletBinding(SupportsShouldProcess)]
        param(
            [Parameter(Mandatory)]
            [AllowNull()]
            [AllowEmptyCollection()]
            [object[]]$UnusedImages
        )

        if (-not $UnusedImages) {
            return
        }

        foreach ($image in $UnusedImages) {
            if ($PSCmdlet.ShouldProcess($image.FullName, 'Remove unreferenced image')) {
                Remove-Item -Path $image.FullName -Force
            }
        }
    }

    function Show-Summary {
        # Display a summary of what was found and removed
        param(
            [Parameter(Mandatory)]
            [AllowEmptyCollection()]
            [object[]]$UnusedImages
        )

        if (-not $UnusedImages -or $UnusedImages.Count -eq 0) {
            Write-Host "`nNo unused images found. Workspace is clean!" -ForegroundColor Green
            return
        }

        # Calculate total size saved
        $totalBytes = ($UnusedImages | Measure-Object -Property Length -Sum).Sum
        $sizeMB = [math]::Round($totalBytes / 1MB, 2)

        $action = if ($WhatIfPreference) { 'would be removed' } else { 'removed' }

        Write-Host "`n--- Summary ---" -ForegroundColor Cyan
        Write-Host "$($UnusedImages.Count) unused image(s) $action ($sizeMB MB)" -ForegroundColor Cyan

        # Group by parent .img directory for a readable breakdown
        $grouped = $UnusedImages |
            Group-Object { $_.Directory.FullName }

        foreach ($group in $grouped) {
            Write-Host "`n  $($group.Name)" -ForegroundColor DarkGray

            foreach ($file in $group.Group) {
                $sizeKB = [math]::Round($file.Length / 1KB, 1)
                Write-Host "    - $($file.Name) ($sizeKB KB)" -ForegroundColor Gray
            }
        }
    }
}
#endregion

try {
    Push-Location -Path $PSScriptRoot
    & $Main
}
finally {
    Pop-Location
}
