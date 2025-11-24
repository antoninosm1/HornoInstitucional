# === verificacionPost.ps1 ===
# Fecha: 2025-11-24
# Autor: Antonino
# Propósito: Verificar estado del sistema después del ciclo institucional
# Reversibilidad: Solo lectura
# Comentario: Genera log final de verificación

function verificacionPost {
    $logPath = "$env:USERPROFILE\Documents\verificacion_post_log.csv"
    $fecha = Get-Date -Format "yyyy-MM-dd HH:mm"

    Write-Host "📋 Iniciando verificación post-ciclo..." -ForegroundColor Cyan

    $estado = @()

    # Verificar auditoría
    try {
        Import-Csv "$env:USERPROFILE\Documents\auditoria_apps.csv" | Out-Null
        $estado += [PSCustomObject]@{ chequeo = "Auditoría"; resultado = "OK"; fecha = $fecha }
    } catch {
        $estado += [PSCustomObject]@{ chequeo = "Auditoría"; resultado = "Fallo"; fecha = $fecha }
    }

    # Verificar clasificación
    try {
        Import-Csv "$env:USERPROFILE\Documents\clasificacion_apps.csv" | Out-Null
        $estado += [PSCustomObject]@{ chequeo = "Clasificación"; resultado = "OK"; fecha = $fecha }
    } catch {
        $estado += [PSCustomObject]@{ chequeo = "Clasificación"; resultado = "Fallo"; fecha = $fecha }
    }

    # Exportar resultados
    $estado | Export-Csv -Path $logPath -NoTypeInformation -Encoding UTF8
    Write-Host "📄 Log de verificación exportado a: $logPath" -ForegroundColor Cyan
}

verificacionPost