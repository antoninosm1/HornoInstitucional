# === clasificarAplicaciones.ps1 ===
# Fecha: 2025-11-21
# Autor: Antonino
# Propósito: Clasificar aplicaciones instaladas según criterios institucionales
# Reversibilidad: Solo lectura
# Dependencias: PowerShell 5+
# Comentario: Parte del horno institucional de mantenimiento

function obtenerAplicacionesClasificadas {
    $apps = Import-Csv "$env:USERPROFILE\Documents\auditoria_apps.csv"

    $clasificadas = foreach ($app in $apps) {
        $categoria = "Indefinida"

        if ($app.editor -like "*Microsoft*") { $categoria = "Microsoft" }
        elseif ($app.editor -like "*Adobe*") { $categoria = "Adobe" }
        elseif ($app.editor -like "*Oracle*") { $categoria = "Oracle" }
        elseif ($app.editor -like "*Google*") { $categoria = "Google" }

        [PSCustomObject]@{
            nombre    = $app.nombre
            version   = $app.version
            editor    = $app.editor
            categoria = $categoria
        }
    }

    return $clasificadas
}

function exportarClasificacion {
    param (
        [string]$rutaCSV = "$env:USERPROFILE\Documents\clasificacion_apps.csv"
    )

    try {
        $clasificadas = obtenerAplicacionesClasificadas
        $clasificadas | Export-Csv -Path $rutaCSV -NoTypeInformation -Encoding UTF8
        Write-Host "📄 Clasificación exportada a: $rutaCSV" -ForegroundColor Cyan
    } catch {
        Write-Host "❌ Error al exportar clasificación: $_" -ForegroundColor Red
    }
}

exportarClasificacion