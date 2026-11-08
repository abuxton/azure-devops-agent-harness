# Azure DevOps Agent Harness

A Windows-first, local-first template for using GitHub Copilot and compatible agent clients to prepare Azure DevOps work-item changes and project reports.

## Operating model

1. Start or select a local OpenSpec change in `openspec/changes/`.
2. Record scratch work and tool output in `tmp/`; it remains local for review.
3. Select an approved local profile from `config/profiles.local.json`.
4. In VS Code, allow or deny **each** Azure DevOps MCP tool call.
5. Review the structured preview before any external write or publication.

`tmp/`, reports, audit records, profiles, MCP configuration, and installed skills are intentionally uncommitted. Do not put credentials in any repository file.

## Quick start

In Windows PowerShell, explicitly run:

```powershell
.\scripts\Initialize-Harness.ps1
.\scripts\Test-HarnessTemplate.ps1
```

See [onboarding](instructions/onboarding.md), [MCP configuration](instructions/azure-devops-mcp.md), and [skill deployment](instructions/skills.md).

## Supported environment

- Windows desktop with VS Code
- Windows PowerShell 5.1 or PowerShell 7
- GitHub Copilot or an approved OpenAI-compatible client
- Microsoft Azure DevOps Remote MCP Server

This template does not use Makefiles, Taskfiles, Bash, WSL, executable VS Code tasks, or automatic tool approval.
