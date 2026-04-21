param(
    [switch]$DryRun,
    [switch]$Minimal,
    [switch]$NoSync
)

$ErrorActionPreference = "Stop"

function Write-Step {
    param([string]$Message)
    Write-Host "==> $Message"
}

function Write-Warn {
    param([string]$Message)
    Write-Warning $Message
}

function Invoke-External {
    param(
        [string]$FilePath,
        [string[]]$Arguments,
        [switch]$Required
    )

    $line = "+ $FilePath $($Arguments -join ' ')"
    if ($DryRun) {
        Write-Host $line
        return $true
    }

    & $FilePath @Arguments
    if ($LASTEXITCODE -eq 0) {
        return $true
    }

    if ($Required) {
        throw "Command failed: $line"
    }

    Write-Warn "Command failed: $line"
    return $false
}

function Install-WingetPackage {
    param(
        [string]$Id,
        [switch]$Required
    )

    Write-Step "Installing $Id"
    $arguments = @(
        "install",
        "--id", $Id,
        "--exact",
        "--source", "winget",
        "--silent",
        "--accept-source-agreements",
        "--accept-package-agreements"
    )

    [void](Invoke-External -FilePath "winget" -Arguments $arguments -Required:$Required)
}

if (-not (Get-Command winget -ErrorAction SilentlyContinue)) {
    throw "winget is required. Install App Installer from Microsoft Store, then rerun this script."
}

$corePackages = @(
    "Neovim.Neovim",
    "Git.Git",
    "BurntSushi.ripgrep.MSVC",
    "sharkdp.fd",
    "junegunn.fzf",
    "sharkdp.bat"
)

$optionalPackages = @(
    "dandavison.delta",
    "ajeetdsouza.zoxide",
    "GitHub.cli",
    "JohnnyMorganz.Stylua",
    "DenoLand.Deno",
    "LuaLS.lua-language-server",
    "LLVM.LLVM",
    "Kitware.CMake",
    "OpenJS.NodeJS.LTS"
)

foreach ($package in $corePackages) {
    Install-WingetPackage -Id $package -Required
}

if (-not $Minimal) {
    foreach ($package in $optionalPackages) {
        Install-WingetPackage -Id $package
    }

    if (Get-Command npm -ErrorAction SilentlyContinue) {
        Write-Step "Installing npm formatters"
        [void](Invoke-External -FilePath "npm" -Arguments @("install", "-g", "prettier", "@biomejs/biome"))
    } else {
        Write-Warn "npm is unavailable in this session; install prettier and @biomejs/biome after reopening PowerShell."
    }
}

$repoDir = Split-Path -Parent $MyInvocation.MyCommand.Path
$target = Join-Path $env:LOCALAPPDATA "nvim"

if (Test-Path $target) {
    $targetPath = (Resolve-Path $target).Path
    $repoPath = (Resolve-Path $repoDir).Path
    if ($targetPath -eq $repoPath) {
        Write-Step "Config directory already points to this repo"
    } else {
        Write-Warn "Config target already exists: $target"
        Write-Warn "Leaving it unchanged. Move it aside if you want this script to link the repo."
    }
} else {
    Write-Step "Linking config to $target"
    if ($DryRun) {
        Write-Host "+ New-Item -ItemType Junction -Path `"$target`" -Target `"$repoDir`""
    } else {
        New-Item -ItemType Junction -Path $target -Target $repoDir | Out-Null
    }
}

if (-not $NoSync) {
    if (Get-Command nvim -ErrorAction SilentlyContinue) {
        Write-Step "Starting Neovim once to install plugins and run :checkhealth config"
        [void](Invoke-External -FilePath "nvim" -Arguments @("--headless", "+checkhealth config", "+qa"))
    } else {
        Write-Warn "nvim is unavailable in this session; reopen PowerShell and run nvim manually."
    }
}
