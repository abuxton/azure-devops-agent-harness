[CmdletBinding(SupportsShouldProcess)]
param(
    [switch]$Force
)

$ErrorActionPreference = 'Stop'
$repositoryRoot = Split-Path -Parent $PSScriptRoot

function Copy-ExampleFile {
    param(
        [Parameter(Mandatory)]
        [string]$Source,
        [Parameter(Mandatory)]
        [string]$Destination
    )

    if ((Test-Path -LiteralPath $Destination) -and -not $Force) {
        Write-Host "Keeping existing $Destination"
        return
    }

    if ($PSCmdlet.ShouldProcess($Destination, 'Create local configuration from example')) {
        Copy-Item -LiteralPath $Source -Destination $Destination -Force
        Write-Host "Created $Destination"
    }
}

$profileExample = Join-Path $repositoryRoot 'config\profiles.example.json'
$profileLocal = Join-Path $repositoryRoot 'config\profiles.local.json'
$mcpExample = Join-Path $repositoryRoot '.vscode\mcp.json.example'
$mcpLocal = Join-Path $repositoryRoot '.vscode\mcp.json'

Copy-ExampleFile -Source $profileExample -Destination $profileLocal
Copy-ExampleFile -Source $mcpExample -Destination $mcpLocal

Write-Host 'Review the generated local files, replace placeholders, and sign in interactively through VS Code.'
Write-Host 'Do not add credentials to these files.'
