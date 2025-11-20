# === clasificarAplicaciones.ps1 ===
# Fecha: 2025-11-20
# Autor: Antonino
# Propósito: Clasificar aplicaciones instaladas por editor, origen y prescindibilidad
# Reversibilidad: Solo lectura, sin modificar sistema
# Comentario: Parte del módulo térmico de mantenimiento institucional

function obtenerAplicacionesClasificadas {
    $fuentes = @(
        "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\*",
        "HKLM:\SOFTWARE\WOW6432Node\Microsoft\Windows\CurrentVersion\Uninstall\*",
        "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\*"
    )

    $prescindibles = @("TikTok", "CapCut", "McAfee", "WarThunder", "Candy Crush", "Xbox", "OneDrive")

    $apps = foreach ($fuente in $fuentes) {
        Get-ItemProperty $fuente -ErrorAction SilentlyContinue | Where-Object { $_.DisplayName } | ForEach-Object {
            $nombre = $_.DisplayName
            $editor = $_.Publisher
            $version = $_.DisplayVersion
            $origen = $fuente -replace 'HKLM:\\|HKCU:\\', ''
            $tipo = if ($prescindibles -contains $nombre) { "Prescindible" } else { "Funcional" }

            [PSCustomObject]@{
                nombre   = $nombre
                version  = $version
                editor   = $editor
                origen   = $origen
                tipo     = $tipo
            }
        }
    }

    return $apps
}

function exportarClasificacion {
    param (
        [array]$datos,
        [string]$ruta = "$env:USERPROFILE\Documents\clasificacion_apps.csv"
    )

    try {
        $datos | Export-Csv -Path $ruta -NoTypeInformation -Encoding UTF8
        Write-Host "`n=== RESPUESTA TÉRMICA: CLASIFICACIÓN EXPORTADA ===" -ForegroundColor DarkCyan
        Write-Host "📄 Clasificación exportada a: $ruta" -ForegroundColor Green
    } catch {
        Write-Host "❌ Error al exportar clasificación: $_" -ForegroundColor Red
    }
}

# EJECUCIÓN
$appsClasificadas = obtenerAplicacionesClasificadas
if ($appsClasificadas.Count -gt 0) {
    exportarClasificacion -datos $appsClasificadas
}
//donde