# -------------------------------------------------------------------------
# Program: Confirm-SftpPacketCapture.ps1
# Description: Validate packet capture lab deployment resources and prerequisites
# Context: AZ-104 Lab - Capture SFTP Packets with Network Watcher
# Author: Greg Tate
# Date: 2026-02-27
# -------------------------------------------------------------------------

[CmdletBinding()]
param()
$ResourceGroupName = 'az104-monitoring-capture-sftp-packets-bicep'
$VmName = 'vm-01'
$NetworkWatcherRegion = 'eastus'
$Main = {
    . $Helpers
    $confirmScriptPath = Join-Path $PSScriptRoot '..\..\..\..\..\.github\skills\azure-lab-governance\scripts\Confirm-LabSubscription.ps1'
    if (-not (Test-Path $confirmScriptPath)) {
        Write-Error "Confirm-LabSubscription script not found: $confirmScriptPath"
        exit 1
    }
    & $confirmScriptPath
    Write-Host ""
    Write-Host '========================================' -ForegroundColor Cyan
    Write-Host ' Validation: SFTP Packet Capture Lab' -ForegroundColor Cyan
    Write-Host '========================================' -ForegroundColor Cyan
    Write-Host ""
    $results = @()
    $results += Test-ResourceGroup
    $results += Test-VirtualMachine
    $results += Test-NetworkWatcher
    $results += Test-NetworkWatcherExtension
    $results += Test-StorageAccount
    Show-ValidationResult -Results $results
}
$Helpers = {
    function Test-ResourceGroup {
        Write-Host '[Test 1] Resource Group...' -NoNewline
        $rg = Get-AzResourceGroup -Name $ResourceGroupName -ErrorAction SilentlyContinue
        if (-not $rg) {
            Write-Host ' FAIL' -ForegroundColor Red
            return @{ Test = 'Resource Group'; Status = 'FAIL'; Detail = 'Not found' }
        }
        Write-Host ' PASS' -ForegroundColor Green
        return @{ Test = 'Resource Group'; Status = 'PASS'; Detail = "Location: $($rg.Location)" }
    }
    function Test-VirtualMachine {
        Write-Host '[Test 2] Virtual Machine...' -NoNewline
        $vm = Get-AzVM -ResourceGroupName $ResourceGroupName -Name $VmName -Status -ErrorAction SilentlyContinue
        if (-not $vm) {
            Write-Host ' FAIL' -ForegroundColor Red
            return @{ Test = 'Virtual Machine'; Status = 'FAIL'; Detail = 'Not found' }
        }
        $powerState = ($vm.Statuses | Where-Object { $_.Code -like 'PowerState/*' } | Select-Object -First 1).DisplayStatus
        Write-Host ' PASS' -ForegroundColor Green
        return @{ Test = 'Virtual Machine'; Status = 'PASS'; Detail = "State: $powerState" }
    }
    function Test-NetworkWatcher {
        Write-Host '[Test 3] Network Watcher...' -NoNewline
        $res = Get-AzResource | Where-Object {
            $_.ResourceType -eq 'Microsoft.Network/networkWatchers' -and $_.Location -eq $NetworkWatcherRegion
        }
        if (-not $res) {
            Write-Host ' FAIL' -ForegroundColor Red
            return @{ Test = 'Network Watcher'; Status = 'FAIL'; Detail = "No Network Watcher found in $NetworkWatcherRegion" }
        }
        Write-Host ' PASS' -ForegroundColor Green
        return @{ Test = 'Network Watcher'; Status = 'PASS'; Detail = "Name: $($res[0].Name)" }
    }
    function Test-NetworkWatcherExtension {
        Write-Host '[Test 4] Network Watcher Extension...' -NoNewline
        $extension = Get-AzVMExtension -ResourceGroupName $ResourceGroupName -VMName $VmName -Name 'NetworkWatcherAgentLinux' -ErrorAction SilentlyContinue
        if (-not $extension) {
            Write-Host ' FAIL' -ForegroundColor Red
            return @{ Test = 'Network Watcher Extension'; Status = 'FAIL'; Detail = 'NetworkWatcherAgentLinux not found' }
        }
        Write-Host ' PASS' -ForegroundColor Green
        return @{ Test = 'Network Watcher Extension'; Status = 'PASS'; Detail = "ProvisioningState: $($extension.ProvisioningState)" }
    }
    function Test-StorageAccount {
        Write-Host '[Test 5] Storage Account...' -NoNewline
        $storage = Get-AzStorageAccount -ResourceGroupName $ResourceGroupName -ErrorAction SilentlyContinue |
            Where-Object { $_.StorageAccountName -like 'staz104sftp*' } |
            Select-Object -First 1
        if (-not $storage) {
            Write-Host ' FAIL' -ForegroundColor Red
            return @{ Test = 'Storage Account'; Status = 'FAIL'; Detail = 'Capture storage account not found' }
        }
        $container = Get-AzStorageContainer -Context $storage.Context -Name 'packetcaptures' -ErrorAction SilentlyContinue
        if (-not $container) {
            Write-Host ' WARN' -ForegroundColor Yellow
            return @{ Test = 'Storage Account'; Status = 'WARN'; Detail = 'Storage found, packetcaptures container not found yet' }
        }
        Write-Host ' PASS' -ForegroundColor Green
        return @{ Test = 'Storage Account'; Status = 'PASS'; Detail = "Name: $($storage.StorageAccountName)" }
    }
    function Show-ValidationResult {
        param(
            [Parameter(Mandatory)]
            [array]$Results
        )
        Write-Host ""
        Write-Host '----------------------------------------'
        Write-Host ' Results Summary'
        Write-Host '----------------------------------------'
        foreach ($r in $Results) {
            $color = switch ($r.Status) {
                'PASS' { 'Green' }
                'WARN' { 'Yellow' }
                'FAIL' { 'Red' }
                default { 'White' }
            }
            Write-Host "  [$($r.Status)] $($r.Test): $($r.Detail)" -ForegroundColor $color
        }
        $passCount = ($Results | Where-Object { $_.Status -eq 'PASS' }).Count
        $totalCount = $Results.Count
        Write-Host ""
        Write-Host "  $passCount/$totalCount tests passed."
        Write-Host ""
    }
}
try {
    Push-Location -Path $PSScriptRoot
    & $Main
}
finally {
    Pop-Location
}
