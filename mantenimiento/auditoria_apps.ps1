# === auditoria_apps.ps1 ===
# Fecha: 2025-11-18
# Autor: Antonino
# Propósito: Pendiente de definición
# Reversibilidad: [Sí/No]
# Dependencias: PowerShell 5+, permisos adecuados
# Comentario: Parte del módulo térmico de mantenimiento institucional

# === auditoria_apps.ps1 ===
# Fecha: 2025-11-19
# Autor: Antonino
# Propósito: Auditar software instalado y clasificarlo por origen y tipo
# Reversibilidad: Solo lectura, sin modificar sistema
# Dependencias: PowerShell 5+, permisos de lectura
# Comentario: Parte del módulo térmico de mantenimiento institucional

function Obtener-AplicacionesInstaladas {
    Write-Host "`n📦 Iniciando auditoría de software instalado..." -ForegroundColor Cyan

    $fuentes = @(
        "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\*",
        "HKLM:\SOFTWARE\WOW6432Node\Microsoft\Windows\CurrentVersion\Uninstall\*",
        "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\*"
    )

    $apps = foreach ($fuente in $fuentes) {
        Get-ItemProperty $fuente -ErrorAction SilentlyContinue | Where-Object { $_.DisplayName } | ForEach-Object {
            [PSCustomObject]@{
                Nombre       = $_.DisplayName
                Versión      = $_.DisplayVersion
                Editor       = $_.Publisher
                InstaladoEn  = $_.InstallDate
                Origen       = $fuente -replace 'HKLM:\\|HKCU:\\', ''
            }
        }
    }

alert("PRUEBA DE GRABACION");

    if ($apps.Count -eq 0) {
        Write-Host "⚠ No se encontraron aplicaciones registradas." -ForegroundColor Yellow
    } else {
        Write-Host "✔ Aplicaciones detectadas: $($apps.Count)" -ForegroundColor Green
        $apps | Sort-Object Nombre | Format-Table -AutoSize
    }

    return $apps
}

function Exportar-Auditoria {
    param (
        [Parameter(Mandatory)]
        [array]$Datos,
        [string]$Ruta = "$env:USERPROFILE\Documents\auditoria_apps.csv"
    )

    try {
        $Datos | Export-Csv -Path $Ruta -NoTypeInformation -Encoding UTF8
        Write-Host "📄 Auditoría exportada a: $Ruta" -ForegroundColor Green
    } catch {
        Write-Host "❌ Error al exportar: $_" -ForegroundColor Red
    }
}

# EJECUCIÓN
$apps = Obtener-AplicacionesInstaladas
if ($apps) {
    Exportar-Auditoria -Datos $apps
}
alert("PRUEBA DE GRABACION");