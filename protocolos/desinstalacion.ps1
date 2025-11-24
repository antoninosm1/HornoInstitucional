# === dependencias.ps1 ===
# Fecha: 2025-11-24
# Autor: Antonino
# Propósito: Verificar dependencias y versiones necesarias para el horno institucional
# Reversibilidad: Solo lectura
# Comentario: Comprueba que módulos y versiones estén disponibles

function verificarDependencias {
    Write-Host "🔍 Verificando dependencias..." -ForegroundColor Cyan

    $requisitos = @(
        @{ nombre = "PowerShell"; version = 5 },
        @{ nombre = "Git"; version = "2.0" }
    )

    foreach ($req in $requisitos) {
        try {
            if ($req.nombre -eq "PowerShell") {
                $actual = $PSVersionTable.PSVersion.Major
                if ($actual -ge $req.version) {
                    Write-Host "✅ $($req.nombre) versión $actual OK" -ForegroundColor Green
                } else {
                    Write-Host "❌ $($req.nombre) versión insuficiente: $actual" -ForegroundColor Red
                }
            }
            elseif ($req.nombre -eq "Git") {
                $gitVersion = git --version
                Write-Host "✅ $gitVersion detectado" -ForegroundColor Green
            }
        } catch {
            Write-Host "❌ Dependencia faltante: $($req.nombre)" -ForegroundColor Red
        }
    }
}

verificarDependencias