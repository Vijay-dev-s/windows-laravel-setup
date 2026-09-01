function Test-Administrator {
    $identity = [Security.Principal.WindowsIdentity]::GetCurrent()
    $principal = New-Object Security.Principal.WindowsPrincipal($identity)

    return $principal.IsInRole(
        [Security.Principal.WindowsBuiltInRole]::Administrator
    )
}

function Get-SystemInformation {

    $os = Get-CimInstance Win32_OperatingSystem
    $cpu = Get-CimInstance Win32_Processor | Select-Object -First 1
    $disk = Get-CimInstance Win32_LogicalDisk -Filter "DeviceID='C:'"

    return [PSCustomObject]@{
        OS = $os.Caption
        Architecture = $os.OSArchitecture
        RAMGB = [math]::Round(
            $os.TotalVisibleMemorySize / 1MB,
            2
        )
        CPU = $cpu.Name.Trim()
        LogicalProcessors = $cpu.NumberOfLogicalProcessors
        FreeSpaceGB = [math]::Round(
            $disk.FreeSpace / 1GB,
            2
        )
    }
}

function Invoke-Preflight {

    $result = Get-SystemInformation

    Write-Host "System information:"
    Write-Host "  OS: $($result.OS)"
    Write-Host "  Architecture: $($result.Architecture)"
    Write-Host "  RAM: $($result.RAMGB) GB"
    Write-Host "  CPU: $($result.CPU)"
    Write-Host "  Logical processors: $($result.LogicalProcessors)"
    Write-Host "  C: free space: $($result.FreeSpaceGB) GB"

    return $result
}