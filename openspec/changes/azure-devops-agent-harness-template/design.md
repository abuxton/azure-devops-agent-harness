## Context

The repository is a reusable local-first template for teams using Windows desktop environments, Visual Studio Code, and GitHub Copilot or OpenAI-compatible coding agents to manage Azure DevOps work items and produce project reports. The template must be copied or adopted by multiple Azure DevOps projects without storing credentials or one project's settings in the shared baseline.

The harness integrates with Azure DevOps through an approved MCP server or an equivalent adapter. Its primary risks are over-broad tool access, accidental external writes, credential disclosure, and reports that blur evidence with agent interpretation. The design therefore treats Azure DevOps calls as scoped, policy-governed operations rather than unrestricted agent tools.

## Goals / Non-Goals

**Goals:**

- Provide a discoverable Visual Studio Code workspace template for Copilot and OpenAI-compatible agent clients.
- Make Azure DevOps work-item and reporting workflows repeatable, reviewable, and traceable.
- Enforce project scope, least privilege, secret-free committed configuration, and explicit approval before external writes.
- Keep project-specific configuration local so one baseline supports multiple Azure DevOps projects.
- Include reusable instructions, skill definitions, workflow templates, and validation commands.
- Provide manually invoked helper scripts compatible with Windows PowerShell 5.1 and PowerShell 7 for local setup and validation.
- Require every harness engagement to use locally maintained OpenSpec artifacts that a user can review before Azure DevOps activity.
- Retain temporary artifacts, scratch files, and locally sourced tools in `./tmp` for review without committing them.

**Non-Goals:**

- Implement or host an Azure DevOps MCP server.
- Replace Azure DevOps permission management, audit retention, or enterprise identity controls.
- Automate merges, pipeline deployment, destructive Azure DevOps operations, or unattended writes.
- Require one specific agent runtime, secret manager, or authentication protocol.
- Require Make, Task, Bash, WSL, or an executable Visual Studio Code task for setup or validation.
- Require Architecture Decision Records (ADRs) during the initial reporting and work-item management scope.
- Commit credentials, generated reports containing customer data, or team-local profiles.

## Decisions

### 1. Use a layered, local-first repository layout

The template will separate shared policy and reusable assets from local project settings:

```text
AGENTS.md                         # client-neutral contributor and agent instructions
.github/copilot-instructions.md   # Copilot-specific entry point to shared policy
.vscode/                          # extension recommendations and non-executable MCP example
.vscode/mcp.json.example          # secret-free Azure DevOps remote MCP server example
config/profiles.example.json      # Azure DevOps project profile schema and examples
instructions/                     # policy, operating model, and MCP guidance
skills-lock.json                  # reviewed, hash-pinned skill recommendations only
workflows/                        # reviewable workflow and report templates
scripts/Initialize-Harness.ps1    # explicit Windows local setup helper
scripts/Test-HarnessTemplate.ps1  # explicit offline structural and secret checks
reports/.gitkeep                  # local report output location
tmp/.gitkeep                      # retained local scratch, tool, and review workspace
openspec/                         # requirements, design, and implementation tasks
```

Committed examples contain placeholders only. Developers create ignored local copies such as `.vscode/mcp.json` and `config/profiles.local.json`. The template MUST NOT commit `.agents/skills/` or any skill source files; `skills-lock.json` is the reviewed recommendation manifest, and deployment documentation instructs contributors to install skills locally with their approved skill-management tooling.

All temporary work, scratch files, locally sourced tools, tool output, and intermediate artifacts belong under `./tmp`. The folder is retained for local review and excluded from commits except `tmp/.gitkeep`. It MUST NOT hold credentials, and contributors MUST review and promote durable artifacts to the appropriate versioned location deliberately.

**Alternatives considered:**

- Store profiles in committed YAML: rejected because Azure DevOps project identifiers and destinations can be inappropriate to share across a reusable template.
- Maintain a separate template and operational repository: rejected initially because it adds adoption and version-synchronization overhead. A single template can later be packaged if demand requires it.

### 2. Define a profile as the mandatory Azure DevOps scope boundary

Each workflow will require a named local profile. A profile identifies an Azure DevOps organization, project, permitted tool categories, a credential reference, and approved report destinations. Workflow input cannot supply an arbitrary organization or project that overrides the selected profile.

**Alternatives considered:**

