## ADDED Requirements

### Requirement: Explicit prerequisite bootstrap
The harness SHALL install prerequisites only when a contributor explicitly invokes `Initialize-Harness.ps1` from a PowerShell terminal. The script MUST NOT be invoked by Visual Studio Code tasks, MCP configuration, agent instructions, or another automatic mechanism.

#### Scenario: Contributor starts setup
- **WHEN** a contributor explicitly runs `Initialize-Harness.ps1`
- **THEN** the script checks for Git and Visual Studio Code before creating local harness configuration

### Requirement: Idempotent Git and Visual Studio Code detection
The bootstrap script SHALL detect usable Git and Visual Studio Code installations before attempting installation. The script MUST skip installation for a detected prerequisite and report its detected executable path.

#### Scenario: Both prerequisites are installed
- **WHEN** Git and Visual Studio Code are already available to the current user
- **THEN** the script reports both detected paths and does not invoke the package manager

#### Scenario: One prerequisite is missing
- **WHEN** Git is available and Visual Studio Code is unavailable
- **THEN** the script installs and verifies only Visual Studio Code

### Requirement: Windows Package Manager installation
The bootstrap script SHALL install a missing Git or Visual Studio Code prerequisite through `winget` using the exact package identifiers `Git.Git` and `Microsoft.VisualStudioCode`. The script MUST request package agreements non-interactively, MUST NOT download or execute an arbitrary URL, and MUST fail with an actionable message when `winget` is unavailable or returns a non-zero exit code.

#### Scenario: Install missing Git
- **WHEN** Git is unavailable and `winget` is available
- **THEN** the script invokes `winget` for the `Git.Git` package and verifies Git after installation

#### Scenario: Package manager is unavailable
- **WHEN** a required prerequisite is unavailable and `winget` is unavailable
- **THEN** the script stops without creating local configuration and explains that the contributor must install or enable Windows Package Manager

### Requirement: Post-install verification and safe failure
The bootstrap script SHALL verify Git and Visual Studio Code after every attempted installation before creating local harness configuration. The script MUST NOT change execution policy, handle credentials, or continue to local configuration creation when either prerequisite remains unavailable.

#### Scenario: Installation does not expose executable
- **WHEN** `winget` returns successfully but the required executable is still unavailable
- **THEN** the script stops with an actionable message and does not create local MCP or profile configuration
