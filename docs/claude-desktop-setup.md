# Using Bicep MCP Server with Claude Desktop

This guide explains how to configure and use the Azure Bicep MCP server with Claude Desktop.

![Claude Desktop Calling Bicep MCP Server](../images/ClaudeDesktopCallingBicepMCP.png)

## Prerequisites

- [Claude Desktop](https://claude.ai/download) installed
- [.NET 10.0 SDK](https://dotnet.microsoft.com/en-us/download/dotnet/10.0?WT.mc_id=MVP_323261) or later
- Bicep MCP Server available via one of the options in [README.md](../README.md#options)

## Quick Setup

### 1. Find Your Configuration File

Open the Claude Desktop configuration file:

| Platform    | Location                                                          |
| ----------- | ----------------------------------------------------------------- |
| **macOS**   | `~/Library/Application Support/Claude/claude_desktop_config.json` |
| **Windows** | `%APPDATA%\Claude\claude_desktop_config.json`                     |

### 2. Add the Bicep MCP Server

Edit the configuration file and add one of the following snippets:

#### Quick Option 1 (recommended): Use dnx

```json
{
  "mcpServers": {
    "bicep": {
      "command": "dnx",
      "args": [
        "Azure.Bicep.McpServer",
        "--yes"
      ]
    }
  }
}
```

#### Quick Option 2: Use a local DLL

```json
{
  "mcpServers": {
    "bicep": {
      "command": "dotnet",
      "args": [
        "Path to your Bicep.McpServer.dll"
      ]
    }
  }
}
```

> **Important**: Replace the path with your actual path to `Bicep.McpServer.dll`

If you use the VS Code extension method, the path may look like this:

```bash
~/.vscode/extensions/ms-azuretools.vscode-bicep-0.39.26/bicepMcpServer/Bicep.McpServer.dll
```

### 3. Restart Claude Desktop

Quit and reopen Claude Desktop for the changes to take effect.

## Step-by-Step Setup

### 1. Find Your MCP Server Path

Only use this step if you are using Option 2 or 3 from the [README.md](../README.md#options) to get the Bicep MCP server DLL.

```bash
# Navigate to your project
cd <Path to your cloned azure-bicep-mcp-local repository>

# Find the built DLL
find bicep/src/Bicep.McpServer/bin/Release -name "Bicep.McpServer.dll"
```

### 2. Open the Configuration File

#### macOS

```bash
# Create the directory if it doesn't exist
mkdir -p ~/Library/Application\ Support/Claude

# Open the config file (creates it if it doesn't exist)
open -e ~/Library/Application\ Support/Claude/claude_desktop_config.json
```

Or use VS Code:

```bash
code ~/Library/Application\ Support/Claude/claude_desktop_config.json
```

#### Windows

```powershell
# Open in VS Code
code $env:APPDATA\Claude\claude_desktop_config.json
```

### 3. Configure the MCP Server

If the file is empty or doesn't exist, create it with one of the following options:

#### Option 1 (recommended): Use dnx

```json
{
  "mcpServers": {
    "bicep": {
      "command": "dnx",
      "args": [
        "Azure.Bicep.McpServer",
        "--yes"
      ]
    }
  }
}
```

#### Option 2 & 3: Use a local DLL

```json
{
  "mcpServers": {
    "bicep": {
      "command": "dotnet",
      "args": [
        "/Users/<user>/Documents/Repositories/azure-bicep-mcp-local-experiment/bicep/src/Bicep.McpServer/bin/Release/net10.0/Bicep.McpServer.dll"
      ]
    }
  }
}
```

If the file already exists with other MCP servers, add the Bicep server to the existing `mcpServers` object:

#### Option 1: Use dnx

```json
{
  "mcpServers": {
    "existing-server": {
      "command": "...",
      "args": ["..."]
    },
    "bicep": {
      "command": "dnx",
      "args": [
        "Azure.Bicep.McpServer",
        "--yes"
      ]
    }
  }
}
```

#### Option 2: Use a local DLL

```json
{
  "mcpServers": {
    "existing-server": {
      "command": "...",
      "args": ["..."]
    },
    "bicep": {
      "command": "dotnet",
      "args": [
        "/Users/<user>/Documents/Repositories/azure-bicep-mcp-local-experiment/bicep/src/Bicep.McpServer/bin/Release/net10.0/Bicep.McpServer.dll"
      ]
    }
  }
}
```

### 4. Restart Claude Desktop

1. Quit Claude Desktop completely (Cmd+Q on macOS, Alt+F4 on Windows)
2. Reopen Claude Desktop
3. The Bicep MCP server should now be available under tools

### 5. Verify the Server is Connected

In Claude Desktop you can ask Claude:

```text
What MCP tools do you have access to?
```

to see the list of available tools.

## Available Tools

Once connected, Claude Desktop has access to these Bicep tools:

| Tool                                  | Description                                                                                                                  |
| ------------------------------------- | ---------------------------------------------------------------------------------------------------------------------------- |
| `list_az_resource_types_for_provider` | Lists all Azure resource types for a specific provider (e.g., Microsoft.Storage)                                             |
| `get_az_resource_type_schema`         | Gets the schema for a specific Azure resource type and API version                                                           |
| `get_bicep_best_practices`            | Returns Bicep coding best practices and guidelines                                                                           |
| `decompile_arm_parameters_file`       | Converts ARM template parameter JSON files into Bicep parameters format (.bicepparam).                                       |
| `decompile_arm_template_file`         | Converts ARM template JSON files into Bicep syntax (.bicep).                                                                 |
| `format_bicep_file`                   | Applies consistent formatting (indentation, spacing, line breaks) to Bicep files.                                            |
| `get_bicep_file_diagnostics`          | Analyzes a Bicep file and returns all compilation diagnostics.                                                               |
| `get_file_references`                 | Analyzes a Bicep file and returns a list of all referenced files including modules, parameter files, and other dependencies. |
| `get_deployment_snapshot`             | Creates a snapshot from a .bicepparam file to preview resources and compare Bicep implementations.                           |
| `list_avm_metadata`                   | Lists metadata for all Azure Verified Modules (AVM)                                                                          |

## Example Usage

Once the MCP server is connected, you can ask Claude things like:

- "What are the best practices for writing Bicep code?"
- "Show me the schema for Microsoft.Storage/storageAccounts@2023-01-01"
- "List all resource types in the Microsoft.Web provider"
- "What Azure Verified Modules are available for networking?"
- "Help me create a Bicep template for an Azure Function App"
