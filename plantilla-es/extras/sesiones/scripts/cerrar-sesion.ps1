# cerrar-sesion.ps1 -- cierra SOLO la pestana de una sesion abierta con
# abrir-sesion.ps1. Mata su claude.exe (con su arbol); el cmd /c sigue al exit 0
# y la pestana se va sola. Nunca cierra la ventana (ahi estan esta sesion y las
# otras pestanas). Uso:
#   cerrar-sesion.ps1 -Nombre propuesta-cliente
# La encuentra por nombre, nueva o retomada con -Resume, porque abrir-sesion.ps1
# siempre pasa `-n "<Nombre>"`. Si hay dos con el mismo nombre, no cierra ninguna.
# OJO: mantener este archivo 100% ASCII -- PowerShell 5.1 lo lee como ANSI.

param([Parameter(Mandatory)] [string] $Nombre)

if ($Nombre -notmatch '^[A-Za-z0-9][A-Za-z0-9_-]*$') { throw "Nombre invalido: $Nombre" }

# claude.exe (instalador oficial) o node.exe (si se instalo con npm).
$procs = @(Get-CimInstance Win32_Process |
    Where-Object { $_.Name -in 'claude.exe','node.exe' -and $_.CommandLine -like "*-n `"$Nombre`"*" })

if ($procs.Count -gt 1) {
    $procs | ForEach-Object { Write-Host ("  PID {0}: {1}" -f $_.ProcessId, $_.CommandLine) }
    throw "Hay $($procs.Count) sesiones '$Nombre': no cierro ninguna. Elegi el PID a mano."
}
if ($procs.Count -eq 0) { Write-Host "No hay ninguna sesion '$Nombre' abierta."; exit 0 }

# Solo ese PID, con su arbol. Nunca taskkill por nombre (mataria todas las
# sesiones) ni el cmd.exe padre (deja la pestana colgada).
taskkill /PID $procs[0].ProcessId /T /F | Out-Null
Write-Host "Cerrada: $Nombre (PID $($procs[0].ProcessId))"
