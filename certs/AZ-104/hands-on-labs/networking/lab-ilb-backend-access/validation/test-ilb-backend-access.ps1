<#
.SYNOPSIS
Validate Internal Load Balancer backend access lab deployment.

.DESCRIPTION
Tests that the ILB, backend pool, health probes, and VMs are correctly
configured. Demonstrates the hairpin failure and proxy solution using
Azure VM Run Command.

.CONTEXT
AZ-104 Lab - Troubleshoot Internal Load Balancer backend VM access

.AUTHOR
Greg Tate

.NOTES
Program: test-ilb-backend-access.ps1
#>

[CmdletBinding()]
param(
    [string]$ResourceGroupName = 'az104-networking-ilb-backend-access-tf'
)

$Main = {
    . $Helpers

    Confirm-LabSubscription
    Show-LoadBalancerConfig
    Show-BackendPoolMembership
    Show-HealthProbeStatus
    Test-HairpinFailure
    Test-ProxySolution
    Test-NonPoolAccess
}

$Helpers = {
    function Confirm-LabSubscription {
        # Validate deployment targets the lab subscription
        $expectedSubscriptionId = 'e091f6e7-031a-4924-97bb-8c983ca5d21a'
        $currentSubscription = (Get-AzContext).Subscription.Id

        if ($currentSubscription -ne $expectedSubscriptionId) {
            Write-Error "Not connected to lab subscription."
            exit 1
        }

        Write-Host "`n[PASS] Connected to lab subscription" -ForegroundColor Green
    }

    function Show-LoadBalancerConfig {
        # Display ILB configuration and frontend IP
        Write-Host "`n--- Internal Load Balancer Configuration ---" -ForegroundColor Cyan

        $lb = Get-AzLoadBalancer -Name 'lb-internal' -ResourceGroupName $ResourceGroupName
        $frontendIp = $lb.FrontendIpConfigurations[0].PrivateIpAddress

        Write-Host "  Name: $($lb.Name)"
        Write-Host "  SKU:  $($lb.Sku.Name)"
        Write-Host "  Frontend IP: $frontendIp"
        Write-Host "  Frontend Subnet: $($lb.FrontendIpConfigurations[0].Subnet.Id.Split('/')[-1])"

        if ($frontendIp -eq '10.0.1.10') {
            Write-Host "[PASS] Frontend IP is 10.0.1.10 (static)" -ForegroundColor Green
        } else {
            Write-Host "[FAIL] Expected frontend IP 10.0.1.10, got $frontendIp" -ForegroundColor Red
        }
    }

    function Show-BackendPoolMembership {
        # Verify backend pool has exactly 2 VMs
        Write-Host "`n--- Backend Pool Membership ---" -ForegroundColor Cyan

        $lb = Get-AzLoadBalancer -Name 'lb-internal' -ResourceGroupName $ResourceGroupName
        $pool = $lb.BackendAddressPools | Where-Object { $_.Name -eq 'pool-backend' }
        $memberCount = $pool.BackendIpConfigurations.Count

        Write-Host "  Pool: $($pool.Name)"
        Write-Host "  Members: $memberCount"

        if ($memberCount -eq 2) {
            Write-Host "[PASS] Backend pool has 2 members" -ForegroundColor Green
        } else {
            Write-Host "[FAIL] Expected 2 pool members, got $memberCount" -ForegroundColor Red
        }
    }

    function Show-HealthProbeStatus {
        # Verify health probe configuration
        Write-Host "`n--- Health Probe ---" -ForegroundColor Cyan

        $lb = Get-AzLoadBalancer -Name 'lb-internal' -ResourceGroupName $ResourceGroupName
        $probe = $lb.Probes[0]

        Write-Host "  Name: $($probe.Name)"
        Write-Host "  Protocol: $($probe.Protocol)"
        Write-Host "  Port: $($probe.Port)"

        if ($probe.Protocol -eq 'Tcp' -and $probe.Port -eq 80) {
            Write-Host "[PASS] Health probe configured for TCP:80" -ForegroundColor Green
        } else {
            Write-Host "[FAIL] Unexpected probe configuration" -ForegroundColor Red
        }
    }

    function Test-HairpinFailure {
        # Demonstrate that a backend VM cannot reach the ILB frontend (hairpin)
        Write-Host "`n--- Test: Backend VM to ILB Frontend (Hairpin) ---" -ForegroundColor Cyan
        Write-Host "  Running curl from vm-backend-01 to ILB frontend 10.0.1.10..."
        Write-Host "  (This should fail due to the hairpin/loopback limitation)"

        $result = Invoke-AzVMRunCommand `
            -ResourceGroupName $ResourceGroupName `
            -VMName 'vm-backend-01' `
            -CommandId 'RunShellScript' `
            -ScriptString 'curl -s --connect-timeout 5 --max-time 10 http://10.0.1.10 2>&1 || echo "CURL_FAILED"'

        $output = $result.Value[0].Message

        if ($output -match 'CURL_FAILED|timed out|Connection refused|Could not resolve') {
            Write-Host "[PASS] Confirmed: backend VM CANNOT reach ILB frontend (hairpin failure)" -ForegroundColor Green
        } else {
            Write-Host "[INFO] Unexpected result - check output below:" -ForegroundColor Yellow
        }

        Write-Host "  Output: $output"
    }

    function Test-ProxySolution {
        # Demonstrate that a backend VM can reach content via the proxy
        Write-Host "`n--- Test: Backend VM to Proxy VM (Solution) ---" -ForegroundColor Cyan
        Write-Host "  Running curl from vm-backend-01 to proxy at 10.0.2.10..."
        Write-Host "  (This should succeed - proxy forwards to ILB without hairpin)"

        $result = Invoke-AzVMRunCommand `
            -ResourceGroupName $ResourceGroupName `
            -VMName 'vm-backend-01' `
            -CommandId 'RunShellScript' `
            -ScriptString 'curl -s --connect-timeout 5 --max-time 10 http://10.0.2.10 2>&1'

        $output = $result.Value[0].Message

        if ($output -match 'Hello from vm-backend') {
            Write-Host "[PASS] Proxy solution works - backend VM reached content via proxy" -ForegroundColor Green
        } else {
            Write-Host "[WARN] Proxy may need more time to initialize. Output:" -ForegroundColor Yellow
        }

        Write-Host "  Output: $output"
    }

    function Test-NonPoolAccess {
        # Demonstrate that a non-pool VM can reach the ILB frontend directly
        Write-Host "`n--- Test: Non-Pool VM to ILB Frontend (Control) ---" -ForegroundColor Cyan
        Write-Host "  Running curl from vm-proxy-01 to ILB frontend 10.0.1.10..."
        Write-Host "  (This should succeed - proxy VM is NOT in the backend pool)"

        $result = Invoke-AzVMRunCommand `
            -ResourceGroupName $ResourceGroupName `
            -VMName 'vm-proxy-01' `
            -CommandId 'RunShellScript' `
            -ScriptString 'curl -s --connect-timeout 5 --max-time 10 http://10.0.1.10 2>&1'

        $output = $result.Value[0].Message

        if ($output -match 'Hello from vm-backend') {
            Write-Host "[PASS] Non-pool VM CAN reach ILB frontend directly" -ForegroundColor Green
        } else {
            Write-Host "[WARN] Non-pool access test may need more time. Output:" -ForegroundColor Yellow
        }

        Write-Host "  Output: $output"
    }
}

try {
    Push-Location -Path $PSScriptRoot
    & $Main
}
finally {
    Pop-Location
}
