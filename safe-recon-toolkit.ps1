<#
.SYNOPSIS
    Low Country Cyber - Safe Recon Toolkit

.DESCRIPTION
    This PowerShell script provides a simple menu-driven interface to perform a quick, read-only reconnaissance on a Windows system.
    It gathers key system and security-related information within a 60-second window and exports the results to timestamped folders 
    under C:\ReconReport.

.CURRENT FEATURES
    - Collects comprehensive system information (Get-ComputerInfo)
    - Lists local user accounts (Get-LocalUser)
    - Enumerates running services (Get-Service)
    - Lists running processes (Get-Process)
    - Retrieves scheduled tasks (Get-ScheduledTask)
    - Shows listening TCP network connections (Get-NetTCPConnection)
    - Enumerates installed programs from registry (Uninstall key)
    - All data is exported as plain text files in a dedicated output folder
    - Runs tasks as background jobs to complete efficiently within 60 seconds
    - Simple menu UI for ease of use and repeatability

.UPCOMING FEATURES (Planned)
    - Optional extended recon for domain environment data (e.g., AD users/groups, GPO info)
    - Integration of event log summaries focused on security events (failed logins, privilege escalations)
    - Inclusion of firewall configuration audit and status reports
    - Enhanced output formats (CSV, JSON) for easier analysis and reporting
    - Configurable scan duration and output path via parameters
    - Automated email or upload of reports for remote review
    - User-friendly error handling and logging enhancements

.NOTES
    - This script is strictly read-only; it does not modify system settings.
    - Running as Administrator may provide richer data but is not required.
    - Designed for quick initial audits and baseline assessments.

#>

# ReconToolkit.ps1
$OutputFolder = "C:\ReconReport"
if (!(Test-Path $OutputFolder)) { New-Item -ItemType Directory -Path $OutputFolder }

function Show-Menu {
    Clear-Host
    Write-Host "=== Low Country Cyber - Safe Recon Toolkit ===" -ForegroundColor Cyan
    Write-Host "1. Run 60-Second Recon"
    Write-Host "2. Exit"
    Write-Host ""
}

function Run-Recon {
    Write-Host "Recon starting... Running for 60 seconds." -ForegroundColor Yellow

    $timestamp = Get-Date -Format "yyyyMMdd-HHmmss"
    $sessionFolder = Join-Path $OutputFolder "Recon-$timestamp"
    New-Item -ItemType Directory -Path $sessionFolder | Out-Null

    # Run each info-gathering function in background jobs
    Start-Job { Get-ComputerInfo | Out-File "$using:sessionFolder\SystemInfo.txt" }
    Start-Job { Get-LocalUser | Out-File "$using:sessionFolder\LocalUsers.txt" }
    Start-Job { Get-Service | Out-File "$using:sessionFolder\Services.txt" }
    Start-Job { Get-Process | Out-File "$using:sessionFolder\Processes.txt" }
    Start-Job { Get-ScheduledTask | Out-File "$using:sessionFolder\ScheduledTasks.txt" }
    Start-Job { Get-NetTCPConnection | Where-Object { $_.State -eq "Listen" } | Out-File "$using:sessionFolder\ListeningPorts.txt" }
    Start-Job {
        Get-ItemProperty HKLM:\Software\Wow6432Node\Microsoft\Windows\CurrentVersion\Uninstall\* |
        Select-Object DisplayName, DisplayVersion, Publisher, InstallDate |
        Out-File "$using:sessionFolder\InstalledPrograms.txt"
    }

    # Wait up to 60 seconds for all jobs to complete
    $endTime = (Get-Date).AddSeconds(60)
    do {
        $jobs = Get-Job | Where-Object { $_.State -eq 'Running' }
        Start-Sleep -Seconds 2
    } while ($jobs -and (Get-Date) -lt $endTime)

    # Cleanup jobs
    Get-Job | Receive-Job -ErrorAction SilentlyContinue | Out-Null
    Get-Job | Remove-Job

    Write-Host "Recon complete. Reports saved to:" -ForegroundColor Green
    Write-Host $sessionFolder
    Pause
}

# Main Menu Loop
do {
    Show-Menu
    $choice = Read-Host "Enter your choice"

    switch ($choice) {
        '1' { Run-Recon }
        '2' { break }
        default { Write-Host "Invalid choice. Please enter 1 or 2." -ForegroundColor Red; Pause }
    }
} while ($true)
