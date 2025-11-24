# === tareasProgramadas.ps1 ===
# Fecha: 2025-11-21
# Autor: Antonino
# Propósito: Registrar, listar y eliminar tareas térmicas institucionales
# Reversibilidad: Total
# Dependencias: PowerShell 5+, permisos de administrador
# Comentario: Parte del horno institucional de mantenimiento

function registrarTareaProgramada {
    param (
        [string]$nombre,
        [string]$script,
        [string]$hora = "03:00"
    )
    try {
        $accion = New-ScheduledTaskAction -Execute "powershell.exe" -Argument "-File `"$script`""
        $trigger = New-ScheduledTaskTrigger -Daily -At $hora
        Register-ScheduledTask -TaskName $nombre -Action $accion -Trigger $trigger -RunLevel Highest -Force
        Write-Host "✅ Tarea registrada: $nombre" -ForegroundColor Green
    } catch {
        Write-Host "❌ Error al registrar tarea: $_" -ForegroundColor Red
    }
}

function eliminarTareaProgramada {
    param ([string]$nombre)
    try {
        Unregister-ScheduledTask -TaskName $nombre -Confirm:$false
        Write-Host "🗑️ Tarea eliminada: $nombre" -ForegroundColor Yellow
    } catch {
        Write-Host "❌ Error al eliminar tarea: $_" -ForegroundColor Red
    }
}

function listarTareasInstitucionales {
    try {
        Get-ScheduledTask | Where-Object { $_.TaskName -like "*" } |
        Select-Object TaskName, State, LastRunTime | Format-Table -AutoSize
    } catch {
        Write-Host "❌ Error al listar tareas: $_" -ForegroundColor Red
    }
}

# EJEMPLOS DE USO:
# registrarTareaProgramada -nombre "AuditoriaSemanal" -script "C:\HornoInstitucional\mantenimiento\auditoriaApps.ps1" -hora "02:00"
# registrarTareaProgramada -nombre "LimpiezaDiaria" -script "C:\HornoInstitucional\mantenimiento\limpiezaLocal.ps1" -hora "01:00"
# listarTareasInstitucionales
# eliminarTareaProgramada -nombre "AuditoriaSemanal"