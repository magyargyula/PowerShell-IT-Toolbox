# GitHub Push Instructions

## Parancsok

Másold be és futtasd sorban PowerShell-ben vagy Git Bash-ben:

```bash
cd "e:/Portfolio/PowerShell-IT-Toolbox"

# Add remote origin
git remote add origin https://github.com/magyargyula/PowerShell-IT-Toolbox.git

# Push to GitHub
git branch -M main
git push -u origin main
```

## Ha már létezik remote origin

Ha hibát kapsz, hogy már létezik remote, futtasd ezt:

```bash
git remote set-url origin https://github.com/magyargyula/PowerShell-IT-Toolbox.git
git push -u origin main
```

## Ellenőrzés

Menj a böngészőben ide:
https://github.com/magyargyula/PowerShell-IT-Toolbox

Látni kell:
- README.md szépen formázva
- Get-SystemHealth.ps1 script
- .gitignore fájl
- screenshots mappa
