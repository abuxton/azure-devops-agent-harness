## Why

Windows contributors cannot use the harness until Git and Visual Studio Code are available. Manual prerequisite installation produces inconsistent setup and delays the first reviewed Azure DevOps workflow.

## What Changes

- Extend `Initialize-Harness.ps1` to detect Git and Visual Studio Code.
- Install missing prerequisites through the built-in Windows Package Manager (`winget`) only when the user explicitly invokes the script.
- Verify each required executable after installation and report actionable failures when installation or verification does not succeed.
- Preserve the existing prohibition on executable VS Code tasks, automatic agent invocation, credential handling, and execution-policy changes.

## Capabilities

### New Capabilities
- `windows-prerequisite-bootstrap`: Explicit Windows PowerShell detection, installation, and verification of Git and Visual Studio Code for the harness.

### Modified Capabilities

None. This change adds a local bootstrap capability without changing existing Azure DevOps workflow requirements.

## Impact

- `scripts/Initialize-Harness.ps1` gains package-manager checks and prerequisite installation behavior.
- Onboarding documentation gains prerequisite and elevation guidance.
- Template validation and tests gain coverage for expected bootstrap script behavior.
- The script can download signed packages from the configured Windows Package Manager source only after a contributor explicitly runs it.
