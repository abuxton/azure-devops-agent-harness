[CmdletBinding()]
param()

$ErrorActionPreference = 'Stop'
$repositoryRoot = Split-Path -Parent $PSScriptRoot
$failures = [System.Collections.Generic.List[string]]::new()

function Add-Failure {
    param([string]$Message)
    $script:failures.Add($Message)
}

function Require-Path {
    param([string]$RelativePath)
    if (-not (Test-Path -LiteralPath (Join-Path $repositoryRoot $RelativePath))) {
        Add-Failure "Missing required path: $RelativePath"
    }
}

$requiredPaths = @(
    'AGENTS.md',
    'README.md',
    '.gitignore',
    '.github\copilot-instructions.md',
    '.vscode\extensions.json',
    '.vscode\mcp.json.example',
    'config\profiles.example.json',
    'instructions\azure-devops-mcp.md',
    'instructions\governance.md',
    'instructions\spec-driven-workflow.md',
    'instructions\compatibility-matrix.md',
    'skills-lock.json',
    'tmp\.gitkeep'
)

foreach ($requiredPath in $requiredPaths) {
    Require-Path -RelativePath $requiredPath
}

foreach ($jsonPath in @('.vscode\extensions.json', '.vscode\mcp.json.example', 'config\profiles.example.json', 'skills-lock.json')) {
    $path = Join-Path $repositoryRoot $jsonPath
    if (Test-Path -LiteralPath $path) {
        try {
            Get-Content -LiteralPath $path -Raw | ConvertFrom-Json | Out-Null
        }
        catch {
            Add-Failure "Invalid JSON: $jsonPath"
        }
    }
}

$mcpExample = Get-Content -LiteralPath (Join-Path $repositoryRoot '.vscode\mcp.json.example') -Raw
if ($mcpExample -notmatch 'https://mcp\.dev\.azure\.com/\{organization\}') {
    Add-Failure 'The MCP example must contain the organization placeholder.'
}

$profileExample = Get-Content -LiteralPath (Join-Path $repositoryRoot 'config\profiles.example.json') -Raw
if ($profileExample -notmatch '"organization": "\{organization\}"' -or $profileExample -notmatch '"project": "\{project\}"') {
    Add-Failure 'The profile example must contain organization and project placeholders.'
}

$bootstrapScript = Get-Content -LiteralPath (Join-Path $repositoryRoot 'scripts\Initialize-Harness.ps1') -Raw
foreach ($requiredBootstrapText in @(
    'Git.Git',
    'Microsoft.VisualStudioCode',
    '--exact',
    '--source winget',
    '--accept-package-agreements',
    '--accept-source-agreements',
    'Install-Prerequisite',
    'Find-Executable'
)) {
    if ($bootstrapScript -notmatch [regex]::Escape($requiredBootstrapText)) {
        Add-Failure "Missing prerequisite bootstrap behavior: $requiredBootstrapText"
    }
}
foreach ($prohibitedBootstrapText in @(
    'Invoke-WebRequest',
    'Start-BitsTransfer',
    'Set-ExecutionPolicy',
    'Start-Process.*-Verb RunAs'
)) {
    if ($bootstrapScript -match $prohibitedBootstrapText) {
        Add-Failure "Prohibited prerequisite bootstrap behavior: $prohibitedBootstrapText"
    }
}

$vscodeDirectory = Join-Path $repositoryRoot '.vscode'
if (Test-Path -LiteralPath $vscodeDirectory) {
    $vscodeContent = Get-ChildItem -LiteralPath $vscodeDirectory -File |
        ForEach-Object { Get-Content -LiteralPath $_.FullName -Raw } |
        Out-String
    if ($vscodeContent -match '"command"\s*:' -or $vscodeContent -match '"args"\s*:' -or (Test-Path -LiteralPath (Join-Path $vscodeDirectory 'tasks.json'))) {
        Add-Failure 'VS Code configuration contains an executable entry.'
    }
}

$gitignore = Get-Content -LiteralPath (Join-Path $repositoryRoot '.gitignore') -Raw
foreach ($requiredIgnore in @('.agents/skills/', '.vscode/mcp.json', 'config/profiles.local.json', 'tmp/*')) {
    if ($gitignore -notmatch [regex]::Escape($requiredIgnore)) {
        Add-Failure "Missing .gitignore entry: $requiredIgnore"
    }
}

$scanPaths = @(
    (Join-Path $repositoryRoot 'config'),
    (Join-Path $repositoryRoot '.vscode'),
    (Join-Path $repositoryRoot 'instructions')
)
$credentialPattern = '(?i)(ghp_[a-z0-9_]+|azure_devops_pat\s*[:=]\s*\S+|client_secret\s*[:=]\s*\S+|password\s*[:=]\s*\S+)'
foreach ($scanPath in $scanPaths) {
    if (Test-Path -LiteralPath $scanPath) {
        $matches = Get-ChildItem -LiteralPath $scanPath -File -Recurse |
            Select-String -Pattern $credentialPattern
        foreach ($match in $matches) {
            Add-Failure "Possible credential in $($match.Path):$($match.LineNumber)"
        }
    }
}

if ($failures.Count -gt 0) {
    $failures | ForEach-Object { Write-Error $_ }
    exit 1
}

Write-Host 'Harness template validation passed.'
