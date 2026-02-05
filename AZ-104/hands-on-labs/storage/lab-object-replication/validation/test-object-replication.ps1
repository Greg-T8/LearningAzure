# -------------------------------------------------------------------------
# Program: test-object-replication.ps1
# Description: Validation script for Azure Storage object replication lab
# Context: AZ-104 Lab - Configure object replication between storage accounts
# Author: Greg Tate
# Date: 2026-02-05
# -------------------------------------------------------------------------

param(
    [Parameter(Mandatory = $false)]
    [string]$ResourceGroupName
)

# Set error action preference
$ErrorActionPreference = "Stop"

Write-Host "==================================="  -ForegroundColor Cyan
Write-Host "Object Replication Lab Validation"  -ForegroundColor Cyan
Write-Host "==================================="  -ForegroundColor Cyan
Write-Host ""

# Get resource group name from Terraform output if not provided
if (-not $ResourceGroupName) {
    Push-Location ../terraform
    $ResourceGroupName = terraform output -raw resource_group_name 2>$null

    if ($LASTEXITCODE -ne 0) {
        Write-Host "❌ Could not get resource group name from Terraform output" -ForegroundColor Red
        Write-Host "   Please run 'terraform apply' first or provide -ResourceGroupName parameter" -ForegroundColor Yellow
        Pop-Location
        exit 1
    }
    Pop-Location
}

Write-Host "Resource Group: $ResourceGroupName" -ForegroundColor Green

# Get resource group information
try {
    $rg = az group show --name $ResourceGroupName | ConvertFrom-Json
    Write-Host "✓ Resource group exists in $($rg.location)" -ForegroundColor Green
}
catch {
    Write-Host "❌ Resource group not found" -ForegroundColor Red
    exit 1
}

# Get storage accounts in the resource group
Write-Host "`nGetting storage accounts..." -ForegroundColor Cyan
$storageAccounts = az storage account list --resource-group $ResourceGroupName | ConvertFrom-Json

if ($storageAccounts.Count -lt 2) {
    Write-Host "❌ Expected 2 storage accounts, found $($storageAccounts.Count)" -ForegroundColor Red
    exit 1
}

Write-Host "✓ Found $($storageAccounts.Count) storage accounts" -ForegroundColor Green

# Identify source and destination accounts
$sourceAccount = $storageAccounts | Where-Object { $_.name -like "stsource*" } | Select-Object -First 1
$destAccount = $storageAccounts | Where-Object { $_.name -like "stdest*" } | Select-Object -First 1

if (-not $sourceAccount -or -not $destAccount) {
    Write-Host "❌ Could not identify source and destination accounts" -ForegroundColor Red
    exit 1
}

Write-Host "  Source: $($sourceAccount.name) ($($sourceAccount.location))" -ForegroundColor White
Write-Host "  Destination: $($destAccount.name) ($($destAccount.location))" -ForegroundColor White

# Check blob properties on source account
Write-Host "`nValidating source account configuration..." -ForegroundColor Cyan
$sourceProps = az storage account blob-service-properties show `
    --account-name $sourceAccount.name `
    --resource-group $ResourceGroupName | ConvertFrom-Json

if ($sourceProps.isVersioningEnabled -eq $true) {
    Write-Host "✓ Source account has blob versioning enabled" -ForegroundColor Green
}
else {
    Write-Host "❌ Source account does NOT have blob versioning enabled" -ForegroundColor Red
}

# Check blob properties on destination account
Write-Host "`nValidating destination account configuration..." -ForegroundColor Cyan
$destProps = az storage account blob-service-properties show `
    --account-name $destAccount.name `
    --resource-group $ResourceGroupName | ConvertFrom-Json

if ($destProps.isVersioningEnabled -eq $true) {
    Write-Host "✓ Destination account has blob versioning enabled" -ForegroundColor Green
}
else {
    Write-Host "❌ Destination account does NOT have blob versioning enabled" -ForegroundColor Red
}

if ($destProps.changeFeed.enabled -eq $true) {
    Write-Host "✓ Destination account has change feed enabled" -ForegroundColor Green
}
else {
    Write-Host "❌ Destination account does NOT have change feed enabled" -ForegroundColor Red
}

