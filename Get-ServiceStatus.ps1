#Requires -Version 5.1
<#
.SYNOPSIS
    Kritikus Windows szolgaltatasok allapotellenorzese.

.DESCRIPTION
    Ez a script ellenorzi a legfontosabb Windows szolgaltatasok allapotat
    (fut/leall/felfuggesztve) es szinkodolt kimenetet general.
    IT Support es rendszeruzemeltetes soran hasznos a gyors diagnosztikara.

.NOTES
    Fajlnev   : Get-ServiceStatus.ps1
    Szerzo    : Magyar Gyula
    Verzio    : 1.0
    Letrehozva: 2026-02-05

.EXAMPLE
    .\Get-ServiceStatus.ps1
    Megjeleníti a kritikus szolgaltatasok allapotat szinkodoltan.

.LINK
    https://github.com/magyargyula/PowerShell-IT-Toolbox
#>

# ===== KONFIGURACIO =====
# Kritikus szolgaltatasok listaja (bovitheto)
$CriticalServices = @(
    @{ Name = "wuauserv";      DisplayName = "Windows Update" }
    @{ Name = "BITS";          DisplayName = "Background Intelligent Transfer" }
    @{ Name = "Spooler";       DisplayName = "Print Spooler" }
    @{ Name = "WinRM";         DisplayName = "Windows Remote Management" }
    @{ Name = "EventLog";      DisplayName = "Windows Event Log" }
    @{ Name = "Schedule";      DisplayName = "Task Scheduler" }
    @{ Name = "W32Time";       DisplayName = "Windows Time" }
    @{ Name = "Dhcp";          DisplayName = "DHCP Client" }
    @{ Name = "Dnscache";      DisplayName = "DNS Client" }
    @{ Name = "LanmanServer";  DisplayName = "Server (File Sharing)" }
    @{ Name = "LanmanWorkstation"; DisplayName = "Workstation" }
    @{ Name = "RpcSs";         DisplayName = "Remote Procedure Call (RPC)" }
)

# ===== FEJLEC =====
Clear-Host
Write-Host ""
Write-Host "=============================================" -ForegroundColor Cyan
Write-Host "   WINDOWS SZOLGALTATAS ALLAPOT ELLENORZES   " -ForegroundColor Cyan
Write-Host "=============================================" -ForegroundColor Cyan
Write-Host ""
Write-Host "Szamitogep: $env:COMPUTERNAME" -ForegroundColor White
Write-Host "Datum:      $(Get-Date -Format 'yyyy-MM-dd HH:mm:ss')" -ForegroundColor White
Write-Host ""
Write-Host "---------------------------------------------" -ForegroundColor Gray

# ===== SZOLGALTATASOK ELLENORZESE =====
$RunningCount = 0
$StoppedCount = 0
$NotFoundCount = 0

foreach ($svc in $CriticalServices) {
    $ServiceName = $svc.Name
    $FriendlyName = $svc.DisplayName

    try {
        $Service = Get-Service -Name $ServiceName -ErrorAction Stop
        $Status = $Service.Status
        $StartType = $Service.StartType

        # Allapot szerinti szinkodolas
        switch ($Status) {
            "Running" {
                $StatusText = "[RUNNING]"
                $Color = "Green"
                $RunningCount++
            }
            "Stopped" {
                $StatusText = "[STOPPED]"
                $Color = "Red"
                $StoppedCount++
            }
            "Paused" {
                $StatusText = "[PAUSED] "
                $Color = "Yellow"
                $StoppedCount++
            }
            default {
                $StatusText = "[$Status]"
                $Color = "Yellow"
            }
        }

        # Kimenet formatazasa
        $OutputLine = "{0,-12} {1,-35} ({2})" -f $StatusText, $FriendlyName, $StartType
        Write-Host $OutputLine -ForegroundColor $Color

    } catch {
        # Szolgaltatas nem talalhato
        $StatusText = "[NOTFOUND]"
        $OutputLine = "{0,-12} {1,-35}" -f $StatusText, $FriendlyName
        Write-Host $OutputLine -ForegroundColor DarkGray
        $NotFoundCount++
    }
}

# ===== OSSZEGZES =====
Write-Host ""
Write-Host "---------------------------------------------" -ForegroundColor Gray
Write-Host ""
Write-Host "OSSZEGZES:" -ForegroundColor Cyan

# Statisztika szinkodoltan
Write-Host "  Futo szolgaltatasok:     " -NoNewline
Write-Host "$RunningCount" -ForegroundColor Green

Write-Host "  Leallitott/szuneteltetett: " -NoNewline
if ($StoppedCount -gt 0) {
    Write-Host "$StoppedCount" -ForegroundColor Red
} else {
    Write-Host "$StoppedCount" -ForegroundColor Green
}

Write-Host "  Nem talalhato:           " -NoNewline
Write-Host "$NotFoundCount" -ForegroundColor DarkGray

Write-Host ""

# Allapot ertekeles
if ($StoppedCount -eq 0) {
    Write-Host "ALLAPOT: Minden kritikus szolgaltatas fut!" -ForegroundColor Green
} elseif ($StoppedCount -le 2) {
    Write-Host "ALLAPOT: Figyelem - $StoppedCount szolgaltatas nem fut!" -ForegroundColor Yellow
} else {
    Write-Host "ALLAPOT: KRITIKUS - $StoppedCount szolgaltatas leallitva!" -ForegroundColor Red
}

Write-Host ""
Write-Host "=============================================" -ForegroundColor Cyan
Write-Host ""

# ===== LEALLITOTT SZOLGALTATASOK RESZLETEI =====
$StoppedServices = $CriticalServices | ForEach-Object {
    $svc = Get-Service -Name $_.Name -ErrorAction SilentlyContinue
    if ($svc -and $svc.Status -ne "Running") {
        [PSCustomObject]@{
            Name = $_.DisplayName
            ServiceName = $_.Name
            Status = $svc.Status
        }
    }
}

if ($StoppedServices) {
    Write-Host "Leallitott szolgaltatasok ujrainditasa:" -ForegroundColor Yellow
    Write-Host ""
    foreach ($stopped in $StoppedServices) {
        Write-Host "  Start-Service -Name '$($stopped.ServiceName)'" -ForegroundColor DarkYellow
    }
    Write-Host ""
}
