# Azure DevOps Remote MCP setup

The standard integration is the Microsoft [Azure DevOps MCP Server](https://github.com/microsoft/azure-devops-mcp) Remote MCP Server.

1. Copy `.vscode/mcp.json.example` to the ignored `.vscode/mcp.json`.
2. Replace `{organization}` with the organization from the selected local profile.
3. Start the server from the VS Code MCP view and complete the interactive Microsoft sign-in flow.
4. Keep VS Code configured to ask the user to **allow or deny every tool call**.

The committed configuration is HTTP-only. Do not add `command`, `args`, shell execution, or a VS Code task. The local stdio server is not part of this template.

Use the read-only profile for queries and reporting. Use a separately approved write profile only after a structured mutation preview and user confirmation.
