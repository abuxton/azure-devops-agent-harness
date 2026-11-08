## 1. Repository Foundation

- [x] 1.1 Create the template directory structure for instructions, workflows, configuration examples, reports, scripts, VS Code files, and tests; do not add skill source directories.
- [x] 1.2 Add a root `.gitignore` that excludes local profiles, real MCP configuration, environment files, generated reports, audit records, agent-client local state, `.agents/skills/`, and `tmp/*` while retaining committed examples, `skills-lock.json`, and `tmp/.gitkeep`.
- [x] 1.3 Add a concise README that explains the template purpose, supported clients, local-first operating model, and safe adoption path.
- [x] 1.4 Add the canonical `AGENTS.md` with scope selection, approval, evidence, traceability, secret-handling, and client-neutral workflow rules.
- [x] 1.5 Document Windows desktop support, Windows PowerShell 5.1 and PowerShell 7 compatibility, and the explicit no-Makefile/no-Taskfile/no-executable-VS-Code-task constraint.
- [x] 1.6 Add the retained local `tmp/.gitkeep` workspace and document that all temporary work, scratch files, tools, and intermediate artifacts belong under `./tmp`, are retained for review, contain no credentials, and are not committed.
- [x] 1.7 Document the local OpenSpec workflow required before every harness engagement; explicitly defer ADRs from the initial reporting and work-item-management scope.

## 2. Azure DevOps Configuration and Governance

- [x] 2.1 Define and document the secret-free local Azure DevOps profile schema with organization, project, allowed tool categories, credential reference, and publication destinations.
- [x] 2.2 Add an ignored local profile example and a committed generic profile example without real project identifiers or credentials.
- [x] 2.3 Add a secret-free VS Code Azure DevOps Remote MCP configuration example for `https://mcp.dev.azure.com/{organization}` and link to `https://github.com/microsoft/azure-devops-mcp`.
- [x] 2.4 Validate that committed VS Code configuration contains no `command`, `args`, shell, task, or other executable entry; do not include a local stdio MCP configuration.
- [x] 2.5 Document per-tool-call Azure DevOps MCP allow/deny approval in VS Code; prohibit automatic tool approval and distinguish tool approval from mutation confirmation.
- [x] 2.6 Document minimum Azure DevOps permissions for read-only reporting and separately for approved work-item mutations.
- [x] 2.7 Add an auditable approval and trace-record format for work-item mutations and external report publication.
- [x] 2.8 Add validation rules that reject placeholder omissions, unbounded project targets, committed credentials, destructive tool configuration, executable VS Code configuration, and instructions to enable automatic MCP tool approval.

## 3. Agent Instructions and Skills

- [x] 3.1 Add GitHub Copilot instructions that reference `AGENTS.md` rather than duplicating governance policy.
- [x] 3.2 Add OpenAI-compatible client guidance that locates shared instructions, MCP configuration, and local profiles.
- [x] 3.3 Define the Azure DevOps work-item workflow with profile selection, read/query steps, structured mutation preview, explicit confirmation, execution, and trace-record requirements without committing skill source files.
- [x] 3.4 Define the Azure DevOps reporting workflow with source-query, evidence citation, analysis labeling, local artifact generation, and publication-confirmation requirements without committing skill source files.
- [x] 3.5 Add a governance policy document that prohibits credentials in prompts or files, unbounded access, external writes without confirmation, and destructive operations by default.
- [x] 3.6 Curate and commit `skills-lock.json` with only the reviewed skills relevant to Azure DevOps issue/reporting work, retaining each source, source path, and hash.
- [x] 3.7 Document local skill deployment, source/hash review, upgrade review, and removal; prohibit committing skill files and prohibit skill installation or execution from VS Code configuration.

## 4. Reviewable Workflows and Templates

- [x] 4.1 Add a work-item query and refinement workflow template that captures selected profile, filters, returned evidence, and recommended next actions.
- [x] 4.2 Add a work-item mutation preview template that captures target fields, linked work items, agent rationale, confirmation, result revision, and failure details.
- [x] 4.3 Add a delivery-status report template covering scope, generation time, source references, progress, risks, work-item status, analysis labels, and recommendations.
- [x] 4.4 Add a report-publication workflow template that requires a configured destination and explicit confirmation before an external write.
- [x] 4.5 Add a sample local-only report artifact using synthetic data to demonstrate the required evidence and analysis separation.
- [x] 4.6 Require each workflow template to create or select a local OpenSpec change before invoking Azure DevOps MCP tools and to store intermediate files under `./tmp`.

## 5. Visual Studio Code Collaboration

- [x] 5.1 Add VS Code extension recommendations and non-executable configuration guidance without embedding user-specific paths or secrets.
- [x] 5.2 Add VS Code MCP setup guidance that directs contributors to create ignored local configuration from the committed example.
- [x] 5.3 Document multi-project workspace practices, including one local profile per project and prohibited cross-project profile overrides.
- [x] 5.4 Add contributor onboarding and team operating guidance for profile provisioning, identity approval, review responsibilities, and troubleshooting.
- [x] 5.5 Add `scripts/Initialize-Harness.ps1` for explicit Windows desktop setup; support Windows PowerShell 5.1 and PowerShell 7, use named parameters and actionable failures, and never handle credentials or execution policy.
- [x] 5.6 Document explicit PowerShell invocation of setup and validation helpers from a terminal; do not add a VS Code task or automatic agent invocation.
- [x] 5.7 Add and maintain a supported-client compatibility matrix covering GitHub Copilot and approved OpenAI-compatible clients, Remote MCP connection, per-tool-call approval, profile discovery, and shared-instruction discovery.

## 6. Validation and Quality Gates

- [x] 6.1 Implement `scripts/Test-HarnessTemplate.ps1` for offline validation of required files, JSON syntax, internal links, expected ignore rules, and the absence of executable VS Code fields; support Windows PowerShell 5.1 and PowerShell 7.
- [x] 6.2 Implement checks that scan committed configuration examples and documentation for credential-like values and non-placeholder Azure DevOps targets.
- [x] 6.3 Add automated tests or fixtures for valid read-only profiles, valid write profiles, invalid unscoped profiles, and invalid MCP tool allowlists.
- [ ] 6.4 Run the offline validation and tests against a clean clone of the template and fix all failures.
- [ ] 6.5 Perform a documented manual smoke test with an approved read-only identity against a non-production Azure DevOps project.
- [ ] 6.6 Verify a PowerShell 5.1 and PowerShell 7 test matrix for setup and validation scripts, and record client compatibility-matrix results.
