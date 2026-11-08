## Context

`Initialize-Harness.ps1` currently creates ignored local profile and MCP configuration from committed examples. Windows contributors also need Git and Visual Studio Code before they can use the template, but the harness must not use executable VS Code tasks, change execution policy, handle credentials, or fetch arbitrary installers.

## Goals / Non-Goals

**Goals:**

- Detect usable Git and Visual Studio Code installations before local configuration is created.
- Install only missing prerequisites through explicit, user-invoked `winget` commands.
- Verify executables after installation and stop safely on failure.
- Preserve idempotent configuration generation and existing `-Force` behavior.

**Non-Goals:**

- Install Windows Package Manager, PowerShell, extensions, MCP servers, skills, credentials, or Azure DevOps tooling.
- Change execution policy, elevate privileges, download arbitrary URLs, or execute a command through VS Code.
- Support package managers other than `winget` in the initial implementation.

## Decisions

### 1. Use fixed `winget` package identifiers

The script will install `Git.Git` and `Microsoft.VisualStudioCode` with `winget install --id <id> --exact --accept-package-agreements --accept-source-agreements`. Fixed identifiers avoid prompt-derived package names and make the package source auditable.

**Alternatives considered:**

- Download vendor installers directly: rejected because it adds URL, checksum, and execution-policy complexity.
- Use Chocolatey or Scoop: rejected because neither is a guaranteed Windows dependency.

### 2. Verify prerequisites before and after installation

Git detection will use `Get-Command git`. VS Code detection will use `Get-Command code` and known user/machine installation paths. If a prerequisite remains unavailable after `winget` succeeds, the script stops before copying local configuration because the process environment may need to be restarted.

**Alternatives considered:**

- Assume successful `winget` exit is sufficient: rejected because PATH updates may not be visible in the current session.

### 3. Bootstrap only on direct invocation

The prerequisite check runs in `Initialize-Harness.ps1`, which contributors invoke manually from PowerShell. It is not referenced by VS Code tasks, MCP settings, agent instructions, or another script.

**Alternatives considered:**

- Run bootstrap automatically when VS Code opens: rejected because it would execute package installation outside a deliberate user action.

## Risks / Trade-offs

- [Windows Package Manager is unavailable] -> Stop before changing local configuration and provide remediation guidance.
- [Installation requires a new terminal session] -> Detect known executable locations and explain when a session restart is necessary.
- [Package installation prompts or requires elevation] -> Let `winget` surface its standard prompt; do not self-elevate.
- [A package source changes] -> Use fixed package identifiers and retain the user-visible `winget` command in the PowerShell terminal.

## Migration Plan

1. Update `Initialize-Harness.ps1` with prerequisite detection and installation.
2. Update onboarding documentation and add offline script-content validation.
3. Test on Windows PowerShell 5.1 and PowerShell 7 with both installed and missing-prerequisite scenarios.
4. Roll back by restoring the prior configuration-only script; installed tools remain managed by the user and Windows Package Manager.

## Open Questions

- Does the organization require a private `winget` source or package source policy before contributor use?
