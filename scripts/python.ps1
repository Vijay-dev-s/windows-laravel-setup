function Test-Python {

    $python = Get-Command python -ErrorAction SilentlyContinue

    return $null -ne $python
}

function Get-PythonVersion {

    if (-not (Test-Python)) {
        return $null
    }

    try {
        return (& python --version 2>&1 |
            Select-Object -First 1).ToString().Trim()
    }
    catch {
        return $null
    }
}

function Test-PythonVenv {

    if (-not (Test-Python)) {
        return $false
    }

    try {
        & python -c "import venv" 2>$null

        return $LASTEXITCODE -eq 0
    }
    catch {
        return $false
    }
}

function Create-ProjectVenv {

    param(
        [string]$ProjectDirectory
    )

    $venvDirectory = Join-Path $ProjectDirectory ".venv"

    if (-not (Test-Path $venvDirectory)) {

        & python -m venv $venvDirectory

        if ($LASTEXITCODE -ne 0) {
            throw "Failed to create Python virtual environment."
        }
    }
}