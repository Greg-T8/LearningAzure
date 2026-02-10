# -------------------------------------------------------------------------
# Program: test-dalle-generation.ps1
# Description: Test DALL-E 3 image generation with various sizes and formats
# Context: AI-102 Lab - Generate and manipulate images with DALL-E
# Author: Greg Tate
# Date: 2026-02-10
# -------------------------------------------------------------------------

<#
.SYNOPSIS
    Tests DALL-E 3 image generation capabilities including size options and format analysis.

.DESCRIPTION
    This script demonstrates:
    1. Generating images with DALL-E 3 using the Azure OpenAI API
    2. Testing different image sizes (1024x1024, 1792x1024, 1024x1792)
    3. Analyzing the format of generated images (PNG vs JPEG)
    4. Saving generated images locally

.EXAMPLE
    .\test-dalle-generation.ps1 -Endpoint "https://oai-dalle-abc123.openai.azure.com/" -ApiKey "your-api-key" -DeploymentName "deploy-dalle3"
#>

param(
    [Parameter(Mandatory = $false)]
    [string]$Endpoint,

    [Parameter(Mandatory = $false)]
    [string]$ApiKey,

    [Parameter(Mandatory = $false)]
    [string]$DeploymentName,

    [Parameter(Mandatory = $false)]
    [string]$OutputDir = ".\generated-images"
)

$Main = {
    # Initialize script configuration and test DALL-E 3 image generation
    Initialize-Configuration
    Test-DalleGeneration
    Show-ExamAnswerSummary
}

$Helpers = {
    function Initialize-Configuration {
        # Retrieve Azure OpenAI configuration from Terraform outputs if not provided
        if (-not $script:Endpoint -or -not $script:ApiKey -or -not $script:DeploymentName) {
            Write-Host "Retrieving configuration from Terraform outputs..." -ForegroundColor Cyan

            Push-Location "..\terraform"
            try {
                $script:Endpoint = terraform output -raw openai_endpoint
                $script:ApiKey = terraform output -raw openai_primary_key
                $script:DeploymentName = terraform output -raw image_deployment_name
            }
            finally {
                Pop-Location
            }
        }

        # Convert output directory to absolute path
        $script:OutputDir = $ExecutionContext.SessionState.Path.GetUnresolvedProviderPathFromPSPath($script:OutputDir)

        # Create output directory for generated images
        if (-not (Test-Path $script:OutputDir)) {
            New-Item -ItemType Directory -Path $script:OutputDir | Out-Null
        }

        # Configure API version and base URL
        $script:apiVersion = "2024-02-15-preview"
        $script:apiUrl = "$($script:Endpoint)/openai/deployments/$($script:DeploymentName)/images/generations?api-version=$($script:apiVersion)"
    }

    function Test-DalleGeneration {
        # Define test cases for different image sizes
        $testCases = @(
            @{
                Name   = "Standard 1024x1024"
                Size   = "1024x1024"
                Prompt = "A serene mountain landscape at sunset with a crystal-clear lake reflecting the sky"
            },
            @{
                Name   = "Wide 1792x1024"
                Size   = "1792x1024"
                Prompt = "A futuristic city skyline with flying cars and neon lights"
            },
            @{
                Name   = "Tall 1024x1792"
                Size   = "1024x1792"
                Prompt = "A tall lighthouse on a rocky cliff overlooking the ocean during a storm"
            }
        )

        # Display test header
        Write-Host "`n=== DALL-E 3 Image Generation Test ===" -ForegroundColor Green
        Write-Host "Endpoint: $($script:Endpoint)" -ForegroundColor Gray
        Write-Host "Deployment: $($script:DeploymentName)" -ForegroundColor Gray
        Write-Host ""

        # Test each image size configuration
        foreach ($test in $testCases) {
            Write-Host "Testing: $($test.Name)" -ForegroundColor Cyan
            Write-Host "  Size: $($test.Size)" -ForegroundColor Gray
            Write-Host "  Prompt: $($test.Prompt)" -ForegroundColor Gray

            # Build request body
            $body = @{
                prompt  = $test.Prompt
                size    = $test.Size
                n       = 1
                quality = "standard"
                style   = "vivid"
            } | ConvertTo-Json

            # Set request headers
            $headers = @{
                "api-key"      = $script:ApiKey
                "Content-Type" = "application/json"
            }

            try {
                # Call DALL-E API to generate image
                $response = Invoke-RestMethod -Method Post -Uri $script:apiUrl -Headers $headers -Body $body

                # Extract image URL from response
                $imageUrl = $response.data[0].url

                Write-Host "  Status: Success" -ForegroundColor Green
                Write-Host "  Image URL: $imageUrl" -ForegroundColor Gray

                # Download and save generated image
                $fileName = "dalle_$($test.Size.Replace('x', '_'))_$(Get-Date -Format 'yyyyMMdd_HHmmss').png"
                $filePath = Join-Path $script:OutputDir $fileName

                Invoke-WebRequest -Uri $imageUrl -OutFile $filePath

                Write-Host "  Saved: $filePath" -ForegroundColor Green

                # Verify image format by analyzing file header bytes
                $fileBytes = [System.IO.File]::ReadAllBytes($filePath)
                $isPng = $fileBytes[0] -eq 0x89 -and $fileBytes[1] -eq 0x50 -and $fileBytes[2] -eq 0x4E -and $fileBytes[3] -eq 0x47
                $isJpeg = $fileBytes[0] -eq 0xFF -and $fileBytes[1] -eq 0xD8

                # Display detected format
                if ($isPng) {
                    Write-Host "  Format: PNG (verified)" -ForegroundColor Yellow
                }
                elseif ($isJpeg) {
                    Write-Host "  Format: JPEG (verified)" -ForegroundColor Yellow
                }
                else {
                    Write-Host "  Format: Unknown" -ForegroundColor Red
                }

                Write-Host ""
            }
            catch {
                Write-Host "  Status: Failed" -ForegroundColor Red
                Write-Host "  Error: $($_.Exception.Message)" -ForegroundColor Red
                Write-Host ""
            }

            # Rate limiting delay between requests
            Start-Sleep -Seconds 2
        }

        # Display completion message
        Write-Host "Generated images saved to: $($script:OutputDir)" -ForegroundColor Green
    }

    function Show-ExamAnswerSummary {
        # Display exam question analysis and answers
        Write-Host "`n=== Exam Question Analysis ===" -ForegroundColor Green
        Write-Host ""
        Write-Host "Statement 1: Prefilled Python code reflecting your settings is available" -ForegroundColor Cyan
        Write-Host "  Answer: YES - Azure AI Foundry portal provides code snippets in multiple languages" -ForegroundColor Green
        Write-Host ""
        Write-Host "Statement 2: You can set the size of the generated images to 1024x1024" -ForegroundColor Cyan
        Write-Host "  Answer: YES - DALL-E 3 supports 1024x1024, 1792x1024, and 1024x1792" -ForegroundColor Green
        Write-Host ""
        Write-Host "Statement 3: You can save generated images in JPEG format" -ForegroundColor Cyan
        Write-Host "  Answer: NO - DALL-E 3 generates images in PNG format only" -ForegroundColor Yellow
        Write-Host "  Note: You can convert PNG to JPEG after download if needed" -ForegroundColor Gray
        Write-Host ""
    }
}

try {
    Push-Location -Path $PSScriptRoot
    . $Helpers
    & $Main
}
finally {
    Pop-Location
}
