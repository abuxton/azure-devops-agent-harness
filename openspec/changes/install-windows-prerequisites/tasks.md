## 1. Prerequisite Bootstrap

- [x] 1.1 Add reusable PowerShell functions to detect Git and Visual Studio Code through commands and supported Windows installation paths.
- [x] 1.2 Add fixed-identifier `winget` installation for missing Git (`Git.Git`) and Visual Studio Code (`Microsoft.VisualStudioCode`) with source and package agreement acceptance.
- [x] 1.3 Stop before local profile and MCP configuration creation when `winget` is unavailable, an installation fails, or post-install verification fails.
- [x] 1.4 Preserve explicit invocation, `-Force` behavior, no self-elevation, no execution-policy changes, and no credential handling.

## 2. Documentation and Validation

- [x] 2.1 Update Windows onboarding and README prerequisite guidance with the explicit bootstrap behavior, `winget` dependency, and retry guidance.
- [x] 2.2 Extend offline template validation to verify fixed package identifiers, required `winget` agreement flags, prerequisite verification, and the absence of arbitrary downloads or execution-policy changes.
- [x] 2.3 Add script tests or fixtures for installed prerequisites, a missing prerequisite, unavailable `winget`, failed installation, and post-install executable verification.
- [ ] 2.4 Run the bootstrap and validation tests on Windows PowerShell 5.1 and PowerShell 7, recording results in the compatibility matrix.
