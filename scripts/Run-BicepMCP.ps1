# Run the Bicep MCP Server

$ScriptDir = Split-Path -Parent $MyInvocation.MyCommand.Path
$ProjectDir = Split-Path -Parent $ScriptDir
$BicepDir = Join-Path $ProjectDir "bicep"

# Find the built DLL
$McpServerDll = Get-ChildItem -Path (Join-Path $BicepDir "src/Bicep.McpServer/bin/Release") -Filter "Azure.Bicep.McpServer.dll" -Recurse -ErrorAction SilentlyContinue | Select-Object -First 1

if (-not $McpServerDll) {
    Write-Host "ERROR: MCP Server not found." -ForegroundColor Red
    Write-Host "Please run setup.ps1 first."
    exit 1
}

& dotnet $McpServerDll.FullName
