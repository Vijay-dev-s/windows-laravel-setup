$ErrorActionPreference = "Stop"

$root = Split-Path `
    (Split-Path -Parent $MyInvocation.MyCommand.Path) `
    -Parent

$files = @(
    (Join-Path $root "install.ps1"),
    (Join-Path $root "scripts\preflight.ps1"),
    (Join-Path $root "scripts\php.ps1"),
    (Join-Path $root "scripts\composer.ps1"),
    (Join-Path $root "scripts\mysql.ps1"),
    (Join-Path $root "scripts\python.ps1"),
    (Join-Path $root "scripts\verify.ps1")
)

$failed = $false

foreach ($file in $files) {

    Write-Host "Checking $file..."

    $tokens = $null
    $errors = $null

    [System.Management.Automation.Language.Parser]::ParseFile(
        $file,
        [ref]$tokens,
        [ref]$errors
    ) | Out-Null

    if ($errors.Count -eq 0) {
        Write-Host "  PASS" -ForegroundColor Green
    }
    else {
        Write-Host "  FAIL" -ForegroundColor Red

        foreach ($error in $errors) {
            Write-Host "    $($error.Message)" -ForegroundColor Red
        }

        $failed = $true
    }
}

if ($failed) {
    exit 1
}

Write-Host ""
Write-Host "All PowerShell files passed syntax checks." `
    -ForegroundColor Green