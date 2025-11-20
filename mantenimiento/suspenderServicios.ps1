# === suspension_servicios.ps1 ===
# Fecha: 2025-11-18
# Autor: Antonino
# Propósito: Pendiente de definición
# Reversibilidad: [Sí/No]
# Dependencias: PowerShell 5+, permisos adecuados
# Comentario: Parte del módulo térmico de mantenimiento institucional
# === suspenderServicios.ps1 ===
# Fecha: 2025-11-20
# Autor: Antonino
# Propósito: Suspender servicios prescindibles con reversibilidad y trazabilidad térmica
# Reversibilidad: Servicios pueden reactivarse manualmente o por script
# Comentario: Parte del módulo térmico de mantenimiento institucional

function suspenderServicios {
    param (
        [string[]]$servicios = @(
            "DiagTrack",       # Telemetría
            "WMPNetworkSvc",   # Windows Media Player
            "XboxGipSvc",      # Xbox Game Monitoring
            "XblAuthManager",  # Xbox Live Auth
            "XblGameSave",     # Xbox Game Save
            "OneSyncSvc",      # Sincronización de cuentas
            "MapsBroker",      # Servicio de mapas
            "RetailDemo"       # Modo demo
        ),
        [switch]$exportarLog,
        [string]$logPath = "$env:USERPROFILE\Documents\suspension_servicios_log.csv"
    )

    $log = @()

    foreach ($nombre in $servicios) {
        try {
            $estado = Get-Service -Name $nombre -ErrorAction SilentlyContinue
            if ($estado.Status -ne 'Stopped') {
                Stop-Service -Name $nombre -Force -ErrorAction SilentlyContinue
                Set-Service -Name $nombre -StartupType Disabled
                $log += [PSCustomObject]@{
                    servicio   = $nombre
                    estado     = "Suspendido"
                    fecha      = (Get-Date).ToString("yyyy-MM-dd HH:mm")
                }
                Write-Host "🛑 Servicio suspendido: $nombre" -ForegroundColor Green
            } else {
                Write-Host "⚠ Ya estaba detenido: $nombre" -ForegroundColor Yellow
            }
        } catch {
            Write-Host "❌ Error al suspender ${nombre}: $_" -ForegroundColor Red
        }
    }

    if ($exportarLog -and $log.Count -gt 0) {
        try {
            $log | Export-Csv -Path $logPath -NoTypeInformation -Encoding UTF8
            Write-Host "`n=== RESPUESTA TÉRMICA: LOG EXPORTADO ===" -ForegroundColor DarkCyan
            Write-Host "📄 Log exportado a: $logPath" -ForegroundColor Cyan
        } catch {
            Write-Host "❌ Error al exportar log: $_" -ForegroundColor Red
        }
    }
}

# EJECUCIÓN
suspenderServicios -exportarLog