- Allow agents to accept arbitrary Azure DevOps URLs: rejected because it permits cross-project data exposure and makes approval review ambiguous.
- Hard-code a single project in repository configuration: rejected because the template must be portable across projects and workspaces.

### 3. Use policy-mediated MCP access with read-only defaults

The standard Azure DevOps integration is Microsoft's hosted Remote MCP Server, documented at <https://github.com/microsoft/azure-devops-mcp> and configured as an HTTP server at `https://mcp.dev.azure.com/{organization}`. The committed VS Code example contains only the HTTP endpoint, server type, and placeholder organization; it contains no credential, `command`, `args`, shell, task, or executable configuration. Contributors create their ignored local `.vscode/mcp.json` from that example and authenticate interactively through the approved identity flow.

The local `@azure-devops/mcp` stdio server is not part of this template because it requires an executable command in the VS Code MCP configuration. Teams that need it must complete a separate security review and follow the upstream documentation outside the committed template.

The MCP configuration guidance will use an allowlist of read operations for discovery, work-item queries, and reporting. The supported VS Code operating mode requires the user to allow or deny each Azure DevOps MCP tool call. The harness MUST NOT instruct users to enable automatic MCP tool approval or alter VS Code settings to bypass per-tool-call confirmation.

Write operations are not invoked directly from exploratory prompts. Mutation and publication workflows will generate a structured preview, receive an explicit confirmation, then invoke a narrowly scoped write action using a selected write-capable identity. Per-tool-call approval is a second, client-mediated check; it does not replace the structured mutation confirmation or Azure DevOps permissions.

**Alternatives considered:**

- Give the default MCP server full Azure DevOps access: rejected because it violates least privilege and lacks a reliable human approval boundary.
- Use prompt instructions alone to prohibit writes: rejected because instructions are not an enforcement mechanism.
- Use the upstream local stdio configuration in VS Code: rejected because executable command entries create an unnecessary local execution surface and are prohibited by this template.
- Enable automatic MCP tool approval after an initial setup period: rejected because each Azure DevOps operation remains an external-data access or mutation decision.

### 4. Model workflows as reviewable artifacts

Every harness engagement, including read-only Azure DevOps queries, reporting, work-item changes, and non-Azure DevOps work performed through the harness, begins with a local OpenSpec change. The change artifacts state the objective, scope, evidence plan, expected external effects, and review decision. The user reviews these artifacts in the loop before the agent invokes Azure DevOps tools.

Work-item changes and reports will use Markdown and JSON-compatible templates that state the selected profile, inputs, evidence, analysis, proposed changes, confirmation, and outcome. Durable review artifacts are stored under `openspec/`; all intermediate work is retained under `./tmp`. Local report generation is the default; external publication is a separate confirmation step.

**Alternatives considered:**

- Allow free-form agent output followed by direct publication: rejected because evidence, scope, and approval cannot be consistently inspected.
- Require a custom web application: deferred because the requested operating environment is Visual Studio Code and the template must remain lightweight.

### 5. Defer ADRs from the initial harness scope

The initial template does not require ADRs because its end users consume Azure DevOps for visibility, reporting, and work-item management rather than architectural decision governance. OpenSpec artifacts provide the required in-loop review mechanism. ADR support may be added later if teams need durable architecture decision records.

### 6. Centralize governance in shared instructions

`AGENTS.md` will be the canonical client-neutral instruction file. Copilot-specific instructions, skills, workflow templates, and MCP guidance will link to it and must not redefine approval or scope rules. This preserves consistent behavior across supported agent clients.

**Alternatives considered:**

- Duplicate policy in every client file: rejected because drift can create unsafe client-specific behavior.
- Support only GitHub Copilot: rejected because the template explicitly needs OpenAI-compatible agents as well.

### 7. Validate the template without Azure DevOps connectivity

An offline validation script will check required files, JSON syntax, ignored local-secret paths, placeholder-only committed examples, internal documentation links, and that VS Code configuration contains neither executable MCP fields (`command` or `args`) nor executable tasks. Azure DevOps integration validation remains an opt-in manual procedure using a non-production test project and approved identity.

**Alternatives considered:**

- Run live Azure DevOps tests in every validation: rejected because it requires credentials, can mutate data, and makes the template unusable before a project is configured.

### 8. Commit a curated skill recommendation lock, not skills

