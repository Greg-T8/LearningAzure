<#
.SYNOPSIS
Validates the current Azure context targets the lab subscription.

.DESCRIPTION
Confirms that the active Azure subscription matches the expected lab
subscription ID. Exits with error if the subscription does not match.

.CONTEXT
Lab Orchestrator — pre-deployment guardrail.

.AUTHOR
Greg Tate

.NOTES
Program: Confirm-LabSubscription.ps1
#>
[CmdletBinding()]
param()

# Script-level configuration
$ExpectedSubscriptionId = 'e091f6e7-031a-4924-97bb-8c983ca5d21a'

$Main = {
    . $Helpers

    # Validate the current Azure subscription context
    Confirm-LabSubscription
}

$Helpers = {
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

        if ($currentSubscriptionId -ne $ExpectedSubscriptionId) {
            Write-Error ("Not connected to lab subscription.`n" +
                "  Expected: $ExpectedSubscriptionId`n" +
                "  Current:  $currentSubscriptionId")
            exit 1
        }

        # Confirm successful validation
        Write-Host "Lab subscription confirmed: $($currentContext.Subscription.Name) ($currentSubscriptionId)" -ForegroundColor Green
    }
}

try {
    Push-Location -Path $PSScriptRoot
    & $Main
}
finally {
    Pop-Location
}
