# === verificarAuditoria.ps1 ===
# Fecha: 2025-11-20
# Autor: Antonino
# Propósito: Comparar auditoría previa con estado actual del sistema
# Reversibilidad: Solo lectura, sin modificar sistema
# Comentario: Parte del módulo térmico de mantenimiento institucional

function obtenerAplicacionesActuales {
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

function compararAuditoria {
    param (
        [string]$rutaCSV = "$env:USERPROFILE\Documents\auditoria_apps.csv"
    )

    Write-Host "`n=== RESPUESTA TÉRMICA: INICIO DE COMPARACIÓN ===" -ForegroundColor DarkCyan

    if (-not (Test-Path $rutaCSV)) {
        Write-Host "❌ Archivo de auditoría no encontrado: $rutaCSV" -ForegroundColor Red
        return
    }

    try {
        $previas = Import-Csv -Path $rutaCSV
        $actuales = obtenerAplicacionesActuales

        $nuevas = Compare-Object $previas $actuales -Property nombre -PassThru | Where-Object { $_.SideIndicator -eq '=>' }
        $eliminadas = Compare-Object $previas $actuales -Property nombre -PassThru | Where-Object { $_.SideIndicator -eq '<=' }

        Write-Host "`n=== RESPUESTA TÉRMICA: CAMBIOS DETECTADOS ===" -ForegroundColor DarkCyan
        Write-Host "🆕 Nuevas aplicaciones: $($nuevas.Count)" -ForegroundColor Green
        Write-Host "🗑️ Eliminadas desde la última auditoría: $($eliminadas.Count)" -ForegroundColor Yellow

        if ($nuevas.Count -gt 0) {
            $nuevas | Format-Table nombre, version, editor -AutoSize
        }

        if ($eliminadas.Count -gt 0) {
            $eliminadas | Format-Table nombre, version, editor -AutoSize
        }
    } catch {
        Write-Host "❌ Error al comparar auditoría: $_" -ForegroundColor Red
    }
}

# EJECUCIÓN
compararAuditoria