<#
.SYNOPSIS
Generate a deterministic 7-character hex ID from a question title.

.DESCRIPTION
Computes a SHA-256 hash of the lowercased, trimmed question title and returns
the first 7 hex characters. The same title always produces the same ID, making
the output deterministic and reproducible.

.CONTEXT
LearningAzure repository — practice exam question ID generation.

.AUTHOR
Greg Tate

.NOTES
Program: New-QuestionId.ps1
#>

[CmdletBinding()]
param(
    [Parameter(Mandatory, ValueFromPipeline)]
    [string]$Title
)

$Main = {
    . $Helpers

    $id = Get-DeterministicId -Title $Title
    Write-Output $id
}

#region HELPER FUNCTIONS
$Helpers = {

    function Get-DeterministicId {
        # Compute SHA-256 hash of the normalized title and return the first 7 hex characters
        param(
            [Parameter(Mandatory)]
            [string]$Title
        )

        $normalized = $Title.Trim().ToLowerInvariant()
        $bytes = [System.Text.Encoding]::UTF8.GetBytes($normalized)
        $hash = [System.Security.Cryptography.SHA256]::HashData($bytes)
        $hex = [System.BitConverter]::ToString($hash).Replace('-', '').ToLowerInvariant()

        return $hex.Substring(0, 7)
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
