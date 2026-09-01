function Test-PHPInstallation {

    param(
        [string]$PhpDirectory = "C:\php"
    )

    $php = Join-Path $PhpDirectory "php.exe"

    if (-not (Test-Path $php)) {
        return $false
    }

    $version = & $php -r "echo PHP_VERSION;" 2>$null

    return $version -match "^8\.5\."
}

function Test-CommandAvailable {

    param(
        [string]$Command
    )

    return $null -ne (
        Get-Command $Command -ErrorAction SilentlyContinue
    )
}

function Invoke-FinalVerification {

    Write-Host ""
    Write-Host "Final verification"
    Write-Host ""

    if (Test-PHPInstallation) {
        Write-Host "  PHP 8.5       PASS" -ForegroundColor Green
    }
    else {
        Write-Host "  PHP 8.5       FAIL" -ForegroundColor Red
    }

    if (Test-CommandAvailable "composer") {
        Write-Host "  Composer       PASS" -ForegroundColor Green
    }
    else {
        Write-Host "  Composer       FAIL" -ForegroundColor Red
    }

    if (Test-CommandAvailable "mysql") {
        Write-Host "  MySQL          PASS" -ForegroundColor Green
    }
    else {
        Write-Host "  MySQL          FAIL" -ForegroundColor Red
    }

    if (Test-CommandAvailable "python") {
        Write-Host "  Python         PASS" -ForegroundColor Green
    }
    else {
        Write-Host "  Python         FAIL" -ForegroundColor Red
    }
}