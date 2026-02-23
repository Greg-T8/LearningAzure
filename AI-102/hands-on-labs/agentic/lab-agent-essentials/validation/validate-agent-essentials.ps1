<#
.SYNOPSIS
Validates Azure AI Agent Service essentials lab infrastructure and connectivity.

.DESCRIPTION
Confirms that the Foundry account, project, model deployment, and RBAC
assignments are correctly provisioned. Tests SDK connectivity to the
project endpoint by verifying the REST health check response.

.CONTEXT
AI-102 Lab - Agent Service Essentials (Threads, Files, Vector Stores)

.AUTHOR
Greg Tate

.NOTES
Program: validate-agent-essentials.ps1
#>

[CmdletBinding()]
param(
    [string]$TerraformDir = (Join-Path $PSScriptRoot '..' 'terraform')
)

# Configuration
$ExpectedSubscriptionId = 'e091f6e7-031a-4924-97bb-8c983ca5d21a'
$TestResults = @()

$Main = {
    . $Helpers

    Confirm-LabSubscription
    Get-TerraformOutput
    Test-ResourceGroup
    Test-FoundryAccount
    Test-FoundryProject
    Test-ModelDeployment
    Test-RbacAssignment
    Test-ProjectEndpoint
    Show-ValidationSummary
}

