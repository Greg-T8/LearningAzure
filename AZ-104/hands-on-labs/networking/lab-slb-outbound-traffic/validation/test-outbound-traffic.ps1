<#
.SYNOPSIS
Validates the Standard Load Balancer outbound traffic lab deployment.

.DESCRIPTION
Tests that the deployed infrastructure matches the exam scenario:
VM01 has instance public IP, LB01 has two frontend IPs, backend pools
are split correctly, and rules are configured for TCP only.

.CONTEXT
AZ-104 Lab - Configure Standard Load Balancer outbound traffic and IP allocation

.AUTHOR
Greg Tate

.NOTES
Program: test-outbound-traffic.ps1
#>
[CmdletBinding()]
param()

# Script-level configuration
$ResourceGroupName = 'az104-networking-slb-outbound-traffic-tf'
$LbName = 'lb-public'

$Main = {
    . $Helpers

    Write-Host "`n=== Standard Load Balancer Outbound Traffic Validation ===" -ForegroundColor Cyan
    Write-Host "Resource Group: $ResourceGroupName`n"

    # Confirm lab subscription context
    Confirm-LabSubscription

    # Validate public IP configuration
    Test-PublicIpConfiguration

    # Validate load balancer frontend and pools
    Test-LoadBalancerConfiguration

    # Validate load balancing and outbound rules
    Test-LoadBalancerRules

    # Validate VM NIC associations
    Test-NicAssociations

    Write-Host "`n=== All Validations Complete ===" -ForegroundColor Green
}

