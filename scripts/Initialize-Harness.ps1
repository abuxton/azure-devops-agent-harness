[CmdletBinding(SupportsShouldProcess)]
param(
    [switch]$Force
)

$ErrorActionPreference = 'Stop'
$repositoryRoot = Split-Path -Parent $PSScriptRoot

function Find-Executable {
    param(
        [Parameter(Mandatory)]
        [string]$CommandName,
        [Parameter(Mandatory)]
        [string[]]$CandidatePaths
    )

    $command = Get-Command -Name $CommandName -ErrorAction SilentlyContinue
    if ($null -ne $command) {
        return $command.Source
    }

    foreach ($candidatePath in $CandidatePaths) {
        if (-not [string]::IsNullOrWhiteSpace($candidatePath) -and (Test-Path -LiteralPath $candidatePath)) {
            return $candidatePath
        }
    }

    return $null
}

function Install-Prerequisite {
    param(
        [Parameter(Mandatory)]
        [string]$Name,
        [Parameter(Mandatory)]
        [string]$PackageId,
        [Parameter(Mandatory)]
        [scriptblock]$FindExecutable
    )

    $executablePath = & $FindExecutable
    if ($null -ne $executablePath) {
        Write-Host "Found $Name at $executablePath"
        return
    }

    $winget = Get-Command -Name winget -ErrorAction SilentlyContinue
    if ($null -eq $winget) {
        throw "Cannot install $Name because Windows Package Manager (winget) is unavailable. Install or enable winget, then run this script again."
    }

    Write-Host "Installing $Name with Windows Package Manager."
    & $winget.Source install --id $PackageId --exact --source winget --accept-package-agreements --accept-source-agreements
    if ($LASTEXITCODE -ne 0) {
        throw "winget failed while installing $Name (package $PackageId) with exit code $LASTEXITCODE."
    }

    $executablePath = & $FindExecutable
    if ($null -eq $executablePath) {
        throw "$Name was installed but its executable is unavailable in this PowerShell session. Open a new terminal and run this script again."
    }

    Write-Host "Verified $Name at $executablePath"
}

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

$gitPaths = @(
    (Join-Path $env:ProgramFiles 'Git\cmd\git.exe'),
    (Join-Path ${env:ProgramFiles(x86)} 'Git\cmd\git.exe'),
    (Join-Path $env:LOCALAPPDATA 'Programs\Git\cmd\git.exe')
)
$codePaths = @(
    (Join-Path $env:LOCALAPPDATA 'Programs\Microsoft VS Code\bin\code.cmd'),
    (Join-Path $env:ProgramFiles 'Microsoft VS Code\bin\code.cmd'),
    (Join-Path ${env:ProgramFiles(x86)} 'Microsoft VS Code\bin\code.cmd')
)

Install-Prerequisite -Name 'Git' -PackageId 'Git.Git' -FindExecutable { Find-Executable -CommandName 'git' -CandidatePaths $gitPaths }
Install-Prerequisite -Name 'Visual Studio Code' -PackageId 'Microsoft.VisualStudioCode' -FindExecutable { Find-Executable -CommandName 'code' -CandidatePaths $codePaths }

$profileExample = Join-Path $repositoryRoot 'config\profiles.example.json'
$profileLocal = Join-Path $repositoryRoot 'config\profiles.local.json'
$mcpExample = Join-Path $repositoryRoot '.vscode\mcp.json.example'
$mcpLocal = Join-Path $repositoryRoot '.vscode\mcp.json'

Copy-ExampleFile -Source $profileExample -Destination $profileLocal
Copy-ExampleFile -Source $mcpExample -Destination $mcpLocal

Write-Host 'Review the generated local files, replace placeholders, and sign in interactively through VS Code.'
Write-Host 'Do not add credentials to these files.'
