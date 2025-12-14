# Setup script for Bicep MCP Server local development
# This script clones the Bicep repository and builds the MCP server

$ErrorActionPreference = "Stop"

$ScriptDir = Split-Path -Parent $MyInvocation.MyCommand.Path
$ProjectDir = Split-Path -Parent $ScriptDir
$BicepDir = Join-Path $ProjectDir "bicep"
$McpServerProject = "src/Bicep.McpServer/Bicep.McpServer.csproj"

Write-Host "=== Bicep MCP Server Setup ===" -ForegroundColor Cyan
Write-Host ""

# Check for .NET SDK
try {
    $dotnetVersion = dotnet --version
    Write-Host "✓ .NET SDK found: $dotnetVersion" -ForegroundColor Green
}
catch {
    Write-Host "ERROR: .NET SDK is not installed." -ForegroundColor Red
    Write-Host "Please install .NET 10.0 SDK from: https://dotnet.microsoft.com/download/dotnet/10.0"
    exit 1
}

# Check for git
try {
    git --version | Out-Null
    Write-Host "✓ Git found" -ForegroundColor Green
}
catch {
    Write-Host "ERROR: Git is not installed." -ForegroundColor Red
    exit 1
}

# Clone or update repository
if (Test-Path $BicepDir) {
    Write-Host ""
    Write-Host "Bicep repository already exists. Updating..."
    Push-Location $BicepDir
    git pull
    Pop-Location
}
else {
    Write-Host ""
    Write-Host "Cloning Bicep repository..."
    git clone https://github.com/Azure/bicep.git $BicepDir
}

Write-Host ""
Write-Host "Building Bicep MCP Server..."
Push-Location $BicepDir
dotnet build $McpServerProject -c Release
Pop-Location

# Find the built DLL
$McpServerDll = Get-ChildItem -Path (Join-Path $BicepDir "src/Bicep.McpServer/bin/Release") -Filter "Bicep.McpServer.dll" -Recurse | Select-Object -First 1

if (-not $McpServerDll) {
    Write-Host "ERROR: Could not find Bicep.McpServer.dll" -ForegroundColor Red
    exit 1
}

$McpServerPath = $McpServerDll.FullName
$McpServerPathEscaped = $McpServerPath -replace '\\', '\\\\'

Write-Host @"

=== Setup Complete ===

MCP Server location:
  $McpServerPath

To run the server:
  dotnet "$McpServerPath"

For Claude Desktop, add to claude_desktop_config.json:
{
  "mcpServers": {
    "bicep": {
      "command": "dotnet",
      "args": ["$McpServerPathEscaped"]
    }
  }
}

For Claude Code, run:
  claude mcp add --transport stdio bicep --scope user -- dotnet "$McpServerPath"

For Codex CLI, run:
  codex mcp add bicep -- dotnet "$McpServerPath"
"@