$Helpers = {

    function Confirm-LabSubscription {
        $expectedSubscriptionId = 'e091f6e7-031a-4924-97bb-8c983ca5d21a'
        $currentSubscription = (Get-AzContext).Subscription.Id

        if ($currentSubscription -ne $expectedSubscriptionId) {
            Write-Error "Not connected to lab subscription. Expected: $expectedSubscriptionId, Current: $currentSubscription"
            exit 1
        }

        Write-Host "[PASS] Connected to lab subscription" -ForegroundColor Green
    }

    function Test-PublicIpConfiguration {
        Write-Host "`n--- Public IP Configuration ---" -ForegroundColor Yellow

        # Retrieve all public IPs in the resource group
        $pips = Get-AzPublicIpAddress -ResourceGroupName $ResourceGroupName

        # Verify three public IPs exist
        if ($pips.Count -eq 3) {
            Write-Host "[PASS] Three public IPs found" -ForegroundColor Green
        } else {
            Write-Host "[FAIL] Expected 3 public IPs, found $($pips.Count)" -ForegroundColor Red
        }

        # Verify all PIPs are Standard SKU
        $standardPips = $pips | Where-Object { $_.Sku.Name -eq 'Standard' }
        if ($standardPips.Count -eq 3) {
            Write-Host "[PASS] All public IPs are Standard SKU" -ForegroundColor Green
        } else {
            Write-Host "[FAIL] Not all public IPs are Standard SKU" -ForegroundColor Red
        }

        # Display IP addresses for reference
        $pips | ForEach-Object {
            Write-Host "  $($_.Name): $($_.IpAddress)" -ForegroundColor Gray
        }
    }

    function Test-LoadBalancerConfiguration {
        Write-Host "`n--- Load Balancer Configuration ---" -ForegroundColor Yellow

        # Retrieve the load balancer
        $lb = Get-AzLoadBalancer -Name $LbName -ResourceGroupName $ResourceGroupName

        # Verify Standard SKU
        if ($lb.Sku.Name -eq 'Standard') {
            Write-Host "[PASS] Load Balancer is Standard SKU" -ForegroundColor Green
        } else {
            Write-Host "[FAIL] Load Balancer SKU is $($lb.Sku.Name), expected Standard" -ForegroundColor Red
        }

        # Verify two frontend IP configurations
        if ($lb.FrontendIpConfigurations.Count -eq 2) {
            Write-Host "[PASS] Two frontend IP configurations found" -ForegroundColor Green
        } else {
            Write-Host "[FAIL] Expected 2 frontend IPs, found $($lb.FrontendIpConfigurations.Count)" -ForegroundColor Red
        }

        # Verify two backend pools (inbound and outbound)
        if ($lb.BackendAddressPools.Count -eq 2) {
            Write-Host "[PASS] Two backend pools found (inbound + outbound)" -ForegroundColor Green
        } else {
            Write-Host "[FAIL] Expected 2 backend pools, found $($lb.BackendAddressPools.Count)" -ForegroundColor Red
        }

        # Display pool names
        $lb.BackendAddressPools | ForEach-Object {
            Write-Host "  Pool: $($_.Name) - Members: $($_.BackendIpConfigurations.Count)" -ForegroundColor Gray
        }
    }

    function Test-LoadBalancerRules {
        Write-Host "`n--- Load Balancer Rules ---" -ForegroundColor Yellow

        # Retrieve the load balancer
        $lb = Get-AzLoadBalancer -Name $LbName -ResourceGroupName $ResourceGroupName

        # Verify LB rule is TCP only
        $lbRule = $lb.LoadBalancingRules[0]
        if ($lbRule.Protocol -eq 'Tcp') {
            Write-Host "[PASS] LB rule protocol is TCP" -ForegroundColor Green
        } else {
            Write-Host "[FAIL] LB rule protocol is $($lbRule.Protocol), expected Tcp" -ForegroundColor Red
        }

        # Verify disable_outbound_snat is true
        if ($lbRule.DisableOutboundSnat -eq $true) {
            Write-Host "[PASS] Outbound SNAT disabled on LB rule" -ForegroundColor Green
        } else {
            Write-Host "[FAIL] Outbound SNAT is NOT disabled on LB rule" -ForegroundColor Red
        }

        # Verify outbound rule exists and is TCP only
        $outboundRule = $lb.OutboundRules[0]
        if ($outboundRule.Protocol -eq 'Tcp') {
            Write-Host "[PASS] Outbound rule protocol is TCP" -ForegroundColor Green
        } else {
            Write-Host "[FAIL] Outbound rule protocol is $($outboundRule.Protocol), expected Tcp" -ForegroundColor Red
        }

        # Verify outbound rule uses both frontend IPs
        if ($outboundRule.FrontendIpConfigurations.Count -eq 2) {
            Write-Host "[PASS] Outbound rule uses both frontend IPs" -ForegroundColor Green
        } else {
            Write-Host "[FAIL] Expected 2 frontend IPs on outbound rule, found $($outboundRule.FrontendIpConfigurations.Count)" -ForegroundColor Red
        }
    }

    function Test-NicAssociations {
        Write-Host "`n--- NIC Backend Pool Associations ---" -ForegroundColor Yellow

        # Check VM01 NIC has instance public IP
        $nic01 = Get-AzNetworkInterface -Name 'nic-vm-web-01' -ResourceGroupName $ResourceGroupName
        if ($null -ne $nic01.IpConfigurations[0].PublicIpAddress) {
            Write-Host "[PASS] VM01 NIC has instance-level public IP (IP01)" -ForegroundColor Green
        } else {
            Write-Host "[FAIL] VM01 NIC does not have an instance-level public IP" -ForegroundColor Red
        }

        # Check VM02 and VM03 NICs do NOT have instance public IPs
        foreach ($vmNum in '02', '03') {
            $nic = Get-AzNetworkInterface -Name "nic-vm-web-$vmNum" -ResourceGroupName $ResourceGroupName
            if ($null -eq $nic.IpConfigurations[0].PublicIpAddress) {
                Write-Host "[PASS] VM$vmNum NIC has no instance-level public IP" -ForegroundColor Green
            } else {
                Write-Host "[FAIL] VM$vmNum NIC unexpectedly has an instance-level public IP" -ForegroundColor Red
            }
        }
    }
}

try {
    Push-Location -Path $PSScriptRoot
    & $Main
}
finally {
    Pop-Location
}
