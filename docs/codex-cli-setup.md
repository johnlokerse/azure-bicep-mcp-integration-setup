# Using Bicep MCP Server with Codex CLI

This guide explains how to configure and use the Azure Bicep MCP server with Codex CLI.

![Codex Calling Bicep MCP Server](../images/CodexCallingBicepMCP.png)

## Prerequisites

- [Codex CLI](https://developers.openai.com/codex/cli/) installed and authenticated
- [.NET 10.0 SDK](https://dotnet.microsoft.com/en-us/download/dotnet/10.0?WT.mc_id=MVP_323261) or later
- Bicep MCP Server available via one of the options in [README.md](../README.md#options)

## Quick Setup

Choose one of the following options:

### Quick Option 1 (recommended): Use dnx

```bash
codex mcp add bicep-nuget -- dnx Azure.Bicep.McpServer --yes
```

### Quick Option 2: Use a local DLL

```bash
codex mcp add bicep -- dotnet /path/to/Azure.Bicep.McpServer.dll
```

> **Note**: Replace the path with your actual path to `Azure.Bicep.McpServer.dll`

## Step-by-Step Setup

### 1. Find Your MCP Server Path

Only use this step if you are using Option 2 or 3 from the [README.md](../README.md#options) to get the Bicep MCP server DLL.

```bash
# Navigate to your project
cd <Path to your cloned azure-bicep-mcp-local repository>

# Find the built DLL
find bicep/src/Bicep.McpServer/bin/Release -name "Azure.Bicep.McpServer.dll"
```

If you use the VS Code extension method, the path may look like this:

```bash
~/.vscode/extensions/ms-azuretools.vscode-bicep-0.39.26/bicepMcpServer/Azure.Bicep.McpServer.dll
```

### 2. Add the MCP Server

Pick one of the following commands:

#### Step Option 1 (recommended): Use dnx

```bash
codex mcp add bicep -- dnx Azure.Bicep.McpServer --yes
```

#### Step Option 2 & 3: Use a local DLL

```bash
codex mcp add bicep -- dotnet /path/to/Azure.Bicep.McpServer.dll
```

### 3. Verify the Server is Configured

```bash
# List all configured MCP servers
codex mcp list

# Get details for the Bicep server
codex mcp get bicep
```

### 4. Check Server Status in Codex CLI

Within a Codex CLI session, use:

```bash
/mcp
```

This displays all connected MCP servers and their status.

## Available Tools

Once connected, Codex CLI has access to these Bicep tools:

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

Once the MCP server is connected, you can ask Codex CLI things like:

```text
> What are the best practices for writing Bicep code?

> Show me the schema for Microsoft.Storage/storageAccounts@2023-01-01

> List all resource types in the Microsoft.Web provider

> What Azure Verified Modules are available for networking?

> Help me create a Bicep template for an Azure Function App
```