# Check containers
Write-Host "`nValidating containers..." -ForegroundColor Cyan
$sourceContainers = az storage container list `
    --account-name $sourceAccount.name `
    --auth-mode login 2>$null | ConvertFrom-Json

if ($sourceContainers.Count -gt 0) {
    Write-Host "✓ Source account has $($sourceContainers.Count) container(s):" -ForegroundColor Green
    foreach ($container in $sourceContainers) {
        Write-Host "    - $($container.name)" -ForegroundColor White
    }
}
else {
    Write-Host "⚠ Source account has no containers" -ForegroundColor Yellow
}

$destContainers = az storage container list `
    --account-name $destAccount.name `
    --auth-mode login 2>$null | ConvertFrom-Json

if ($destContainers.Count -gt 0) {
    Write-Host "✓ Destination account has $($destContainers.Count) container(s):" -ForegroundColor Green
    foreach ($container in $destContainers) {
        Write-Host "    - $($container.name)" -ForegroundColor White
    }
}
else {
    Write-Host "⚠ Destination account has no containers" -ForegroundColor Yellow
}

# Check object replication policies
Write-Host "`nChecking object replication policies..." -ForegroundColor Cyan

try {
    $sourcePolicy = az storage account or-policy list `
        --account-name $sourceAccount.name `
        --resource-group $ResourceGroupName 2>$null | ConvertFrom-Json

    if ($sourcePolicy -and $sourcePolicy.Count -gt 0) {
        Write-Host "✓ Source account has $($sourcePolicy.Count) replication policy/policies" -ForegroundColor Green
    }
    else {
        Write-Host "⚠ Source account has no replication policies configured" -ForegroundColor Yellow
        Write-Host "  Run Azure CLI commands to configure object replication" -ForegroundColor Yellow
    }
}
catch {
    Write-Host "⚠ Could not check source replication policies" -ForegroundColor Yellow
}

try {
    $destPolicy = az storage account or-policy list `
        --account-name $destAccount.name `
        --resource-group $ResourceGroupName 2>$null | ConvertFrom-Json

    if ($destPolicy -and $destPolicy.Count -gt 0) {
        Write-Host "✓ Destination account has $($destPolicy.Count) replication policy/policies" -ForegroundColor Green
    }
    else {
        Write-Host "⚠ Destination account has no replication policies configured" -ForegroundColor Yellow
        Write-Host "  Run Azure CLI commands to configure object replication" -ForegroundColor Yellow
    }
}
catch {
    Write-Host "⚠ Could not check destination replication policies" -ForegroundColor Yellow
}

# Summary
Write-Host "`n==================================="  -ForegroundColor Cyan
Write-Host "Validation Summary"  -ForegroundColor Cyan
Write-Host "==================================="  -ForegroundColor Cyan

$checks = @{
    "Resource group exists"                    = $true
    "Two storage accounts exist"               = ($storageAccounts.Count -eq 2)
    "Source has blob versioning"               = ($sourceProps.isVersioningEnabled -eq $true)
    "Destination has blob versioning"          = ($destProps.isVersioningEnabled -eq $true)
    "Destination has change feed"              = ($destProps.changeFeed.enabled -eq $true)
    "Containers exist"                         = (($sourceContainers.Count -gt 0) -and ($destContainers.Count -gt 0))
}

$passed = 0
$total = $checks.Count

foreach ($check in $checks.GetEnumerator()) {
    if ($check.Value) {
        Write-Host "✓ $($check.Key)" -ForegroundColor Green
        $passed++
    }
    else {
        Write-Host "❌ $($check.Key)" -ForegroundColor Red
    }
}

Write-Host "`nPassed: $passed / $total checks" -ForegroundColor $(if ($passed -eq $total) { "Green" } else { "Yellow" })

if ($passed -eq $total) {
    Write-Host "`n✓ All validation checks passed!" -ForegroundColor Green
    Write-Host "  Infrastructure is correctly configured for object replication" -ForegroundColor Green
    exit 0
}
else {
    Write-Host "`n⚠ Some validation checks failed" -ForegroundColor Yellow
    Write-Host "  Review the output above and fix any issues" -ForegroundColor Yellow
    exit 1
}
