## ADDED Requirements

### Requirement: Credentials remain outside version control
The harness SHALL load Azure DevOps credentials only from an approved local environment, secret manager, or identity-provider session. The harness MUST provide committed configuration examples without credential values and MUST exclude secret-bearing local configuration from version control.

#### Scenario: Configure a new workspace
- **WHEN** a contributor configures Azure DevOps access for a new workspace
- **THEN** the contributor receives a secret-free example configuration and supplies credentials through an approved non-versioned mechanism

### Requirement: Least-privilege integration identities
The harness SHALL document the minimum Azure DevOps permissions required for each workflow and SHALL use read-only access by default. A write-capable identity MUST be explicitly selected for an approved mutation workflow.

#### Scenario: Run a reporting workflow
- **WHEN** an operator runs a project-reporting workflow
- **THEN** the harness uses a read-only Azure DevOps identity and does not request write permissions

### Requirement: Human approval gates external writes
The harness SHALL require explicit operator confirmation immediately before any write to Azure DevOps or another external system. In Visual Studio Code, the harness SHALL require the operator to allow or deny each Azure DevOps MCP tool call. Agent instructions, skill definitions, and MCP configuration MUST not bypass either approval gate or instruct users to enable automatic tool approval.

#### Scenario: Agent proposes an external publication
- **WHEN** an agent completes a report that is eligible for publication
- **THEN** the harness holds the report for review until an operator explicitly confirms the configured destination

#### Scenario: Operator denies an Azure DevOps MCP tool call
- **WHEN** Visual Studio Code presents an Azure DevOps MCP tool call and the operator selects deny
- **THEN** the harness does not treat the denied call as approved and does not continue with a dependent external write

#### Scenario: Operator allows a read-only Azure DevOps MCP tool call
- **WHEN** Visual Studio Code presents an Azure DevOps MCP read tool call and the operator selects allow
- **THEN** the harness performs only that tool call within the selected profile and retains the required workflow evidence

### Requirement: Safe and auditable tool configuration
The harness SHALL define MCP server configuration, allowed tool categories, input scope, and audit-log expectations in versioned, reviewable files. The configuration MUST prohibit unbounded project access and destructive operations by default.

#### Scenario: Add an Azure DevOps MCP server
- **WHEN** a maintainer adds an Azure DevOps MCP server configuration
- **THEN** the configuration documents the server, allowed operations, target scope, authentication mechanism reference, and audit requirements without storing a secret

### Requirement: Non-executable Azure DevOps MCP configuration
The harness SHALL use Microsoft's Azure DevOps Remote MCP Server as its standard VS Code integration and SHALL reference its upstream documentation at `https://github.com/microsoft/azure-devops-mcp`. Committed VS Code configuration MUST define an HTTP endpoint with a placeholder organization and MUST NOT contain `command`, `args`, shell, task, or other executable configuration.

#### Scenario: Configure the standard Azure DevOps MCP server
- **WHEN** a contributor creates local MCP configuration from the committed example
- **THEN** the configuration targets `https://mcp.dev.azure.com/{organization}` over HTTP and contains no executable fields or credentials

#### Scenario: Attempt to add a local executable server
- **WHEN** a proposed committed VS Code configuration contains an MCP `command` or `args` field or an executable task
- **THEN** template validation fails and the configuration is not accepted

### Requirement: Reviewed local skill recommendations
The harness SHALL commit a formatted `skills-lock.json` that identifies only reviewed skill recommendations by source, source path, and content hash. The harness MUST NOT commit actual skill files and MUST document that contributors install approved skills locally with approved tooling after reviewing the pinned source and hash.

#### Scenario: Contributor provisions recommended skills
- **WHEN** a contributor needs a recommended harness skill
- **THEN** the contributor can identify its pinned source and hash from `skills-lock.json` and follow local deployment instructions without a VS Code task or MCP configuration executing an installation

### Requirement: Local spec-driven engagement record
The harness SHALL require a local OpenSpec change for every harness engagement, including read-only Azure DevOps queries, reporting, work-item updates, and non-Azure DevOps work performed through the harness. The change MUST define the objective, selected profile when applicable, intended external effects, and review decision before the agent invokes an Azure DevOps MCP tool.

#### Scenario: Start a reporting engagement
- **WHEN** an operator requests a project report
- **THEN** the harness creates or selects a local OpenSpec change for the report and presents its scope for review before querying Azure DevOps

### Requirement: Retained local temporary workspace
The harness SHALL store all temporary work, scratch files, locally sourced tools, tool output, and intermediate artifacts under `./tmp`. The harness MUST retain `./tmp` for local review, exclude its contents from commits except `tmp/.gitkeep`, and prohibit credentials in the folder.

#### Scenario: Preserve intermediate report evidence
- **WHEN** a reporting workflow creates intermediate query output or scratch analysis
- **THEN** the workflow stores it under `./tmp` and retains it for local review without committing it
