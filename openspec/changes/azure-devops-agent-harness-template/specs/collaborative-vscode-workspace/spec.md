## ADDED Requirements

### Requirement: Shared Visual Studio Code workspace baseline
The repository SHALL provide a versioned Visual Studio Code workspace baseline that identifies recommended extensions and agent configuration locations without embedding user-specific credentials, absolute local paths, or executable task definitions.

#### Scenario: Contributor opens the repository in Visual Studio Code
- **WHEN** a contributor opens the template in Visual Studio Code
- **THEN** the contributor can discover the recommended extensions, available agent workflows, and documented configuration steps from versioned repository files without VS Code executing a command

### Requirement: Agent-client interoperability
The harness SHALL provide client-neutral project instructions in `AGENTS.md` and compatible configuration guidance for GitHub Copilot and OpenAI-compatible agent clients. Client-specific configuration MUST reference the same governance and workflow rules. The Visual Studio Code guidance MUST require user allow/deny decisions for each Azure DevOps MCP tool call and MUST NOT direct users to enable automatic tool approval.

#### Scenario: Use GitHub Copilot or an OpenAI-compatible client
- **WHEN** a contributor starts either supported agent client in the workspace
- **THEN** the client can discover the shared instructions, Azure DevOps scope requirements, per-tool-call approval gates, and MCP configuration guidance

### Requirement: Multi-project workspace isolation
The harness SHALL allow contributors to use the template across multiple Azure DevOps projects while keeping project-specific targets and local settings isolated from the reusable repository baseline.

#### Scenario: Configure two projects from one template
- **WHEN** a team configures separate local profiles for two Azure DevOps projects
- **THEN** each workflow uses its selected profile and does not expose the other project's identifiers or credentials

### Requirement: Windows PowerShell helper scripts
The harness SHALL provide manually invoked helper scripts compatible with Windows PowerShell 5.1 and PowerShell 7 for local setup and offline validation. The repository MUST NOT require Make, Task, Bash, WSL, or an executable Visual Studio Code task for these operations. Helper scripts MUST NOT lower execution policy, handle credentials directly, or be invoked automatically by Visual Studio Code.

#### Scenario: Initialize a Windows workspace
- **WHEN** a contributor explicitly invokes the documented PowerShell setup helper from a terminal
- **THEN** the helper creates or validates only documented local configuration artifacts and reports actionable errors without changing execution policy or storing credentials

#### Scenario: Validate the template from Windows
- **WHEN** a contributor explicitly invokes the documented PowerShell validation helper
- **THEN** the helper validates the repository baseline without requiring Make, Task, Bash, WSL, or an executable Visual Studio Code task

### Requirement: Supported-client compatibility matrix
The harness SHALL document and test the supported Visual Studio Code client configurations for GitHub Copilot and each supported OpenAI-compatible client, including Remote MCP connection, per-tool-call allow/deny behavior, profile discovery, and shared-instruction discovery. The matrix MUST distinguish tested support from unverified compatibility.

#### Scenario: Validate a supported client
- **WHEN** a maintainer validates a supported agent client release
- **THEN** the compatibility matrix records the client and version, tested capabilities, validation date, and any limitations
