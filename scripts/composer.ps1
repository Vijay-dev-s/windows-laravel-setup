function Test-Composer {

    $composer = Get-Command composer -ErrorAction SilentlyContinue

    return $null -ne $composer
}

function Get-ComposerVersion {

    if (-not (Test-Composer)) {
        return $null
    }

    try {
        return (& composer --version 2>$null |
            Select-Object -First 1).ToString().Trim()
    }
    catch {
        return $null
    }
}

function Install-Composer {

    Write-Host "Composer installation will be performed here."

    # Actual installation comes after Windows testing.
}