# Windows onboarding

## Prerequisites

- VS Code with the recommended extensions
- Windows PowerShell 5.1 or PowerShell 7
- Access to the approved Azure DevOps organization

## Setup

1. Open a PowerShell terminal in the repository.
2. Run `.\scripts\Initialize-Harness.ps1`.
3. Copy `config/profiles.example.json` to `config/profiles.local.json`, then replace placeholders with approved project values.
4. Copy `.vscode/mcp.json.example` to `.vscode/mcp.json`, then replace the organization placeholder.
5. Start the Remote MCP Server from VS Code and sign in interactively.
6. Run `.\scripts\Test-HarnessTemplate.ps1`.

The scripts do not change execution policy or store credentials. If policy prevents invocation, follow your organization's approved PowerShell policy process.

## Multiple Azure DevOps projects

Create one named local profile per project in `config/profiles.local.json`. Select exactly one profile for each OpenSpec change and do not override its organization or project from a prompt. Create the matching local MCP configuration only for the organization being used in the active workspace.
