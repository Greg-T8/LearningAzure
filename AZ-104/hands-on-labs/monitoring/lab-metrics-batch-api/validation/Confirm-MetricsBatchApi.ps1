<#
.SYNOPSIS
Validate Azure Monitor metrics:getBatch API against deployed lab VMs.

.DESCRIPTION
Confirms subscription context, verifies VM deployment, then demonstrates
the metrics:getBatch REST API to query multi-resource metrics in a single
request. Validates the three exam statements about batch metric constraints.

.CONTEXT
AZ-104 Lab - Azure Monitor Metrics Batch API (Microsoft Azure Administrator)

.AUTHOR
Greg Tate

.NOTES
Program: Confirm-MetricsBatchApi.ps1
#>

[CmdletBinding()]
param()

# Configuration
$ResourceGroupName = 'az104-monitoring-metrics-batch-api-tf'
$ExpectedSubscriptionId = 'e091f6e7-031a-4924-97bb-8c983ca5d21a'
$ExpectedVmCount = 2

$Main = {
    . $Helpers

    Confirm-LabSubscription
    Confirm-LabVirtualMachine
    Test-MetricDefinition
    Test-MetricsBatchApi
    Show-ExamStatementAnalysis
}

$Helpers = {

    function Confirm-LabSubscription {
        # Validate deployment runs against the lab subscription
        $currentSubscription = (Get-AzContext).Subscription.Id

        if ($currentSubscription -ne $ExpectedSubscriptionId) {
            Write-Error "Not connected to lab subscription. Expected: $ExpectedSubscriptionId, Got: $currentSubscription"
            exit 1
        }

        Write-Host "`n=== Subscription Validation ===" -ForegroundColor Cyan
        Write-Host "Connected to lab subscription: $currentSubscription" -ForegroundColor Green
    }

    function Confirm-LabVirtualMachine {
        # Verify both VMs exist and are running
        Write-Host "`n=== VM Deployment Verification ===" -ForegroundColor Cyan

        $vms = Get-AzVM -ResourceGroupName $ResourceGroupName -ErrorAction Stop
        Write-Host "VMs found: $($vms.Count) (expected: $ExpectedVmCount)"

        if ($vms.Count -ne $ExpectedVmCount) {
            Write-Error "Expected $ExpectedVmCount VMs, found $($vms.Count)."
            exit 1
        }

        # Display VM details
        foreach ($vm in $vms) {
            $status = (Get-AzVM -ResourceGroupName $ResourceGroupName -Name $vm.Name -Status).Statuses |
                Where-Object Code -like 'PowerState/*' |
                Select-Object -ExpandProperty DisplayStatus

            Write-Host "  VM: $($vm.Name) | Location: $($vm.Location) | Status: $status" -ForegroundColor Green
        }

        # Confirm same region (required for batch API)
        $regions = $vms | Select-Object -ExpandProperty Location -Unique

        if ($regions.Count -eq 1) {
            Write-Host "  All VMs are in the same region: $regions" -ForegroundColor Green
        } else {
            Write-Warning "VMs are in different regions: $($regions -join ', '). Batch API requires same region."
        }

        # Confirm same resource type
        Write-Host "  All VMs are resource type: Microsoft.Compute/virtualMachines" -ForegroundColor Green
    }

    function Test-MetricDefinition {
        # Retrieve multi-dimensional metric definitions for a VM
        Write-Host "`n=== Metric Definitions (Multi-Dimensional) ===" -ForegroundColor Cyan

        $vms = Get-AzVM -ResourceGroupName $ResourceGroupName
        $vmResourceId = $vms[0].Id

        # Get metric definitions to show available multi-dimensional metrics
        $definitions = Get-AzMetricDefinition -ResourceId $vmResourceId |
            Where-Object { $_.Dimensions.Count -gt 0 } |
            Select-Object -First 5

        if ($definitions) {
            Write-Host "Multi-dimensional metrics available for $($vms[0].Name):"
            foreach ($def in $definitions) {
                $dims = ($def.Dimensions | Select-Object -ExpandProperty Value) -join ', '
                Write-Host "  Metric: $($def.Name.Value) | Dimensions: $dims" -ForegroundColor Yellow
            }
        } else {
            Write-Host "  No multi-dimensional metrics found (metrics may need time to populate)." -ForegroundColor Yellow
        }

        # Also show standard metrics
        Write-Host "`nStandard metrics (Percentage CPU):"
        $cpuMetric = Get-AzMetric -ResourceId $vmResourceId `
            -MetricName "Percentage CPU" `
            -TimeGrain 00:05:00 `
            -AggregationType Average `
            -ErrorAction SilentlyContinue

        if ($cpuMetric.Data) {
            $latestPoint = $cpuMetric.Data | Where-Object { $null -ne $_.Average } | Select-Object -Last 1

            if ($latestPoint) {
                Write-Host "  CPU Average: $([math]::Round($latestPoint.Average, 2))% at $($latestPoint.TimeStamp)" -ForegroundColor Green
            } else {
                Write-Host "  CPU metrics not yet available (VMs may need a few minutes)." -ForegroundColor Yellow
            }
        } else {
            Write-Host "  CPU metrics not yet available." -ForegroundColor Yellow
        }
    }

    function Test-MetricsBatchApi {
        # Demonstrate the metrics:getBatch REST API for multi-resource queries
        Write-Host "`n=== metrics:getBatch API Test ===" -ForegroundColor Cyan

        $vms = Get-AzVM -ResourceGroupName $ResourceGroupName
        $context        = Get-AzContext
        $subscriptionId = $context.Subscription.Id
        $location       = $vms[0].Location

        # Build list of VM resource IDs
        $resourceIds = $vms | Select-Object -ExpandProperty Id
        Write-Host "Resource IDs for batch query:"
        foreach ($id in $resourceIds) {
            Write-Host "  $id" -ForegroundColor Yellow
        }

        # Get access token for Azure Monitor and convert SecureString to plain text
        $tokenResponse  = Get-AzAccessToken -ResourceUrl "https://metrics.monitor.azure.com"
        $token          = $tokenResponse.Token | ConvertFrom-SecureString -AsPlainText

        # Build a 1-hour UTC window required by metrics:getBatch
        $endTime       = (Get-Date).ToUniversalTime()
        $startTime     = $endTime.AddHours(-1)
        $startTimeText = $startTime.ToString('o')
        $endTimeText   = $endTime.ToString('o')

        # Build batch API request
        $batchUri = "https://${location}.metrics.monitor.azure.com/subscriptions/${subscriptionId}/metrics:getBatch" +
            "?api-version=2024-02-01" +
            "&metricnames=Percentage CPU" +
            "&metricNamespace=Microsoft.Compute/virtualMachines" +
            "&starttime=${startTimeText}" +
            "&endtime=${endTimeText}" +
            "&interval=PT5M" +
            "&aggregation=Average"

        $body = @{
            resourceids = $resourceIds
        } | ConvertTo-Json

        $headers = @{
            Authorization  = "Bearer $token"
            'Content-Type' = 'application/json'
        }

        Write-Host "`nCalling metrics:getBatch endpoint..."
        Write-Host "  Endpoint: https://${location}.metrics.monitor.azure.com" -ForegroundColor Yellow

        try {
            # Call the batch metrics API
            $response = Invoke-RestMethod -Uri $batchUri -Method Post -Headers $headers -Body $body -ErrorAction Stop

            Write-Host "  Batch API call successful!" -ForegroundColor Green
            Write-Host "  Resources returned: $($response.values.Count)"

            # Display results per VM
            foreach ($value in $response.values) {
                $vmName = ($value.resourceid -split '/')[-1]
                $timeseries = $value.value.timeseries

                if ($timeseries -and $timeseries[0].data) {
                    $latest = $timeseries[0].data | Where-Object { $null -ne $_.average } | Select-Object -Last 1

                    if ($latest) {
                        Write-Host "  $vmName - CPU: $([math]::Round($latest.average, 2))% at $($latest.timeStamp)" -ForegroundColor Green
                    } else {
                        Write-Host "  $vmName - CPU data not yet available" -ForegroundColor Yellow
                    }
                } else {
                    Write-Host "  $vmName - No timeseries data yet" -ForegroundColor Yellow
                }
            }
        }
        catch {
            Write-Warning "Batch API call failed: $($_.Exception.Message)"
            Write-Host "  This is expected if VMs were just deployed. Metrics may take 5-10 minutes to populate." -ForegroundColor Yellow
        }
    }

    function Show-ExamStatementAnalysis {
        # Summarize the three exam statements and their correct answers
        Write-Host "`n=== Exam Statement Analysis ===" -ForegroundColor Cyan

        Write-Host "`nStatement 1: 'The metrics:getBatch API allows you to prevent throttling" -ForegroundColor White
        Write-Host "              and performance issues when querying multiple resources" -ForegroundColor White
        Write-Host "              in a single REST request.'" -ForegroundColor White
        Write-Host "  Answer: YES" -ForegroundColor Green
        Write-Host "  Reason: The batch API retrieves metrics for multiple resources in one call," -ForegroundColor Gray
        Write-Host "          reducing API calls and avoiding per-resource throttling limits." -ForegroundColor Gray

        Write-Host "`nStatement 2: 'Both VMs can be spread across multiple Azure regions.'" -ForegroundColor White
        Write-Host "  Answer: NO" -ForegroundColor Red
        Write-Host "  Reason: The batch API requires all resources to be in the SAME region." -ForegroundColor Gray
        Write-Host "          The regional endpoint (e.g., centralus.metrics.monitor.azure.com)" -ForegroundColor Gray
        Write-Host "          only serves resources in that region." -ForegroundColor Gray

        Write-Host "`nStatement 3: 'Both VMs must be the same resource type.'" -ForegroundColor White
        Write-Host "  Answer: YES" -ForegroundColor Green
        Write-Host "  Reason: The batch API requires all resources in the request to share" -ForegroundColor Gray
        Write-Host "          the same resource type and metric namespace." -ForegroundColor Gray
        Write-Host "          (e.g., all Microsoft.Compute/virtualMachines)" -ForegroundColor Gray

        Write-Host "`n=== Validation Complete ===" -ForegroundColor Cyan
    }
}

try {
    Push-Location -Path $PSScriptRoot
    & $Main
}
finally {
    Pop-Location
}
