#!/usr/bin/env powershell
# PowerShell deployment script for mixed OS VMs on vSphere

param(
    [Parameter(Mandatory=$false)]
    [string]$Action = "plan",
    
    [Parameter(Mandatory=$false)]
    [switch]$AutoApprove = $false
)

Write-Host "=== Mixed OS VM Deployment on vSphere ===" -ForegroundColor Green
Write-Host "Action: $Action" -ForegroundColor Yellow

# Check if terraform.tfvars exists
if (-not (Test-Path "terraform.tfvars")) {
    Write-Host "terraform.tfvars not found. Creating from example..." -ForegroundColor Yellow
    if (Test-Path "terraform.tfvars.example") {
        Copy-Item "terraform.tfvars.example" "terraform.tfvars"
        Write-Host "Please edit terraform.tfvars with your environment details before proceeding." -ForegroundColor Red
        exit 1
    } else {
        Write-Host "terraform.tfvars.example not found. Please create terraform.tfvars manually." -ForegroundColor Red
        exit 1
    }
}

# Initialize Terraform if needed
if (-not (Test-Path ".terraform")) {
    Write-Host "Initializing Terraform..." -ForegroundColor Cyan
    terraform init
    if ($LASTEXITCODE -ne 0) {
        Write-Host "Terraform initialization failed!" -ForegroundColor Red
        exit 1
    }
}

# Validate configuration
Write-Host "Validating Terraform configuration..." -ForegroundColor Cyan
terraform validate
if ($LASTEXITCODE -ne 0) {
    Write-Host "Terraform validation failed!" -ForegroundColor Red
    exit 1
}

# Format code
Write-Host "Formatting Terraform code..." -ForegroundColor Cyan
terraform fmt

# Execute the specified action
switch ($Action.ToLower()) {
    "plan" {
        Write-Host "Creating Terraform plan..." -ForegroundColor Cyan
        terraform plan -out=tfplan
    }
    "apply" {
        Write-Host "Applying Terraform configuration..." -ForegroundColor Cyan
        if ($AutoApprove) {
            terraform apply -auto-approve
        } else {
            terraform apply tfplan
        }
        
        if ($LASTEXITCODE -eq 0) {
            Write-Host "Deployment completed successfully!" -ForegroundColor Green
            Write-Host "Getting VM information..." -ForegroundColor Cyan
            terraform output
        }
    }
    "destroy" {
        Write-Host "Destroying infrastructure..." -ForegroundColor Red
        if ($AutoApprove) {
            terraform destroy -auto-approve
        } else {
            terraform destroy
        }
    }
    "output" {
        Write-Host "Displaying outputs..." -ForegroundColor Cyan
        terraform output
    }
    "show" {
        Write-Host "Showing current state..." -ForegroundColor Cyan
        terraform show
    }
    default {
        Write-Host "Invalid action. Supported actions: plan, apply, destroy, output, show" -ForegroundColor Red
        exit 1
    }
}

Write-Host "Script execution completed." -ForegroundColor Green