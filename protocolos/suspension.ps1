# === suspension.ps1 ===
# Fecha: 2025-11-24
# Autor: Antonino
# Propósito: Suspender procesos temporales o prescindibles
# Reversibilidad: Total
# Comentario: Detiene procesos en ejecución

function suspenderProceso {
    param (
        [string]$Nombre
    )

    Write-Host "⏸️ Intentando suspender proceso: $Nombre" -ForegroundColor Yellow

    try {
        $proc = Get-Process -Name $Nombre -ErrorAction Stop
        Stop-Process -Id $proc.Id -Force

        $resultado = [PSCustomObject]@{ Proceso = $Nombre; Estado = "Suspendido"; Fecha = (Get-Date) }

        Write-Host "✅ Proceso suspendido: $Nombre" -ForegroundColor Green
        return $resultado
    } catch {
        Write-Host "❌ No se pudo suspender $Nombre. Error: $_" -ForegroundColor Red
    }
}

# Ejemplo de uso:
# suspenderProceso -Nombre "notepad"