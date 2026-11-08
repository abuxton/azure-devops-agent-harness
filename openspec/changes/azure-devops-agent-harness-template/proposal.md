## Why

Teams need a repeatable, governed way to use OpenAI-compatible and GitHub Copilot agents with Azure DevOps projects. Today, agent configuration, Azure DevOps access, work-item practices, and reporting workflows are recreated inconsistently across workspaces, which makes collaboration and auditability difficult.

## What Changes

- Introduce a repository template for an Azure DevOps agent harness that supports issue and report management through agentic workflows.
- Define reusable agent instructions, skills, and Model Context Protocol (MCP) integration boundaries for Azure DevOps.
- Define a Visual Studio Code workspace experience that enables a collaborative team to use the harness across multiple Azure DevOps projects.
- Provide manually invoked PowerShell helper scripts for Windows desktop setup and validation without using Makefiles, Taskfiles, or executable Visual Studio Code tasks.
- Require local OpenSpec artifacts for every harness engagement and retain temporary work, tool output, and scratch files in a local `./tmp` folder for review.
- Define governance requirements for identity, authorization, secrets, human approval, and traceability of agent-initiated Azure DevOps changes.
- Provide templates for issue lifecycle and project-reporting workflows.

## Capabilities

### New Capabilities
- `azure-devops-work-item-automation`: Governed agent workflows for creating, refining, updating, and querying Azure DevOps work items.
- `azure-devops-project-reporting`: Agent workflows and report templates that summarize Azure DevOps project health, delivery progress, risks, and work-item status.
- `agent-harness-governance`: Cross-agent instructions, approval controls, audit requirements, secret handling, and safe Azure DevOps MCP access boundaries.
- `collaborative-vscode-workspace`: A reusable Visual Studio Code workspace template, agent configuration, and onboarding conventions for teams working across Azure DevOps projects.

### Modified Capabilities

None. This is a new repository template with no existing capability specifications.

## Impact

- New repository documentation, instructions, skill definitions, workflow templates, and VS Code workspace configuration.
- Azure DevOps REST API and/or Azure DevOps MCP server integration using an organization-approved identity.
- GitHub Copilot and OpenAI-compatible agent clients running locally in Visual Studio Code on Windows desktops.
- Windows PowerShell for explicit local setup and validation helper scripts.
- Local OpenSpec artifacts and a retained, uncommitted `./tmp` review workspace.
- Azure DevOps project permissions, service connections, personal access token or Entra ID token policies, and audit-log retention requirements.
