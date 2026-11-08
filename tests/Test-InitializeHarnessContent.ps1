[CmdletBinding()]
param()

$ErrorActionPreference = 'Stop'
$repositoryRoot = Split-Path -Parent $PSScriptRoot
$scriptPath = Join-Path $repositoryRoot 'scripts\Initialize-Harness.ps1'
$scriptContent = Get-Content -LiteralPath $scriptPath -Raw

foreach ($requiredText in @(
    'function Find-Executable',
    'function Install-Prerequisite',
    "PackageId 'Git.Git'",
    "PackageId 'Microsoft.VisualStudioCode'",
    '--exact',
    '--source winget',
    '--accept-package-agreements',
    '--accept-source-agreements',
    'Copy-ExampleFile'
)) {
    if ($scriptContent -notmatch [regex]::Escape($requiredText)) {
        throw "Missing bootstrap behavior: $requiredText"
    }
}

foreach ($prohibitedPattern in @(
    'Invoke-WebRequest',
    'Start-BitsTransfer',
    'Set-ExecutionPolicy',
    'Start-Process.*-Verb RunAs'
)) {
    if ($scriptContent -match $prohibitedPattern) {
        throw "Prohibited bootstrap behavior: $prohibitedPattern"
    }
}

$scenarios = Get-Content -LiteralPath (Join-Path $repositoryRoot 'tests\fixtures\bootstrap-scenarios.json') -Raw | ConvertFrom-Json
foreach ($scenarioName in @(
    'installed-prerequisites',
    'missing-git',
    'winget-unavailable',
    'winget-installation-failure',
    'post-install-verification-failure'
)) {
    if ($scenarios.scenarios.name -notcontains $scenarioName) {
        throw "Missing bootstrap scenario fixture: $scenarioName"
    }
}

Write-Host 'Bootstrap script content and fixtures passed.'
