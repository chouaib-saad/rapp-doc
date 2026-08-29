# ============================================================
# Construction du rapport depuis PowerShell.
#   Usage : .\build.ps1            (document main)
#           .\build.ps1 -Job main
#
# Équivalent natif Windows de build.sh. Applique le meme correctif
# d'environnement, execute trois passes, verifie l'integrite du PDF
# et publie un rapport de construction.
# ============================================================

param([string]$Job = "main")

$ErrorActionPreference = "Continue"
Set-Location -Path $PSScriptRoot
if (-not (Test-Path "build")) { New-Item -ItemType Directory "build" | Out-Null }

# ── Correctif d'environnement (voir README_BUILD.md) ────────
# MiKTeX parcourt chaque entree de PATH comme un repertoire. Une
# entree qui designe un FICHIER (par exemple WMIC.exe) interrompt
# l'execution au moment de finaliser le PDF, qui reste TRONQUE.
# On assainit PATH pour ce processus uniquement.
$clean = ($env:PATH -split ';') | Where-Object {
    $_ -and ($_ -notmatch '\.exe\s*$')
}
$env:PATH = ($clean -join ';')

$passes = 3
for ($i = 1; $i -le $passes; $i++) {
    Write-Host "=== passe $i/$passes ==="
    & pdflatex --enable-installer -interaction=nonstopmode `
        -output-directory=build "$Job.tex" *> "build\.pass$i.log"
}

$log = "build\$Job.log"
$pdf = "build\$Job.pdf"
$status = 0

Write-Host ""
Write-Host "================ RAPPORT DE CONSTRUCTION ================"

if (-not (Test-Path $pdf)) {
    Write-Host "PDF          : NON PRODUIT"
    $status = 1
} else {
    # Un PDF valide se termine par %%EOF. Son absence signale la troncature.
    $tailBytes = Get-Content $pdf -AsByteStream -Tail 2048 -ErrorAction SilentlyContinue
    $tailText = [System.Text.Encoding]::ASCII.GetString($tailBytes)
    if ($tailText -match '%%EOF') {
        $logText = (Get-Content $log -Raw -ErrorAction SilentlyContinue) -replace "`r?`n", ""
        $pages = if ($logText -match '\((\d+)\s+pages') { $Matches[1] } else { "?" }
        Write-Host "PDF          : $pdf"
        Write-Host "Pages        : $pages"
        Write-Host "Integrite    : COMPLET (marqueur de fin present)"
    } else {
        Write-Host "PDF          : $pdf"
        Write-Host "Integrite    : TRONQUE. Le marqueur de fin est absent."
        Write-Host "               Cause probable : une entree de PATH pointant vers un fichier."
        $status = 1
    }
}

$logLines = if (Test-Path $log) { Get-Content $log } else { @() }

$errors = @($logLines | Select-String -Pattern '^!')
Write-Host ""
Write-Host "--- Erreurs LaTeX : $($errors.Count) ---"
if ($errors.Count -gt 0) { $errors | Select-Object -First 20 | ForEach-Object { Write-Host $_ }; $status = 1 }

$undef = @($logLines | Select-String -Pattern 'Reference .* undefined|Citation .* undefined')
Write-Host ""
Write-Host "--- Renvois ou citations non resolus : $($undef.Count) ---"
if ($undef.Count -gt 0) { $undef | Select-Object -First 20 | ForEach-Object { Write-Host $_ }; $status = 1 }

$over = @($logLines | Select-String -Pattern 'Overfull \\hbox')
Write-Host ""
Write-Host "--- Debordements horizontaux : $($over.Count) ---"
if ($over.Count -gt 0) { $over | Select-Object -First 10 | ForEach-Object { Write-Host $_ } }

$missing = @($logLines | Select-String -Pattern 'File .* not found|Unable to load picture')
Write-Host ""
Write-Host "--- Images introuvables : $($missing.Count) ---"
if ($missing.Count -gt 0) { $missing | Select-Object -First 10 | ForEach-Object { Write-Host $_ }; $status = 1 }

Write-Host ""
if ($status -eq 0) {
    Write-Host "RESULTAT     : CONSTRUCTION REUSSIE"
} else {
    Write-Host "RESULTAT     : ECHEC. Voir les points signales ci-dessus."
}
Write-Host "========================================================"

Remove-Item "build\.pass*.log" -ErrorAction SilentlyContinue
exit $status