The checked-in `skills-lock.json` will pin a small, reviewed set of skills by source, source path, and content hash: agent governance, prompt-safety review, Azure DevOps API and CLI guidance, MCP inspection, evidence mapping, and specification/workflow documentation. It is an allowlist for human review and local deployment, not an instruction to fetch or execute code automatically. Installation documentation requires contributors to inspect the source and hash, use approved local skill-management tooling, and keep installed files under ignored `.agents/skills/`.

**Alternatives considered:**

- Commit all supplied skills: rejected because it bloats the reusable template, imports unrelated executable content, and prevents each team from approving the skill set it runs locally.
- Add skill installation or execution commands to VS Code tasks: rejected because VS Code configuration must remain non-executable in this template.

### 9. Use explicit Windows PowerShell helper scripts

The template will provide PowerShell scripts for repeatable local setup and offline validation. Scripts MUST declare supported PowerShell versions, use `CmdletBinding()` and parameters rather than positional environment-dependent behavior, fail with actionable errors, and avoid handling credentials directly. Contributors invoke scripts explicitly from a PowerShell terminal; neither VS Code configuration nor agent instructions automatically invoke them.

Makefiles and Taskfiles are excluded because Windows desktop users should not need Make, Task, Bash, or WSL to use the template.

**Alternatives considered:**

- Makefile or Taskfile: rejected because they impose non-native tooling on the supported Windows desktop environment.
- VS Code tasks: rejected because the template's VS Code configuration is intentionally non-executable.

## Risks / Trade-offs

- [MCP server capabilities vary by client and server implementation] -> Keep the committed configuration as an example, document the required behavior rather than a vendor-specific tool name, and validate only the template contract offline.
- [A user can select an overly privileged local identity] -> Document minimum permissions, default to read-only profiles, and require explicit selection of a write profile for confirmed mutations.
- [Agent output can contain unsupported conclusions] -> Require source identifiers for factual assertions and label summaries, risks, and recommendations as analysis.
- [Project profile identifiers may be sensitive in some organizations] -> Ignore real profile files and commit only generic placeholders.
- [Approval can be bypassed by manual tool use] -> Make the harness policy explicit, constrain configured tool categories, and retain an audit record; enterprise enforcement remains an Azure DevOps and identity-control responsibility.
- [VS Code and agent-client configuration formats evolve] -> Keep client-neutral instructions authoritative and isolate client-specific examples in dedicated files.
- [A recommended skill changes upstream] -> Pin its reviewed hash in `skills-lock.json`; require a new review before changing the lock.
- [Local skills contain scripts or prompts that expand the attack surface] -> Do not commit them, require local inspection and approval, and do not install or invoke them from VS Code configuration.
- [PowerShell execution policy blocks helper scripts] -> Document explicit invocation and organization-approved execution-policy guidance; do not lower execution policy from a script.
- [Retained temporary output contains sensitive Azure DevOps data] -> Keep `./tmp` local and uncommitted, prohibit credentials there, and require review before promoting content to version control.

## Migration Plan

1. Initialize a repository from the template and retain the shared baseline unchanged.
2. Review `skills-lock.json` and install only organization-approved entries locally; do not copy installed skill files into the repository.
3. Create and review a local OpenSpec change for the intended harness engagement before invoking Azure DevOps tools.
4. Explicitly run the documented Windows PowerShell setup helper to create local configuration files; review every generated file before adding credentials.
5. Copy the example profile and Remote MCP configuration to ignored local files.
6. Configure a read-only identity for a non-production Azure DevOps project and validate query and report workflows.
7. Explicitly run the offline PowerShell validation helper and review the retained `./tmp` artifacts, generated reports, and audit records with the project administrator.
8. Add a narrowly scoped write identity only if work-item mutation workflows are approved.
9. Roll back by removing local MCP and profile files, uninstalling local skills, revoking the identity or token, and deleting local reports. Retained `./tmp` artifacts are removed only after review. No Azure DevOps schema or repository migration is required.

## Open Questions

- What audit-log storage and retention system is required beyond local workflow artifacts?
- Which Azure DevOps work-item fields, process templates, and report destinations must the initial workflow templates support?
- Does the organization require Entra ID device-code authentication, a credential manager, or a specific secret manager for local developer access?
- Is Windows PowerShell 5.1 the organization-wide baseline, or can the template require PowerShell 7?
