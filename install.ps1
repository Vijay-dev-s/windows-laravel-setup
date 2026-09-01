#Requires -Version 5.1

$ErrorActionPreference = "Stop"

Clear-Host

Write-Host ""
Write-Host "============================================================" -ForegroundColor Cyan
Write-Host "       Windows Laravel Development Environment" -ForegroundColor Cyan
Write-Host "============================================================" -ForegroundColor Cyan
Write-Host ""
Write-Host "Preflight check - no software will be installed." -ForegroundColor Gray
Write-Host ""

$failed = 0
$warnings = 0

function Check {
    param(
        [string]$Name,
        [bool]$Pass,
        [string]$Message
    )

    if ($Pass) {
        Write-Host ("  [PASS] {0,-28} {1}" -f $Name, $Message) -ForegroundColor Green
    }
    else {
        Write-Host ("  [FAIL] {0,-28} {1}" -f $Name, $Message) -ForegroundColor Red
        $script:failed++
    }
}

function Warn {
    param(
        [string]$Name,
        [string]$Message
    )

    Write-Host ("  [WARN] {0,-28} {1}" -f $Name, $Message) -ForegroundColor Yellow
    $script:warnings++
}

# ============================================================
# Administrator
# ============================================================

Write-Host "SYSTEM" -ForegroundColor Cyan
Write-Host ""

$identity = [Security.Principal.WindowsIdentity]::GetCurrent()
$principal = New-Object Security.Principal.WindowsPrincipal($identity)

$isAdmin = $principal.IsInRole(
    [Security.Principal.WindowsBuiltInRole]::Administrator
)

Check "Administrator" $isAdmin `
    $(if ($isAdmin) { "Yes" } else { "Run PowerShell as Administrator" })

# ============================================================
# Windows
# ============================================================

$os = Get-CimInstance Win32_OperatingSystem

$isWindows10 = $os.Caption -match "Windows 10"
$is64Bit = $os.OSArchitecture -eq "64-bit"

Check "Windows 10" $isWindows10 $os.Caption
Check "64-bit" $is64Bit $os.OSArchitecture

# ============================================================
# CPU
# ============================================================

$cpu = Get-CimInstance Win32_Processor | Select-Object -First 1

$cores = $cpu.NumberOfLogicalProcessors

Check "CPU" ($cores -ge 2) "$cores logical processors"

Write-Host ""
Write-Host "MEMORY & STORAGE" -ForegroundColor Cyan
Write-Host ""

# ============================================================
# RAM
# ============================================================

$ramGB = [math]::Round(
    $os.TotalVisibleMemorySize / 1MB,
    2
)

Check "RAM" ($ramGB -ge 4) "$ramGB GB"

if ($ramGB -lt 8) {
    Warn "RAM recommendation" "8 GB+ recommended"
}

# ============================================================
# Disk
# ============================================================

$disk = Get-CimInstance Win32_LogicalDisk `
    -Filter "DeviceID='C:'"

$freeGB = [math]::Round(
    $disk.FreeSpace / 1GB,
    2
)

Check "C: free space" ($freeGB -ge 10) "$freeGB GB free"

# ============================================================
# Internet
# ============================================================

Write-Host ""
Write-Host "NETWORK" -ForegroundColor Cyan
Write-Host ""

try {

    $internet = Test-NetConnection `
        -ComputerName "www.google.com" `
        -Port 443 `
        -InformationLevel Quiet `
        -WarningAction SilentlyContinue

    Check "Internet" $internet `
        $(if ($internet) { "HTTPS available" } else { "No HTTPS connection" })

}
catch {

    Warn "Internet" "Could not verify connection"

}

# ============================================================
# Existing software
# ============================================================

Write-Host ""
Write-Host "EXISTING DEVELOPMENT TOOLS" -ForegroundColor Cyan
Write-Host ""

# PHP
$php = Get-Command php -ErrorAction SilentlyContinue

if ($php) {

    $version = (& php -v 2>$null | Select-Object -First 1).ToString()

    Write-Host "  PHP" -ForegroundColor White
    Write-Host "      Location : $($php.Source)"
    Write-Host "      Version  : $version"

}
else {

    Warn "PHP" "Not installed"

}

# Composer
$composer = Get-Command composer -ErrorAction SilentlyContinue

if ($composer) {

    $version = (& composer --version 2>$null |
        Select-Object -First 1).ToString()

    Write-Host "  Composer" -ForegroundColor White
    Write-Host "      Location : $($composer.Source)"
    Write-Host "      Version  : $version"

}
else {

    Warn "Composer" "Not installed"

}

# MySQL
$mysql = Get-Command mysql -ErrorAction SilentlyContinue

if ($mysql) {

    $version = (& mysql --version 2>$null |
        Select-Object -First 1).ToString()

    Write-Host "  MySQL" -ForegroundColor White
    Write-Host "      Location : $($mysql.Source)"
    Write-Host "      Version  : $version"

}
else {

    Warn "MySQL" "Not installed"

}

# Python
$python = Get-Command python -ErrorAction SilentlyContinue

if ($python) {

    $version = (& python --version 2>&1 |
        Select-Object -First 1).ToString()

    Write-Host "  Python" -ForegroundColor White
    Write-Host "      Location : $($python.Source)"
    Write-Host "      Version  : $version"

}
else {

    Warn "Python" "Not installed"

}

# Git
$git = Get-Command git -ErrorAction SilentlyContinue

if ($git) {

    $version = (& git --version 2>$null |
        Select-Object -First 1).ToString()

    Write-Host "  Git" -ForegroundColor White
    Write-Host "      Location : $($git.Source)"
    Write-Host "      Version  : $version"

}
else {

    Warn "Git" "Not installed"

}

# ============================================================
# Result
# ============================================================

Write-Host ""
Write-Host "============================================================" -ForegroundColor Cyan
Write-Host "                    PREFLIGHT RESULT" -ForegroundColor Cyan
Write-Host "============================================================" -ForegroundColor Cyan
Write-Host ""

Write-Host "  Failed   : $failed"
Write-Host "  Warnings : $warnings"
Write-Host ""

if ($failed -eq 0) {

    Write-Host "  SYSTEM STATUS: READY" -ForegroundColor Green
    Write-Host ""
    Write-Host "  The computer meets the minimum requirements." `
        -ForegroundColor Green

}
else {

    Write-Host "  SYSTEM STATUS: NOT READY" -ForegroundColor Red
    Write-Host ""
    Write-Host "  Installation should not continue." `
        -ForegroundColor Red

}

Write-Host ""
Write-Host "No software was installed." -ForegroundColor Gray
Write-Host ""
