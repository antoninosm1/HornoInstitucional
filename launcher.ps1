# === launcher.ps1 ===
# Fecha: 2025-11-24
# Autor: Antonino
# Propósito: Orquestar el ciclo institucional completo
# Reversibilidad: Total (solo invoca otros módulos)
# Comentario: Ejecuta todos los módulos en orden y genera trazabilidad

Write-Host "🚀 Iniciando ciclo institucional..." -ForegroundColor Cyan

try {
    # 1. Auditoría de aplicaciones
    & "C:\HornoInstitucional\mantenimiento\auditoriaApps.ps1"

    # 2. Clasificación de aplicaciones
    & "C:\HornoInstitucional\mantenimiento\clasificarAplicaciones.ps1"

    # 3. Limpieza local
    & "C:\HornoInstitucional\mantenimiento\limpiezaLocal.ps1"

    # 4. Suspender servicios
    & "C:\HornoInstitucional\mantenimiento\suspenderServicios.ps1"

    # 5. Suspender procesos (protocolos)
    & "C:\HornoInstitucional\protocolos\suspension.ps1"

    # 6. Desinstalación de apps prescindibles (protocolos)
    & "C:\HornoInstitucional\protocolos\desinstalacion.ps1"

    # 7. Tareas programadas
    & "C:\HornoInstitucional\mantenimiento\tareasProgramadas.ps1"

    # 8. Verificación de auditoría
    & "C:\HornoInstitucional\mantenimiento\verificarAuditoria.ps1"

    # 9. Verificación post-ciclo (cierre institucional)
    & "C:\HornoInstitucional\protocolos\verificacionPost.ps1"

    Write-Host "✅ Ciclo institucional completado." -ForegroundColor Green
} catch {
    Write-Host "❌ Error durante el ciclo: $_" -ForegroundColor Red
}