# Update script for Bicep MCP Server
# Pulls latest changes and rebuilds the server

$ErrorActionPreference = "Stop"

$ScriptDir = Split-Path -Parent $MyInvocation.MyCommand.Path
$ProjectDir = Split-Path -Parent $ScriptDir
$BicepDir = Join-Path $ProjectDir "bicep"
$McpServerProject = "src/Bicep.McpServer/Bicep.McpServer.csproj"

if (-not (Test-Path $BicepDir)) {
    Write-Host "ERROR: Bicep repository not found at $BicepDir" -ForegroundColor Red
    Write-Host "Please run setup.ps1 first."
    exit 1
}

Write-Host "=== Updating Bicep MCP Server ===" -ForegroundColor Cyan
Write-Host ""

Push-Location $BicepDir

# Get current version
$OldCommit = git rev-parse --short HEAD
Write-Host "Current commit: $OldCommit"

# Pull latest
Write-Host "Pulling latest changes..."
git pull

$NewCommit = git rev-parse --short HEAD
Write-Host "New commit: $NewCommit"

if ($OldCommit -eq $NewCommit) {
    Write-Host ""
    Write-Host "Already up to date!" -ForegroundColor Green
} else {
    Write-Host ""
    Write-Host "Rebuilding MCP Server..."
    dotnet build $McpServerProject -c Release
    
    Write-Host ""
    Write-Host "=== Update Complete ===" -ForegroundColor Cyan
}

Pop-Location

# Find the built DLL
$McpServerDll = Get-ChildItem -Path (Join-Path $BicepDir "src/Bicep.McpServer/bin/Release") -Filter "Bicep.McpServer.dll" -Recurse | Select-Object -First 1

if ($McpServerDll) {
    Write-Host ""
    Write-Host "MCP Server location: $($McpServerDll.FullName)" -ForegroundColor Yellow
}
