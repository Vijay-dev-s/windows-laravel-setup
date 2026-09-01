function Get-InstalledPHPVersion {

    param(
        [string]$PhpExecutable
    )

    if (-not (Test-Path $PhpExecutable)) {
        return $null
    }

    try {
        $version = & $PhpExecutable -r "echo PHP_VERSION;" 2>$null

        if ($LASTEXITCODE -eq 0) {
            return $version.Trim()
        }
    }
    catch {
        return $null
    }

    return $null
}

function Test-PHP85 {

    param(
        [string]$PhpDirectory = "C:\php"
    )

    $phpExecutable = Join-Path $PhpDirectory "php.exe"

    $version = Get-InstalledPHPVersion $phpExecutable

    if ($null -eq $version) {
        return $false
    }

    return $version -match "^8\.5\."
}

function Install-PHP85 {

    param(
        [string]$PhpDirectory = "C:\php",
        [string]$DownloadUrl
    )

    Write-Host "PHP 8.5 installation will be performed here."
    Write-Host "Target: $PhpDirectory"
    Write-Host "Source: $DownloadUrl"

    # Actual installation comes after Windows testing.
}