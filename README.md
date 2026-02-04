# PowerShell IT Toolbox

> Hasznos PowerShell scriptek IT support és operations feladatokhoz

[![PowerShell](https://img.shields.io/badge/PowerShell-5.1%2B-blue.svg)](https://github.com/PowerShell/PowerShell)
[![License](https://img.shields.io/badge/license-MIT-green.svg)](LICENSE)

## Áttekintés

Ez a repo kezdő és középhaladó szintű PowerShell scripteket tartalmaz, amelyek mindennapi IT support, operations és maintenance feladatokhoz nyújtanak segítséget. Minden script jól dokumentált, magyar nyelvű kommentekkel ellátva, tanulási célokra is alkalmas.

## Motiváció

A projektet azért hoztam létre, hogy:
- **Gyakoroljam** a PowerShell scriptírást kezdő szintről
- **Dokumentáljam** a tanulási folyamatot
- **Osszam meg** hasznos eszközöket más IT szakemberekkel
- **Bemutassam** az automation és scripting készségeimet

## Scriptek listája

### 1. Get-SystemHealth.ps1

**Nehézség**: ⭐ Kezdő

**Leírás**: Összegyűjti és megjeleníti a számítógép alapvető állapotinformációit formázott, színkódolt kimenettel.

**Funkciók**:
- Számítógép név és bejelentkezett felhasználó
- CPU használat valós időben
- RAM használat (használt/összes GB)
- Meghajtók szabad helye (C:\, D:\, E:\, stb.)
- Utolsó rendszerindítás és uptime
- Színkódolás: zöld (OK), sárga (figyelem), piros (kritikus)

**Használat**:
```powershell
.\Get-SystemHealth.ps1
```

**Példa kimenet**:
```
=====================================
   SYSTEM HEALTH REPORT
=====================================

Számítógép: ACER-AN515-54
Felhasználó: magyu
CPU használat: 45.2%
RAM: 9.9 GB / 15.8 GB használva

Meghajtók:
  C:\ Szabad: 359.6 GB / 476 GB (75.5% szabad)
  D:\ Szabad: 26.5 GB / 1863 GB (1.4% szabad)  ⚠️
  E:\ Szabad: 384.6 GB / 931.5 GB (41.3% szabad)

Utolsó bootolás: 2026-01-30 14:59
Uptime: 5 nap, 0 óra, 58 perc

=====================================
  Riport készítve: 2026-02-04 15:57:45
=====================================
```

**Mit tanulsz belőle**:
- Környezeti változók használata (`$env:COMPUTERNAME`, `$env:USERNAME`)
- WMI/CIM lekérdezések (`Get-CimInstance`)
- Teljesítményszámlálók (`Get-Counter`)
- Meghajtók kezelése (`Get-Volume`)
- Hibakezelés (`try/catch`)
- Színkódolt kimenet (`Write-Host -ForegroundColor`)
- Matematikai műveletek (`[math]::Round()`)
- Dátum formázás (`Get-Date -Format`)

---

## Telepítés

1. **Klónozd a repot**:
   ```bash
   git clone https://github.com/magyargyula/PowerShell-IT-Toolbox.git
   cd PowerShell-IT-Toolbox
   ```

2. **Execution Policy beállítása** (ha szükséges):
   ```powershell
   Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser
   ```

3. **Script futtatása**:
   ```powershell
   .\Get-SystemHealth.ps1
   ```

## Követelmények

- **Windows 10/11** vagy **Windows Server 2016+**
- **PowerShell 5.1** vagy újabb
- **Adminisztrátori jogosultság** (opcionális, de ajánlott a teljes funkcionalitáshoz)

## Használati javaslatok

### IT Support környezetben
- Gyors rendszerállapot ellenőrzés remote support esetén
- Proaktív monitoring script részeként
- Helpdesk ticket információgyűjtéshez

### Tanulási célokra
- Minden script részletesen kommentezett
- Fokozatos nehézségi szint (⭐ → ⭐⭐⭐)
- Best practices bemutatása

## Fejlesztési terv

Tervezett további scriptek:
- **Temp Folder Cleanup Tool** - Régi temp fájlok törlése
- **Service Status Monitor** - Kritikus szolgáltatások ellenőrzése
- **User Account Info Tool** - Local user account információk
- **Disk Space Alert** - Email értesítés alacsony disk space esetén

## Közreműködés

Szívesen fogadok javaslatokat, hibajelentéseket és pull requesteket!

1. Fork-old a projektet
2. Hozz létre egy feature branch-et (`git checkout -b feature/UjScript`)
3. Commit-old a változtatásokat (`git commit -m 'feat: Új script hozzáadása'`)
4. Push-old a branch-et (`git push origin feature/UjScript`)
5. Nyiss egy Pull Request-et

## Licenc

MIT License - lásd [LICENSE](LICENSE) fájl a részletekért.

## Szerző

**Magyar Gyula**
- Portfolio: [magyargyula.github.io](https://magyargyula.github.io)
- GitHub: [@magyargyula](https://github.com/magyargyula)

---

## Verziónapló

### v1.0.0 (2025-02-04)
- Kezdeti verzió
- `Get-SystemHealth.ps1` script hozzáadása
- Alapvető dokumentáció

---

> **Megjegyzés**: Ez a projekt tanulási és portfólió célokat szolgál. Használat előtt mindig teszteld a scripteket nem-production környezetben!
