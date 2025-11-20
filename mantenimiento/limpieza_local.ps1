# === limpieza_local.ps1 ===
# Fecha: 2025-11-18
# Autor: Antonino
# Propósito: Pendiente de definición
# Reversibilidad: [Sí/No]
# Dependencias: PowerShell 5+, permisos adecuados
# Comentario: Parte del módulo térmico de mantenimiento institucional
function limpiarCarpetasTemporales {
    param (
        [string[]]$rutas = @(
            "$env:LOCALAPPDATA\Temp",
            "$env:LOCALAPPDATA\CrashDumps",
            "$env:LOCALAPPDATA\CapCut",
            "$env:LOCALAPPDATA\TikTok",
            "$env:LOCALAPPDATA\WarThunder"
        ),
        [switch]$exportarLog,
        [string]$logPath = "$env:USERPROFILE\Documents\limpieza_log.csv"
    )

    try {
        $log = @()

        foreach ($ruta in $rutas) {
            if (Test-Path $ruta) {
                try {
                    $antes = (Get-ChildItem -Path $ruta -Recurse -ErrorAction SilentlyContinue | Measure-Object -Property Length -Sum).Sum
                    Remove-Item -Path "$ruta\*" -Recurse -Force -ErrorAction SilentlyContinue
                    $despues = (Get-ChildItem -Path $ruta -Recurse -ErrorAction SilentlyContinue | Measure-Object -Property Length -Sum).Sum

                    $log += [PSCustomObject]@{
                        carpeta        = $ruta
                        tamañoAntes    = "{0:N2} MB" -f ($antes / 1MB)
                        tamañoDespues  = "{0:N2} MB" -f ($despues / 1MB)
                        fecha          = (Get-Date).ToString("yyyy-MM-dd HH:mm")
                    }

                    Write-Host "🧹 Limpieza completada en: $ruta" -ForegroundColor Green
                } catch {
                    Write-Host "❌ Error al limpiar ${ruta}: $_" -ForegroundColor Red
                }
            } else {
                Write-Host "⚠ Carpeta no encontrada: $ruta" -ForegroundColor Yellow
            }
        }

        if ($exportarLog -and $log.Count -gt 0) {
            try {
                $log | Export-Csv -Path $logPath -NoTypeInformation -Encoding UTF8
                Write-Host "📄 Log exportado a: $logPath" -ForegroundColor Cyan
            } catch {
                Write-Host "❌ Error al exportar log: $_" -ForegroundColor Red
            }
        }
    } catch {
        Write-Host "🔥 Error general en limpieza: $_" -ForegroundColor Red
    }
}