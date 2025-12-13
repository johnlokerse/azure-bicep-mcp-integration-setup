# Azure Bicep MCP Server (Experimental) Integrations with other services

This guide explains how to run the Azure Bicep MCP server locally for Claude Desktop and Code, and for LMStudio where you can use it with various models.

See the Claude Code example:

![Claude Code Calling Bicep MCP Server](images/ClaudeCodeCallingBicepMCP.png)

## Overview

The Bicep MCP (Model Context Protocol) server provides AI agents with tools to help generate high-quality Bicep code. It exposes the following tools:

- `list_az_resource_types_for_provider` - Lists all available Azure resource types for a specific provider
- `get_az_resource_type_schema` - Gets the schema for a specific Azure resource type and API version
- `get_bicep_best_practices` - Returns Bicep best practices and guidelines
- `list_avm_metadata` - Lists metadata for all Azure Verified Modules (AVM)

Checkout the [Bicep MCP Server Documentation](https://github.com/Azure/bicep/blob/main/docs/experimental/mcp-tools.md) for more information.

## Client Setup Guides

- **[Claude Code Setup](docs/claude-code-setup.md)** - Configure the MCP server for Claude Code (CLI)
- **[Claude Desktop Setup](docs/claude-desktop-setup.md)** - Configure the MCP server for Claude Desktop
- **[LMStudio Setup](docs/lmstudio-setup.md)** - Configure the MCP server for LMStudio
- **GitHub Copilot Setup**: Recommended to use the Azure Bicep extension's built-in MCP support.

## Quick Start (Recommended)

Use the provided PowerShell scripts for the fastest setup:

```powershell
# 1. Run the setup script (clones repo and builds)
./scripts/Setup-BicepMCP.ps1

# 2. Run the MCP server
./scripts/Run-BicepMCP.ps1

# 3. To update later
./scripts/Update-BicepRepo.ps1
```

Running the MCP server (#2) is not required because you reference the build DLL from the Azure Bicep project.

## Prerequisites

- [.NET 9.0 SDK](https://dotnet.microsoft.com/download/dotnet/9.0) or later (tested with .NET 10.0)
- Git (for cloning the repository)

## Option 1: Build from Source (Recommended for Easy Updates)

This approach clones the Bicep repository and builds the MCP server. Updates are as simple as `git pull` and rebuild.

### Initial Setup

```bash
# Clone the Bicep repository
git clone https://github.com/Azure/bicep.git
cd bicep

# Build the MCP server
dotnet build src/Bicep.McpServer/Bicep.McpServer.csproj -c Release
```

### Running the Server

```bash
# Run the MCP server (uses stdio transport)
dotnet run --project src/Bicep.McpServer/Bicep.McpServer.csproj -c Release --no-build
```

Or run the built DLL directly (path may vary based on .NET version):

```bash
# Find the DLL
find src/Bicep.McpServer/bin/Release -name "Bicep.McpServer.dll"

# Run it
dotnet ./src/Bicep.McpServer/bin/Release/net10.0/Bicep.McpServer.dll
```

### Updating

```bash
# Pull latest changes
git pull

# Rebuild
dotnet build src/Bicep.McpServer/Bicep.McpServer.csproj -c Release
```

## Option 2: Extract from VS Code Extension

If you already have the Bicep VS Code extension installed, you can use the MCP server DLL directly from it.

### Locate the Extension

The extension is typically installed at:

- **macOS**: `~/.vscode/extensions/ms-azuretools.vscode-bicep-<version>/`
- **Linux**: `~/.vscode/extensions/ms-azuretools.vscode-bicep-<version>/`
- **Windows**: `%USERPROFILE%\.vscode\extensions\ms-azuretools.vscode-bicep-<version>\`

The MCP server is located at: `bicepMcpServer/Bicep.McpServer.dll`

### Running from Extension

```bash
# Find your extension version
ls ~/.vscode/extensions/ | grep vscode-bicep

# Run the MCP server (replace <version> with your actual version)
dotnet ~/.vscode/extensions/ms-azuretools.vscode-bicep-<version>/bicepMcpServer/Bicep.McpServer.dll
```

## Helper Scripts

The following PowerShell scripts are provided to simplify setup and maintenance:

| Script                                               | Description                                                                                                                                            |
| ---------------------------------------------------- | ------------------------------------------------------------------------------------------------------------------------------------------------------ |
| [Setup-BicepMCP.ps1](scripts/Setup-BicepMCP.ps1)     | Clones the Bicep repository (if not already present) and builds the MCP server. Outputs configuration instructions for Claude Desktop and Claude Code. |
| [Update-BicepRepo.ps1](scripts/Update-BicepRepo.ps1) | Pulls the latest changes from the Bicep repository and rebuilds the MCP server.                                                                        |
| [Run-BicepMCP.ps1](scripts/Run-BicepMCP.ps1)         | Starts the Bicep MCP server using stdio transport.                                                                                                     |

## Verifying the Server Works

You can test the server is working by sending a simple MCP initialization message. The server expects JSON-RPC messages over stdio.

### Quick Test

```bash
# The server will start and wait for MCP protocol messages via stdin
dotnet /path/to/Bicep.McpServer.dll
```

If the server starts without errors, it's ready to receive MCP protocol messages from a client.

## Troubleshooting

### "dotnet: command not found"

Ensure the .NET SDK is installed and in your PATH:

```bash
# Check .NET version
dotnet --version

# If not found, install from https://dotnet.microsoft.com/download
```

### Build Errors

Make sure you're using .NET 9.0 or later:

```bash
dotnet --list-sdks
```

### Server Doesn't Respond

The MCP server uses stdio transport. It won't produce output until it receives valid MCP protocol messages from a client.

## How It Works

The Bicep MCP server:

1. Uses the [Model Context Protocol](https://modelcontextprotocol.io/) for AI agent integrations
2. Communicates via **stdio** (standard input/output)
3. Provides tools for Azure resource type information and Bicep best practices
4. Is built on .NET 9.0 using Microsoft's MCP SDK

## References

- [Azure Bicep Repository](https://github.com/Azure/bicep)
- [Bicep MCP Server Documentation](https://github.com/Azure/bicep/blob/main/docs/experimental/mcp-tools.md)
- [Model Context Protocol](https://modelcontextprotocol.io/)