$Helpers = {

    function Confirm-LabSubscription {
        # Validate deployment to lab subscription
        $currentSubscription = (Get-AzContext).Subscription.Id

        if ($currentSubscription -ne $ExpectedSubscriptionId) {
            Write-Error "Not connected to lab subscription. Expected: $ExpectedSubscriptionId, Got: $currentSubscription"
            exit 1
        }

        Write-Host "`n[PASS] Connected to lab subscription" -ForegroundColor Green
    }

    function Get-TerraformOutput {
        # Retrieve resource identifiers from Terraform outputs
        Push-Location $TerraformDir

        try {
            $script:ResourceGroupName   = (terraform output -raw resource_group_name 2>$null)
            $script:AiFoundryName       = (terraform output -raw ai_foundry_name 2>$null)
            $script:AiFoundryEndpoint   = (terraform output -raw ai_foundry_endpoint 2>$null)
            $script:ProjectName         = (terraform output -raw project_name 2>$null)
            $script:ProjectEndpoint     = (terraform output -raw project_endpoint 2>$null)
            $script:ModelDeploymentName = (terraform output -raw model_deployment_name 2>$null)
        }
        finally {
            Pop-Location
        }

        if (-not $script:ResourceGroupName) {
            Write-Error "Failed to read Terraform outputs. Run 'terraform apply' first."
            exit 1
        }

        Write-Host "`n--- Terraform Outputs ---" -ForegroundColor Cyan
        Write-Host "  Resource Group:   $script:ResourceGroupName"
        Write-Host "  Foundry Account:  $script:AiFoundryName"
        Write-Host "  Project:          $script:ProjectName"
        Write-Host "  Model Deployment: $script:ModelDeploymentName"
        Write-Host "  Project Endpoint: $script:ProjectEndpoint"
    }

    function Test-ResourceGroup {
        # Confirm the resource group exists in the expected subscription
        Write-Host "`n--- Test: Resource Group ---" -ForegroundColor Yellow

        $rg = Get-AzResourceGroup -Name $script:ResourceGroupName -ErrorAction SilentlyContinue

        if ($rg) {
            Write-Host "  [PASS] Resource group exists: $($rg.ResourceGroupName)" -ForegroundColor Green
            Write-Host "  Location: $($rg.Location)"

            # Check required tags
            $tags = $rg.Tags
            $requiredTags = @('exam', 'domain', 'topic', 'iac_method', 'owner', 'date_created')
            $missingTags = $requiredTags | Where-Object { -not $tags.ContainsKey($_) }

            if ($missingTags.Count -eq 0) {
                Write-Host "  [PASS] All required tags present" -ForegroundColor Green
            }
            else {
                Write-Host "  [WARN] Missing tags: $($missingTags -join ', ')" -ForegroundColor Yellow
            }

            $script:TestResults += @{ Test = 'Resource Group'; Pass = $true }
        }
        else {
            Write-Host "  [FAIL] Resource group not found" -ForegroundColor Red
            $script:TestResults += @{ Test = 'Resource Group'; Pass = $false }
        }
    }

    function Test-FoundryAccount {
        # Confirm the AI Foundry account is provisioned and healthy
        Write-Host "`n--- Test: Foundry Account ---" -ForegroundColor Yellow

        $account = Get-AzCognitiveServicesAccount `
            -ResourceGroupName $script:ResourceGroupName `
            -Name $script:AiFoundryName `
            -ErrorAction SilentlyContinue

        if ($account) {
            Write-Host "  [PASS] AI Foundry account exists: $($account.AccountName)" -ForegroundColor Green
            Write-Host "  Kind:     $($account.Kind)"
            Write-Host "  SKU:      $($account.Sku.Name)"
            Write-Host "  State:    $($account.ProvisioningState)"
            Write-Host "  Endpoint: $($account.Endpoint)"

            # Verify kind is AIServices
            if ($account.Kind -eq 'AIServices') {
                Write-Host "  [PASS] Account kind is AIServices" -ForegroundColor Green
            }
            else {
                Write-Host "  [WARN] Expected kind AIServices, got $($account.Kind)" -ForegroundColor Yellow
            }

            $script:TestResults += @{ Test = 'Foundry Account'; Pass = $true }
        }
        else {
            Write-Host "  [FAIL] AI Foundry account not found" -ForegroundColor Red
            $script:TestResults += @{ Test = 'Foundry Account'; Pass = $false }
        }
    }

    function Test-FoundryProject {
        # Confirm the Foundry project is provisioned under the account
        Write-Host "`n--- Test: Foundry Project ---" -ForegroundColor Yellow

        # Resolve project by exact compound resource name first, then fallback to suffix match
        $project = Get-AzResource `
            -ResourceGroupName $script:ResourceGroupName `
            -ResourceType 'Microsoft.CognitiveServices/accounts/projects' `
            -Name "$($script:AiFoundryName)/$($script:ProjectName)" `
            -ErrorAction SilentlyContinue

        if (-not $project) {
            # Fallback for environments that return resource names in a different format
            $resources = Get-AzResource `
                -ResourceGroupName $script:ResourceGroupName `
                -ResourceType 'Microsoft.CognitiveServices/accounts/projects' `
                -ErrorAction SilentlyContinue

            $project = $resources | Where-Object {
                ($_.Name -eq "$($script:AiFoundryName)/$($script:ProjectName)") -or
                ($_.Name -like "*/$($script:ProjectName)")
            } | Select-Object -First 1
        }

        if ($project) {
            Write-Host "  [PASS] Foundry project exists: $script:ProjectName" -ForegroundColor Green
            Write-Host "  Resource ID: $($project.ResourceId)"
            $script:TestResults += @{ Test = 'Foundry Project'; Pass = $true }
        }
        else {
            Write-Host "  [FAIL] Foundry project not found" -ForegroundColor Red
            Write-Host "  Expected project: $script:ProjectName"
            $script:TestResults += @{ Test = 'Foundry Project'; Pass = $false }
        }
    }

    function Test-ModelDeployment {
        # Confirm the model deployment exists on the Foundry account
        Write-Host "`n--- Test: Model Deployment ---" -ForegroundColor Yellow

        $deployments = Get-AzCognitiveServicesAccountDeployment `
            -ResourceGroupName $script:ResourceGroupName `
            -AccountName $script:AiFoundryName `
            -ErrorAction SilentlyContinue

        $deployment = $deployments | Where-Object { $_.Name -eq $script:ModelDeploymentName }

        if ($deployment) {
            Write-Host "  [PASS] Model deployment exists: $($deployment.Name)" -ForegroundColor Green
            Write-Host "  Model:    $($deployment.Properties.Model.Name)"
            Write-Host "  Version:  $($deployment.Properties.Model.Version)"
            Write-Host "  SKU:      $($deployment.Sku.Name)"
            Write-Host "  Capacity: $($deployment.Sku.Capacity)"
            $script:TestResults += @{ Test = 'Model Deployment'; Pass = $true }
        }
        else {
            Write-Host "  [FAIL] Model deployment not found: $script:ModelDeploymentName" -ForegroundColor Red

            # List available deployments for debugging
            if ($deployments) {
                Write-Host "  Available deployments:" -ForegroundColor Yellow
                $deployments | ForEach-Object {
                    Write-Host "    - $($_.Name) ($($_.Properties.Model.Name))"
                }
            }

            $script:TestResults += @{ Test = 'Model Deployment'; Pass = $false }
        }
    }

    function Test-RbacAssignment {
        # Confirm the deployer has required RBAC roles on the Foundry account
        Write-Host "`n--- Test: RBAC Assignments ---" -ForegroundColor Yellow

        $currentUser = (Get-AzContext).Account.Id
        $currentObjectId = (Get-AzADUser -UserPrincipalName $currentUser -ErrorAction SilentlyContinue).Id

        if (-not $currentObjectId) {
            # Fallback: decode current ARM access token to obtain signed-in principal object id
            try {
                $armToken = (Get-AzAccessToken -ResourceUrl 'https://management.azure.com').Token
                $payload = $armToken.Split('.')[1].Replace('-', '+').Replace('_', '/')

                switch ($payload.Length % 4) {
                    2 { $payload += '==' }
                    3 { $payload += '=' }
                }

                $payloadJson = [System.Text.Encoding]::UTF8.GetString([System.Convert]::FromBase64String($payload))
                $currentObjectId = (ConvertFrom-Json $payloadJson).oid
            }
            catch {
                $currentObjectId = $null
            }
        }

        if (-not $currentObjectId) {
            Write-Host "  [WARN] Could not determine current user object ID" -ForegroundColor Yellow
            $script:TestResults += @{ Test = 'RBAC Assignments'; Pass = $false }
            return
        }

        # Check role assignments applicable to the account scope, including inherited scope
        $account = Get-AzCognitiveServicesAccount `
            -ResourceGroupName $script:ResourceGroupName `
            -Name $script:AiFoundryName

        $assignments = Get-AzRoleAssignment `
            -ObjectId $currentObjectId `
            -ErrorAction SilentlyContinue | Where-Object {
                $account.Id.StartsWith($_.Scope, [System.StringComparison]::OrdinalIgnoreCase)
            }

        $requiredRoles = @('Cognitive Services User', 'Cognitive Services Contributor')
        $assignedRoles = $assignments.RoleDefinitionName

        foreach ($role in $requiredRoles) {
            if ($assignedRoles -contains $role) {
                Write-Host "  [PASS] Role assigned: $role" -ForegroundColor Green
            }
            else {
                Write-Host "  [WARN] Role not found: $role" -ForegroundColor Yellow
            }
        }

        # At least one required role must be assigned
        $hasRole = $requiredRoles | Where-Object { $assignedRoles -contains $_ }

        if ($hasRole) {
            $script:TestResults += @{ Test = 'RBAC Assignments'; Pass = $true }
        }
        else {
            Write-Host "  [FAIL] No required RBAC roles assigned" -ForegroundColor Red
            $script:TestResults += @{ Test = 'RBAC Assignments'; Pass = $false }
        }
    }

    function Test-ProjectEndpoint {
        # Verify the project endpoint is reachable via REST
        Write-Host "`n--- Test: Project Endpoint ---" -ForegroundColor Yellow

        if (-not $script:ProjectEndpoint) {
            Write-Host "  [FAIL] Project endpoint not set" -ForegroundColor Red
            $script:TestResults += @{ Test = 'Project Endpoint'; Pass = $false }
            return
        }

        Write-Host "  Endpoint: $script:ProjectEndpoint"

        # Get an access token for the cognitive services audience
        try {
            $token = (Get-AzAccessToken -ResourceUrl 'https://cognitiveservices.azure.com').Token

            # Test the endpoint with a simple GET request
            $headers = @{
                'Authorization' = "Bearer $token"
                'Content-Type'  = 'application/json'
            }

            $null = Invoke-RestMethod `
                -Uri "$($script:ProjectEndpoint)?api-version=2024-07-01-preview" `
                -Headers $headers `
                -Method Get `
                -ErrorAction Stop

            Write-Host "  [PASS] Project endpoint responded successfully" -ForegroundColor Green
            $script:TestResults += @{ Test = 'Project Endpoint'; Pass = $true }
        }
        catch {
            $statusCode = $null

            if ($_.Exception.Response -and $_.Exception.Response.StatusCode) {
                $statusCode = $_.Exception.Response.StatusCode.value__
            }

            # A 401/403 means the endpoint exists but we need additional permissions
            # A 404 on this probe route still confirms host reachability for project endpoint DNS/path
            if ($statusCode -in @(401, 403, 404)) {
                Write-Host "  [WARN] Endpoint reachable but returned $statusCode" -ForegroundColor Yellow
                Write-Host "  This is expected for this lightweight connectivity probe"
                $script:TestResults += @{ Test = 'Project Endpoint'; Pass = $true }
            }
            else {
                Write-Host "  [FAIL] Endpoint unreachable: $($_.Exception.Message)" -ForegroundColor Red
                $script:TestResults += @{ Test = 'Project Endpoint'; Pass = $false }
            }
        }
    }

    function Show-ValidationSummary {
        # Display a summary of all validation results
        Write-Host "`n$('='*60)" -ForegroundColor Cyan
        Write-Host "  VALIDATION SUMMARY" -ForegroundColor Cyan
        Write-Host "$('='*60)" -ForegroundColor Cyan

        $passCount = ($script:TestResults | Where-Object { $_.Pass }).Count
        $failCount = ($script:TestResults | Where-Object { -not $_.Pass }).Count
        $totalCount = $script:TestResults.Count

        foreach ($result in $script:TestResults) {
            $status = if ($result.Pass) { '[PASS]' } else { '[FAIL]' }
            $color  = if ($result.Pass) { 'Green' } else { 'Red' }
            Write-Host "  $status $($result.Test)" -ForegroundColor $color
        }

        Write-Host "`n  Results: $passCount/$totalCount passed" -ForegroundColor Cyan

        if ($failCount -gt 0) {
            Write-Host "  $failCount test(s) failed — review output above" -ForegroundColor Red
        }
        else {
            Write-Host "  All tests passed! Lab infrastructure is ready." -ForegroundColor Green
            Write-Host "`n  Next steps:" -ForegroundColor Cyan
            Write-Host "    1. cd ../scripts"
            Write-Host "    2. pip install -r requirements.txt"
            Write-Host '    3. $env:PROJECT_ENDPOINT = terraform output -raw project_endpoint'
            Write-Host '    4. $env:MODEL_DEPLOYMENT_NAME = terraform output -raw model_deployment_name'
            Write-Host "    5. python 01_basic_agent.py"
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
