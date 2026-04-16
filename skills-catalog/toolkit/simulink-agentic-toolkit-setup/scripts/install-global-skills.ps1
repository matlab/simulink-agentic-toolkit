param(
    [string]$ToolkitRoot = ""
)

$ErrorActionPreference = "Stop"

if ([string]::IsNullOrWhiteSpace($ToolkitRoot)) {
    $ToolkitRoot = (Resolve-Path (Join-Path $PSScriptRoot "..\..\..")).Path
} else {
    $ToolkitRoot = (Resolve-Path $ToolkitRoot).Path
}

# Determine skills directory: prefer ~/.agents/skills/, fall back to
# ~/.copilot/skills/ if the primary cannot be created.
$skillsRoot = Join-Path $HOME ".agents\skills"
try {
    New-Item -ItemType Directory -Force -Path $skillsRoot | Out-Null
} catch {
    $skillsRoot = Join-Path $HOME ".copilot\skills"
    New-Item -ItemType Directory -Force -Path $skillsRoot | Out-Null
}

$skillDirs = @()
$skillDirs += Get-ChildItem -Directory (Join-Path $ToolkitRoot "skills-catalog\model-based-design-core")
$skillDirs += Get-ChildItem -Directory (Join-Path $ToolkitRoot "skills-catalog\toolkit")

foreach ($skillDir in $skillDirs | Sort-Object FullName) {
    $linkPath = Join-Path $skillsRoot $skillDir.Name
    if (Test-Path $linkPath) {
        Remove-Item -Force -Recurse $linkPath
    }

    try {
        New-Item -ItemType SymbolicLink -Path $linkPath -Target $skillDir.FullName | Out-Null
    } catch {
        New-Item -ItemType Junction -Path $linkPath -Target $skillDir.FullName | Out-Null
    }

    Write-Output ("Linked {0} -> {1}" -f $linkPath, $skillDir.FullName)
}

Write-Output ""
Write-Output "Skills directory: $skillsRoot"
