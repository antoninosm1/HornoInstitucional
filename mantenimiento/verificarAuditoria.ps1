# === verificarAuditoria.ps1 ===
# Fecha: 2025-11-24
# Autor: Antonino
# Propósito: Comparar auditoría previa con clasificación actual
# Reversibilidad: Solo lectura
# Comentario: Exporta diferencias en log CSV

function compararAuditoria {
    param (
        [string]$archivoAnterior = "$env:USERPROFILE\Documents\auditoria_apps.csv",
        [string]$archivoActual   = "$env:USERPROFILE\Documents\clasificacion_apps.csv"
    )

    Write-Host "Comparando auditoría anterior con clasificación actual..." -ForegroundColor Cyan

    try {
        $anterior = Import-Csv $archivoAnterior
        $actual   = Import-Csv $archivoActual

        $eliminadas = Compare-Object $anterior $actual -Property Name -PassThru | Where-Object { $_.SideIndicator -eq '<=' }
        $nuevas     = Compare-Object $anterior $actual -Property Name -PassThru | Where-Object { $_.SideIndicator -eq '=>' }

        Write-Host "Eliminadas: $($eliminadas.Count)" -ForegroundColor Yellow
        Write-Host "Nuevas: $($nuevas.Count)" -ForegroundColor Green

        $logPath = "$env:USERPROFILE\Documents\verificacion_auditoria_log.csv"
        $resultado = @()
        $resultado += [PSCustomObject]@{ Tipo = "Eliminadas"; Cantidad = $eliminadas.Count; Fecha = (Get-Date) }
        $resultado += [PSCustomObject]@{ Tipo = "Nuevas"; Cantidad = $nuevas.Count; Fecha = (Get-Date) }

        $resultado | Export-Csv -Path $logPath -NoTypeInformation -Encoding UTF8
        Write-Host "Log de verificación exportado a: $logPath" -ForegroundColor Cyan
    } catch {
        Write-Host "Error en verificación de auditoría: $_" -ForegroundColor Red
    }
}

# Ejecutar función automáticamente
compararAuditoria