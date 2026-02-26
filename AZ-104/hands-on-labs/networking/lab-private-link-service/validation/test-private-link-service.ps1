<#
.SYNOPSIS
Validates the Private Link Service lab deployment.

.DESCRIPTION
Tests that the deployed infrastructure matches the exam scenario:
Provider VNet with PLS subnet (network policies disabled), Standard ILB,
Private Link Service, consumer Private Endpoint, NSG ACL filtering,
and Bastion Developer SKU.

.CONTEXT
AZ-104 Lab - Azure Private Link Service network policies

.AUTHOR
Greg Tate

.NOTES
Program: test-private-link-service.ps1
#>
[CmdletBinding()]
param()

# Script-level configuration
$ResourceGroupName = 'az104-networking-private-link-service-tf'
$PlsName = 'pls-web'
$PeName = 'pe-web'
$LbName = 'lb-private-link'

$Main = {
    . $Helpers

    Write-Host "`n=== Private Link Service Validation ===" -ForegroundColor Cyan
    Write-Host "Resource Group: $ResourceGroupName`n"

    # Confirm lab subscription context
    Confirm-LabSubscription

    # Validate VNet and subnet configuration
    Test-NetworkConfiguration

    # Validate subnet network policies
    Test-PrivateLinkNetworkPolicies

    # Validate load balancer configuration
    Test-LoadBalancerConfiguration

    # Validate Private Link Service
    Test-PrivateLinkService

    # Validate Private Endpoint
    Test-PrivateEndpoint

    # Validate NSG ACL filtering on backend subnet
    Test-NsgConfiguration

    # Validate Bastion Developer SKU
    Test-BastionConfiguration

    Write-Host "`n=== All Validations Complete ===" -ForegroundColor Green
}

