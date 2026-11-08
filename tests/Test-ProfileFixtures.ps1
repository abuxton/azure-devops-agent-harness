[CmdletBinding()]
param()

$ErrorActionPreference = 'Stop'
$repositoryRoot = Split-Path -Parent $PSScriptRoot

function Test-Profile {
    param([object]$Profile)

    if ([string]::IsNullOrWhiteSpace($Profile.organization) -or $Profile.organization -eq '{organization}') {
        return $false
    }
    if ([string]::IsNullOrWhiteSpace($Profile.project) -or $Profile.project -eq '{project}') {
        return $false
    }
    if ($Profile.allowedToolCategories.Count -eq 0) {
        return $false
    }
    return $true
}

$fixtures = @(
    @{ Path = 'tests\fixtures\valid-readonly-profile.json'; Expected = $true },
    @{ Path = 'tests\fixtures\valid-write-profile.json'; Expected = $true },
    @{ Path = 'tests\fixtures\invalid-unscoped-profile.json'; Expected = $false },
    @{ Path = 'tests\fixtures\invalid-empty-allowlist-profile.json'; Expected = $false }
)

foreach ($fixture in $fixtures) {
    $profile = Get-Content -LiteralPath (Join-Path $repositoryRoot $fixture.Path) -Raw | ConvertFrom-Json
    if ((Test-Profile -Profile $profile) -ne $fixture.Expected) {
        throw "Unexpected result for $($fixture.Path)"
    }
}

$invalidMcpAllowlist = Get-Content -LiteralPath (Join-Path $repositoryRoot 'tests\fixtures\invalid-mcp-tool-allowlist.json') -Raw | ConvertFrom-Json
if ($invalidMcpAllowlist.allowedToolCategories.Count -ne 0) {
    throw 'The invalid MCP allowlist fixture must be empty.'
}

Write-Host 'Profile and MCP allowlist fixtures passed.'
