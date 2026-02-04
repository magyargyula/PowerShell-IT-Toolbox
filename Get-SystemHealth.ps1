<#
.SYNOPSIS
    System Health Report - Rendszerállapot riport

.DESCRIPTION
    Ez a script összegyűjti a gép alapvető állapotinformációit és
    megjeleníti őket formázott szövegként a konzolon.

    Összegyűjtött adatok:
    - Számítógép neve
    - Bejelentkezett felhasználó
    - CPU használat
    - RAM használat
    - Meghajtók szabad helye
    - Utolsó rendszerindítás ideje

.EXAMPLE
    .\Get-SystemHealth.ps1

.NOTES
    Szerző: Magyar Gyula
    Dátum: 2025-02-04
    Verzió: 1.0
    Nehézség: ⭐ Kezdő
#>

# ===== FEJLÉC KIÍRÁSA =====
Write-Host ""
Write-Host "=====================================" -ForegroundColor Cyan
Write-Host "   SYSTEM HEALTH REPORT" -ForegroundColor Cyan
Write-Host "=====================================" -ForegroundColor Cyan
Write-Host ""

# ===== 1. SZÁMÍTÓGÉP NEVE =====
# A $env:COMPUTERNAME környezeti változó tartalmazza a gép nevét
$computerName = $env:COMPUTERNAME
Write-Host "Számítógép: " -NoNewline -ForegroundColor Yellow
Write-Host $computerName -ForegroundColor White

# ===== 2. BEJELENTKEZETT FELHASZNÁLÓ =====
# A $env:USERNAME környezeti változó tartalmazza a felhasználónevet
$userName = $env:USERNAME
Write-Host "Felhasználó: " -NoNewline -ForegroundColor Yellow
Write-Host $userName -ForegroundColor White

# ===== 3. CPU HASZNÁLAT =====
# A Get-Counter cmdlet lekérdezi a teljesítményszámlálókat
# A '\Processor(_Total)\% Processor Time' a CPU használatot méri
try {
    $cpuCounter = Get-Counter '\Processor(_Total)\% Processor Time' -ErrorAction Stop
    $cpuUsage = [math]::Round($cpuCounter.CounterSamples.CookedValue, 1)

    Write-Host "CPU használat: " -NoNewline -ForegroundColor Yellow
    Write-Host "$cpuUsage%" -ForegroundColor $(if ($cpuUsage -gt 80) { "Red" } elseif ($cpuUsage -gt 50) { "Yellow" } else { "Green" })
}
catch {
    Write-Host "CPU használat: " -NoNewline -ForegroundColor Yellow
    Write-Host "Nem elérhető" -ForegroundColor Red
}

# ===== 4. RAM HASZNÁLAT =====
# A Get-CimInstance cmdlet WMI/CIM információkat kérdez le
# Az Win32_OperatingSystem osztály tartalmazza a memória adatokat
try {
    $os = Get-CimInstance Win32_OperatingSystem -ErrorAction Stop

    # A TotalVisibleMemorySize és FreePhysicalMemory KB-ban van, átváltjuk GB-ra
    $totalRAM = [math]::Round($os.TotalVisibleMemorySize / 1MB, 1)
    $freeRAM = [math]::Round($os.FreePhysicalMemory / 1MB, 1)
    $usedRAM = [math]::Round($totalRAM - $freeRAM, 1)

    Write-Host "RAM: " -NoNewline -ForegroundColor Yellow
    Write-Host "$usedRAM GB / $totalRAM GB használva" -ForegroundColor White
}
catch {
    Write-Host "RAM: " -NoNewline -ForegroundColor Yellow
    Write-Host "Nem elérhető" -ForegroundColor Red
}

# ===== 5. MEGHAJTÓK SZABAD HELYE =====
# A Get-Volume cmdlet lekérdezi az összes meghajtót
# Szűrünk a betűvel ellátott meghajtókra (C:, D:, E: stb.)
Write-Host ""
Write-Host "Meghajtók:" -ForegroundColor Yellow

try {
    # Lekérjük az összes meghajtót, ami betűvel rendelkezik és NTFS/ReFS fájlrendszerű
    $drives = Get-Volume | Where-Object {
        $_.DriveLetter -ne $null -and
        $_.FileSystemType -match "NTFS|ReFS"
    } | Sort-Object DriveLetter

    foreach ($drive in $drives) {
        $driveLetter = $drive.DriveLetter
        $totalSize = [math]::Round($drive.Size / 1GB, 1)
        $freeSpace = [math]::Round($drive.SizeRemaining / 1GB, 1)
        $usedSpace = [math]::Round($totalSize - $freeSpace, 1)
        $percentFree = [math]::Round(($freeSpace / $totalSize) * 100, 1)

        # Színkódolás a szabad hely szerint
        $color = if ($percentFree -lt 10) { "Red" }
                 elseif ($percentFree -lt 20) { "Yellow" }
                 else { "Green" }

        Write-Host "  ${driveLetter}:\ " -NoNewline -ForegroundColor Cyan
        Write-Host "Szabad: $freeSpace GB / $totalSize GB " -NoNewline -ForegroundColor White
        Write-Host "($percentFree% szabad)" -ForegroundColor $color
    }
}
catch {
    Write-Host "  Hiba a meghajtók lekérdezésekor: $_" -ForegroundColor Red
}

# ===== 6. UTOLSÓ BOOTOLÁS =====
# A Win32_OperatingSystem LastBootUpTime tulajdonsága tartalmazza ezt az információt
try {
    $lastBoot = $os.LastBootUpTime

    # Formázzuk az időpontot olvasható formátumra
    $bootTime = $lastBoot.ToString("yyyy-MM-dd HH:mm")

    # Számoljuk ki mennyi ideje fut a gép
    $uptime = (Get-Date) - $lastBoot
    $uptimeText = "$($uptime.Days) nap, $($uptime.Hours) óra, $($uptime.Minutes) perc"

    Write-Host ""
    Write-Host "Utolsó bootolás: " -NoNewline -ForegroundColor Yellow
    Write-Host "$bootTime" -ForegroundColor White
    Write-Host "Uptime: " -NoNewline -ForegroundColor Yellow
    Write-Host "$uptimeText" -ForegroundColor White
}
catch {
    Write-Host ""
    Write-Host "Utolsó bootolás: " -NoNewline -ForegroundColor Yellow
    Write-Host "Nem elérhető" -ForegroundColor Red
}

# ===== LÁBLÉC =====
Write-Host ""
Write-Host "=====================================" -ForegroundColor Cyan
Write-Host "  Riport készítve: $(Get-Date -Format 'yyyy-MM-dd HH:mm:ss')" -ForegroundColor Gray
Write-Host "=====================================" -ForegroundColor Cyan
Write-Host ""