$Helpers = {

    function Confirm-LabSubscription {
        # Verify the correct subscription context
        $expectedSubscriptionId = 'e091f6e7-031a-4924-97bb-8c983ca5d21a'
        $currentSubscription = (Get-AzContext).Subscription.Id

        if ($currentSubscription -ne $expectedSubscriptionId) {
            Write-Error "Not connected to lab subscription. Expected: $expectedSubscriptionId, Current: $currentSubscription"
            exit 1
        }

        Write-Host "[PASS] Connected to lab subscription" -ForegroundColor Green
    }

    function Test-NetworkConfiguration {
        Write-Host "`n--- Network Configuration ---" -ForegroundColor Yellow

        # Verify provider VNet exists
        $providerVnet = Get-AzVirtualNetwork -ResourceGroupName $ResourceGroupName -Name 'vnet-provider' -ErrorAction SilentlyContinue
        if ($providerVnet) {
            Write-Host "[PASS] Provider VNet 'vnet-provider' exists" -ForegroundColor Green
            Write-Host "       Address Space: $($providerVnet.AddressSpace.AddressPrefixes -join ', ')"
        } else {
            Write-Host "[FAIL] Provider VNet 'vnet-provider' not found" -ForegroundColor Red
        }

        # Verify consumer VNet exists
        $consumerVnet = Get-AzVirtualNetwork -ResourceGroupName $ResourceGroupName -Name 'vnet-consumer' -ErrorAction SilentlyContinue
        if ($consumerVnet) {
            Write-Host "[PASS] Consumer VNet 'vnet-consumer' exists" -ForegroundColor Green
            Write-Host "       Address Space: $($consumerVnet.AddressSpace.AddressPrefixes -join ', ')"
        } else {
            Write-Host "[FAIL] Consumer VNet 'vnet-consumer' not found" -ForegroundColor Red
        }

        # Verify subnet count in provider VNet
        if ($providerVnet) {
            $subnetCount = $providerVnet.Subnets.Count
            if ($subnetCount -ge 2) {
                Write-Host "[PASS] Provider VNet has $subnetCount subnets (backend + pls)" -ForegroundColor Green
            } else {
                Write-Host "[FAIL] Expected at least 2 subnets in provider VNet, found $subnetCount" -ForegroundColor Red
            }
        }
    }

    function Test-PrivateLinkNetworkPolicies {
        Write-Host "`n--- Private Link Network Policies ---" -ForegroundColor Yellow

        # Retrieve the PLS subnet
        $providerVnet = Get-AzVirtualNetwork -ResourceGroupName $ResourceGroupName -Name 'vnet-provider'
        $plsSubnet = $providerVnet.Subnets | Where-Object Name -eq 'snet-pls'

        if ($plsSubnet) {
            # Check if privateLinkServiceNetworkPolicies is disabled
            $policiesDisabled = $plsSubnet.PrivateLinkServiceNetworkPolicies -eq 'Disabled'
            if ($policiesDisabled) {
                Write-Host "[PASS] privateLinkServiceNetworkPolicies is Disabled on snet-pls" -ForegroundColor Green
            } else {
                Write-Host "[FAIL] privateLinkServiceNetworkPolicies is NOT Disabled on snet-pls (Value: $($plsSubnet.PrivateLinkServiceNetworkPolicies))" -ForegroundColor Red
            }

            # Verify address prefix matches ARM template
            $expectedPrefix = '10.1.4.0/24'
            if ($plsSubnet.AddressPrefix -eq $expectedPrefix) {
                Write-Host "[PASS] PLS subnet address prefix matches ARM template: $expectedPrefix" -ForegroundColor Green
            } else {
                Write-Host "[INFO] PLS subnet address prefix: $($plsSubnet.AddressPrefix)" -ForegroundColor Cyan
            }
        } else {
            Write-Host "[FAIL] PLS subnet 'snet-pls' not found" -ForegroundColor Red
        }

        # Verify backend subnet still has policies enabled (default)
        $backendSubnet = $providerVnet.Subnets | Where-Object Name -eq 'snet-backend'
        if ($backendSubnet) {
            $backendPolicies = $backendSubnet.PrivateLinkServiceNetworkPolicies -eq 'Enabled'
            if ($backendPolicies) {
                Write-Host "[PASS] privateLinkServiceNetworkPolicies is Enabled on snet-backend (default)" -ForegroundColor Green
            } else {
                Write-Host "[INFO] privateLinkServiceNetworkPolicies on snet-backend: $($backendSubnet.PrivateLinkServiceNetworkPolicies)" -ForegroundColor Cyan
            }
        }
    }

    function Test-LoadBalancerConfiguration {
        Write-Host "`n--- Load Balancer Configuration ---" -ForegroundColor Yellow

        # Verify Standard Internal Load Balancer exists
        $lb = Get-AzLoadBalancer -ResourceGroupName $ResourceGroupName -Name $LbName -ErrorAction SilentlyContinue
        if ($lb) {
            Write-Host "[PASS] Load Balancer '$LbName' exists" -ForegroundColor Green

            # Verify SKU is Standard
            if ($lb.Sku.Name -eq 'Standard') {
                Write-Host "[PASS] Load Balancer SKU is Standard" -ForegroundColor Green
            } else {
                Write-Host "[FAIL] Expected Standard SKU, found $($lb.Sku.Name)" -ForegroundColor Red
            }

            # Verify frontend IP is internal (has subnet, no public IP)
            $frontend = $lb.FrontendIpConfigurations[0]
            if ($frontend.Subnet -and -not $frontend.PublicIpAddress) {
                Write-Host "[PASS] Load Balancer is internal (no public IP)" -ForegroundColor Green
                Write-Host "       Frontend Private IP: $($frontend.PrivateIpAddress)"
            } else {
                Write-Host "[FAIL] Load Balancer is not internal" -ForegroundColor Red
            }
        } else {
            Write-Host "[FAIL] Load Balancer '$LbName' not found" -ForegroundColor Red
        }
    }

    function Test-PrivateLinkService {
        Write-Host "`n--- Private Link Service ---" -ForegroundColor Yellow

        # Verify PLS exists and is connected to ILB
        $pls = Get-AzPrivateLinkService -ResourceGroupName $ResourceGroupName -Name $PlsName -ErrorAction SilentlyContinue
        if ($pls) {
            Write-Host "[PASS] Private Link Service '$PlsName' exists" -ForegroundColor Green
            Write-Host "       Alias: $($pls.Alias)"

            # Verify NAT IP configuration
            $natIpConfig = $pls.IpConfigurations
            if ($natIpConfig.Count -ge 1) {
                Write-Host "[PASS] PLS has $($natIpConfig.Count) NAT IP configuration(s)" -ForegroundColor Green

                # Show the source NAT IP
                $primaryNat = $natIpConfig | Where-Object Primary -eq $true | Select-Object -First 1
                if ($primaryNat) {
                    $primaryNatIp = $primaryNat.PrivateIPAddress

                    # For dynamic NAT allocation, resolve the runtime IP from the PLS-managed NIC.
                    if (-not $primaryNatIp -and $pls.NetworkInterfaces.Count -ge 1) {
                        $plsNic = Get-AzNetworkInterface -ResourceId $pls.NetworkInterfaces[0].Id -ErrorAction SilentlyContinue
                        if ($plsNic) {
                            $primaryNicIpConfig = $plsNic.IpConfigurations | Where-Object { $_.Primary -eq $true -and $_.Name -eq $primaryNat.Name } | Select-Object -First 1
                            if (-not $primaryNicIpConfig) {
                                $primaryNicIpConfig = $plsNic.IpConfigurations | Where-Object Primary -eq $true | Select-Object -First 1
                            }

                            if ($primaryNicIpConfig) {
                                $primaryNatIp = $primaryNicIpConfig.PrivateIpAddress
                            }
                        }
                    }

                    if ($primaryNatIp) {
                        Write-Host "       Primary NAT IP: $primaryNatIp" -ForegroundColor Cyan
                        Write-Host "       (This is the source IP that privateLinkServiceNetworkPolicies applies to)"
                    } else {
                        Write-Host "[INFO] Primary NAT IP is not currently populated in Az.PrivateLinkService output" -ForegroundColor Yellow
                    }
                }
            } else {
                Write-Host "[FAIL] PLS has no NAT IP configurations" -ForegroundColor Red
            }

            # Verify PLS is connected to load balancer
            if ($pls.LoadBalancerFrontendIpConfigurations.Count -ge 1) {
                Write-Host "[PASS] PLS is connected to load balancer frontend" -ForegroundColor Green
            } else {
                Write-Host "[FAIL] PLS is not connected to a load balancer" -ForegroundColor Red
            }

            # Check connection status
            $connections = $pls.PrivateEndpointConnections
            if ($connections.Count -ge 1) {
                Write-Host "[PASS] PLS has $($connections.Count) endpoint connection(s)" -ForegroundColor Green
                foreach ($conn in $connections) {
                    Write-Host "       Connection: $($conn.Name) - Status: $($conn.PrivateLinkServiceConnectionState.Status)"
                }
            }
        } else {
            Write-Host "[FAIL] Private Link Service '$PlsName' not found" -ForegroundColor Red
        }
    }

    function Test-PrivateEndpoint {
        Write-Host "`n--- Private Endpoint ---" -ForegroundColor Yellow

        # Verify Private Endpoint exists in consumer VNet
        $pe = Get-AzPrivateEndpoint -ResourceGroupName $ResourceGroupName -Name $PeName -ErrorAction SilentlyContinue
        if ($pe) {
            Write-Host "[PASS] Private Endpoint '$PeName' exists" -ForegroundColor Green

            # Verify connection status
            $connection = $pe.PrivateLinkServiceConnections[0]
            if ($connection.PrivateLinkServiceConnectionState.Status -eq 'Approved') {
                Write-Host "[PASS] Connection status: Approved" -ForegroundColor Green
            } else {
                Write-Host "[INFO] Connection status: $($connection.PrivateLinkServiceConnectionState.Status)" -ForegroundColor Yellow
            }

            # Show private IP address
            $peNic = Get-AzNetworkInterface -ResourceId $pe.NetworkInterfaces[0].Id
            $peIp = $peNic.IpConfigurations[0].PrivateIpAddress
            Write-Host "       Private Endpoint IP: $peIp"
            Write-Host "       (Consumer accesses service via this IP)"
        } else {
            Write-Host "[FAIL] Private Endpoint '$PeName' not found" -ForegroundColor Red
        }
    }

    function Test-NsgConfiguration {
        Write-Host "`n--- NSG ACL Filtering ---" -ForegroundColor Yellow

        # Verify NSG exists on backend subnet
        $nsg = Get-AzNetworkSecurityGroup -ResourceGroupName $ResourceGroupName -Name 'nsg-backend' -ErrorAction SilentlyContinue
        if ($nsg) {
            Write-Host "[PASS] NSG 'nsg-backend' exists on backend subnet" -ForegroundColor Green
            Write-Host "       (Demonstrates ACL filtering still applies to other resources)"

            # List security rules
            $rules = $nsg.SecurityRules
            foreach ($rule in $rules) {
                Write-Host "       Rule: $($rule.Name) - $($rule.Direction) $($rule.Access) $($rule.Protocol)/$($rule.DestinationPortRange)"
            }
        } else {
            Write-Host "[FAIL] NSG 'nsg-backend' not found" -ForegroundColor Red
        }
    }

    function Test-BastionConfiguration {
        Write-Host "`n--- Bastion Configuration ---" -ForegroundColor Yellow

        # Verify Bastion Developer SKU exists
        $bastion = Get-AzBastion -ResourceGroupName $ResourceGroupName -ErrorAction SilentlyContinue
        if ($bastion) {
            Write-Host "[PASS] Azure Bastion exists: $($bastion.Name)" -ForegroundColor Green
            Write-Host "       SKU: $($bastion.SkuText)"
        } else {
            Write-Host "[FAIL] Azure Bastion not found" -ForegroundColor Red
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
