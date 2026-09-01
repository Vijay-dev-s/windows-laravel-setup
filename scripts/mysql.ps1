function Test-MySQL {

    $mysql = Get-Command mysql -ErrorAction SilentlyContinue

    return $null -ne $mysql
}

function Get-MySQLVersion {

    if (-not (Test-MySQL)) {
        return $null
    }

    try {
        return (& mysql --version 2>$null |
            Select-Object -First 1).ToString().Trim()
    }
    catch {
        return $null
    }
}

function Install-MySQL {

    Write-Host "MySQL 8.4 installation will be performed here."

    # Actual installation comes after Windows testing.
}