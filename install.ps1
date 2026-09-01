#Requires -Version 5.1

$ErrorActionPreference = "Stop"

# ============================================================
# Windows Laravel Development Environment
# ============================================================

if ($PSVersionTable.Platform -ne "Win32NT") {

    Write-Host ""
    Write-Host "============================================================" -ForegroundColor Yellow
    Write-Host "       Windows Laravel Development Environment" -ForegroundColor Yellow
    Write-Host "============================================================" -ForegroundColor Yellow
    Write-Host ""

    Write-Host "This installer is designed for Windows only." -ForegroundColor Red
    Write-Host ""
    Write-Host "Detected platform: $($PSVersionTable.Platform)" -ForegroundColor Yellow
    Write-Host ""
    Write-Host "No changes were made to this computer." -ForegroundColor Green
    Write-Host ""

    exit 1
}

$RootDirectory = Split-Path -Parent $MyInvocation.MyCommand.Path

$ConfigFile = Join-Path `
    $RootDirectory `
    "config\requirements.json"

$scriptsDirectory = Join-Path `
    $RootDirectory `
    "scripts"

# ============================================================
# Load configuration
# ============================================================

if (-not (Test-Path $ConfigFile)) {
    throw "Configuration file not found: $ConfigFile"
}

$config = Get-Content `
    $ConfigFile `
    -Raw |
    ConvertFrom-Json

# ============================================================
# Load modules
# ============================================================

. (Join-Path $scriptsDirectory "preflight.ps1")
. (Join-Path $scriptsDirectory "php.ps1")
. (Join-Path $scriptsDirectory "composer.ps1")
. (Join-Path $scriptsDirectory "mysql.ps1")
. (Join-Path $scriptsDirectory "python.ps1")
. (Join-Path $scriptsDirectory "verify.ps1")

# ============================================================
# Header
# ============================================================

Clear-Host

Write-Host ""
Write-Host "============================================================" -ForegroundColor Cyan
Write-Host "       Windows Laravel Development Environment" -ForegroundColor Cyan
Write-Host "============================================================" -ForegroundColor Cyan
Write-Host ""

Write-Host "Configuration loaded." -ForegroundColor Green

# ============================================================
# Preflight
# ============================================================

Write-Host ""
Write-Host "Running preflight checks..." -ForegroundColor Cyan
Write-Host ""

$system = Invoke-Preflight

# ============================================================
# Detection
# ============================================================

Write-Host ""
Write-Host "Detecting development tools..." -ForegroundColor Cyan
Write-Host ""

Write-Host "PHP 8.5:"
if (Test-PHP85) {
    Write-Host "  Already installed." -ForegroundColor Green
}
else {
    Write-Host "  Installation required." -ForegroundColor Yellow
}

Write-Host ""
Write-Host "Composer:"
if (Test-Composer) {
    Write-Host "  $(Get-ComposerVersion)" -ForegroundColor Green
}
else {
    Write-Host "  Installation required." -ForegroundColor Yellow
}

Write-Host ""
Write-Host "MySQL:"
if (Test-MySQL) {
    Write-Host "  $(Get-MySQLVersion)" -ForegroundColor Green
}
else {
    Write-Host "  Installation required." -ForegroundColor Yellow
}

Write-Host ""
Write-Host "Python:"
if (Test-Python) {
    Write-Host "  $(Get-PythonVersion)" -ForegroundColor Green
}
else {
    Write-Host "  Installation required." -ForegroundColor Yellow
}

# ============================================================
# Installation
# ============================================================

Write-Host ""
Write-Host "============================================================" -ForegroundColor Cyan
Write-Host "Installation stage" -ForegroundColor Cyan
Write-Host "============================================================" -ForegroundColor Cyan
Write-Host ""

Write-Host "Installation modules are ready."
Write-Host "Actual Windows installation will be enabled after testing."

# ============================================================
# Verification
# ============================================================

Invoke-FinalVerification

Write-Host ""
Write-Host "============================================================" -ForegroundColor Cyan
Write-Host ""