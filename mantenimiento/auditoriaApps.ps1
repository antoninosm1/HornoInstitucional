# === auditoriaApps.ps1 ===
# Fecha: 2025-11-21
# Autor: Antonino
# Propósito: Obtener lista de aplicaciones instaladas y exportar a CSV
# Reversibilidad: Solo lectura
# Dependencias: PowerShell 5+
# Comentario: Parte del horno institucional de mantenimiento

function Obtener {
    $fuentes = @(
        "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\*",
        "HKLM:\SOFTWARE\WOW6432Node\Microsoft\Windows\CurrentVersion\Uninstall\*",
        "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\*"
    )

    $apps = foreach ($fuente in $fuentes) {
        Get-ItemProperty $fuente -ErrorAction SilentlyContinue | Where-Object { $_.DisplayName } | ForEach-Object {
            [PSCustomObject]@{
                nombre   = $_.DisplayName
                version  = $_.DisplayVersion
                editor   = $_.Publisher
            }
        }
    }

    return $apps
}

function Exportar {
    param (
        [string]$rutaCSV = "$env:USERPROFILE\Documents\auditoria_apps.csv"
    )
    $apps = Obtener
    Write-Host "📦 Iniciando auditoría de software instalado..." -ForegroundColor Cyan
    Write-Host "✔ Aplicaciones detectadas: $($apps.Count)" -ForegroundColor Green
    $apps | Export-Csv -Path $rutaCSV -NoTypeInformation -Encoding UTF8
    Write-Host "📄 Auditoría exportada a: $rutaCSV" -ForegroundColor Cyan
}

Exportar