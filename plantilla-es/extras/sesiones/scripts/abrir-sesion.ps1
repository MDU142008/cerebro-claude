# abrir-sesion.ps1 -- abre una sesion nueva de Claude Code como pestana nueva de
# Windows Terminal, con un nombre y una tarea. Uso:
#   abrir-sesion.ps1 -Nombre propuesta-cliente -Tarea "Arma la propuesta para ..."
#   abrir-sesion.ps1 -Nombre propuesta-cliente -Tarea C:\ruta\tarea.md
#   abrir-sesion.ps1 -Nombre propuesta-cliente -Resume <sessionId>
# -Tarea: el texto de la tarea, o la ruta de un archivo que la tiene. El texto se
#   guarda en %TEMP%\cerebro-sesiones\<Nombre>.tarea.md y la sesion nueva arranca
#   leyendo ese archivo (asi los acentos y las comillas no rompen nada).
# -Modelo (por defecto opus): SIEMPRE se pasa --model. Sin esto la sesion nueva
#   toma el ultimo /model que se eligio, y puede terminar en un modelo caro que
#   agota el limite de uso en pocas horas.
# -Esfuerzo (opcional): low | medium | high | xhigh | max -> --effort.
# -Resume <sessionId>: retoma esa sesion (por ejemplo, cortada por el limite) en
#   una pestana nueva con el mismo -Nombre; -Tarea pasa a ser opcional. El id sale
#   de `claude agents --json`.
# -Carpeta: donde trabaja la sesion. Por defecto, la carpeta actual si es un
#   cerebro (tiene CLAUDE.md); si no, $HOME\cerebro.
# -SoloMostrar: arma el .cmd, lo muestra y NO abre nada (para probar).
# OJO: mantener este archivo 100% ASCII -- PowerShell 5.1 lo lee como ANSI.

param(
    [Parameter(Mandatory)] [string] $Nombre,
    [string] $Tarea,
    [string] $Modelo = 'opus',
    [ValidateSet('low','medium','high','xhigh','max')] [string] $Esfuerzo,
    [string] $Resume,
    [string] $Carpeta,
    [switch] $SoloMostrar
)
$ErrorActionPreference = 'Stop'

if ($Nombre -notmatch '^[A-Za-z0-9][A-Za-z0-9_-]*$') { throw "Nombre invalido: solo letras sin acento, numeros, - y _ ($Nombre)" }
if ($Modelo -notmatch '^[A-Za-z0-9][A-Za-z0-9._\[\]-]*$') { throw "Modelo invalido: $Modelo" }
if ($Resume -and $Resume -notmatch '^[0-9a-fA-F-]{8,36}$') { throw "Resume invalido: tiene que ser el sessionId ($Resume)" }
if (-not $Tarea -and -not $Resume) { throw "Falta -Tarea (o -Resume <sessionId> para retomar)" }

# claude.exe: se busca, nunca una ruta fija.
$claude = $null
$cmdClaude = Get-Command claude -CommandType Application -ErrorAction SilentlyContinue | Select-Object -First 1
if ($cmdClaude) { $claude = $cmdClaude.Source }
elseif (Test-Path (Join-Path $env:USERPROFILE '.local\bin\claude.exe')) { $claude = Join-Path $env:USERPROFILE '.local\bin\claude.exe' }
else { throw "No encuentro Claude Code (claude.exe). Instalalo con: irm https://claude.ai/install.ps1 | iex" }

# La carpeta del cerebro.
if ($Carpeta) {
    if (-not (Test-Path -LiteralPath $Carpeta -PathType Container)) { throw "No existe la carpeta: $Carpeta" }
    $Carpeta = (Resolve-Path -LiteralPath $Carpeta).Path
} elseif (Test-Path (Join-Path (Get-Location).Path 'CLAUDE.md')) {
    $Carpeta = (Get-Location).Path
} elseif (Test-Path (Join-Path $HOME 'cerebro')) {
    $Carpeta = (Resolve-Path (Join-Path $HOME 'cerebro')).Path
} else { throw "No encuentro la carpeta del cerebro: pasala con -Carpeta" }

if (-not $SoloMostrar -and -not (Get-Command wt.exe -ErrorAction SilentlyContinue)) {
    throw "Falta Windows Terminal. Instalalo con: winget install --id Microsoft.WindowsTerminal -e"
}

$dir = Join-Path $env:TEMP 'cerebro-sesiones'
New-Item -ItemType Directory -Force $dir | Out-Null
$cmd = Join-Path $dir "$Nombre.cmd"

# El .cmd se escribe en ASCII. Una ruta con acentos (p.ej. el nombre de usuario)
# se romperia: se reemplaza el comienzo por %USERPROFILE% o %TEMP%, que cmd
# expande bien. Si aun asi queda algo no ASCII, se frena con un mensaje claro.
function Ruta-Cmd([string]$p) {
    foreach ($par in @(@($env:TEMP, '%TEMP%'), @($env:USERPROFILE, '%USERPROFILE%'))) {
        $base = $par[0].TrimEnd('\')
        if ($p.StartsWith("$base\", [StringComparison]::OrdinalIgnoreCase) -or $p -ieq $base) {
            $p = $par[1] + $p.Substring($base.Length)
            break
        }
    }
    if ($p -match '[^\x20-\x7E]') { throw "La ruta tiene acentos u otros caracteres especiales y la pestana no la puede abrir: $p. Usa una carpeta sin acentos." }
    return $p
}

if ($Tarea) {
    if (Test-Path -LiteralPath $Tarea -PathType Leaf) {
        $archivoTarea = (Resolve-Path -LiteralPath $Tarea).Path
    } else {
        $archivoTarea = Join-Path $dir "$Nombre.tarea.md"
        [IO.File]::WriteAllText($archivoTarea, $Tarea.Trim() + "`r`n", (New-Object System.Text.UTF8Encoding $false))
    }
    $mensaje = "Lee el archivo $(Ruta-Cmd $archivoTarea): es tu tarea en esta sesion. Hacela."
} else {
    $mensaje = "Se corto la sesion. Retoma donde quedaste."
}

# Variables que NO tiene que heredar la sesion nueva. Se borran todas las de
# Claude Code que tenga la sesion que corre este script, salvo las que la persona
# puso en Windows (entorno de usuario o de maquina) o en el "env" de
# ~/.claude/settings.json (p.ej. CLAUDE_CODE_PLUGIN_DIRS de las barras de uso).
# Por que:
# - CLAUDE_CODE_CHILD_SESSION: la marca de "hija". Una sesion con esa marca no
#   guarda la charla, no se puede retomar y no aparece en ListAgents.
# - CLAUDE_CODE_SESSION_ID y otras CLAUDE_*: la identidad de la sesion que abre.
#   Si se heredan, la pestana nueva puede salir con el nombre de la otra.
# - CLAUDE_JOB_DIR: si la que abre corre de fondo, la nueva tomaba su identidad.
# - NO_COLOR: la sesion que abre se lo pone a su terminal y la pestana nueva
#   salia toda en blanco y negro.
$persistentes = @()
foreach ($alcance in 'User','Machine') { $persistentes += [Environment]::GetEnvironmentVariables($alcance).Keys }
try {
    $cfg = Get-Content (Join-Path $env:USERPROFILE '.claude\settings.json') -Raw | ConvertFrom-Json
    if ($cfg.env) { $persistentes += $cfg.env.PSObject.Properties.Name }
} catch { }
$limpiar = @(Get-ChildItem env: | ForEach-Object Name |
    Where-Object { $_ -match '^(CLAUDECODE|CLAUDE_.+|NO_COLOR)$' -and $persistentes -notcontains $_ } |
    Sort-Object)
# Siempre estas, aunque no esten ahora.
foreach ($v in 'CLAUDE_CODE_CHILD_SESSION','CLAUDE_JOB_DIR','CLAUDECODE','NO_COLOR') { if ($limpiar -notcontains $v) { $limpiar += $v } }
$sets = ($limpiar | ForEach-Object { "set $_=" }) -join "`r`n"

$flags = "--model $Modelo"
if ($Esfuerzo) { $flags += " --effort $Esfuerzo" }
if ($Resume)   { $flags += " --resume $Resume" }

# Si claude es un .cmd (instalado con npm), va con "call" para volver al exit 0.
$llamar = if ($claude -match '\.(cmd|bat)$') { 'call ' } else { '' }

# -n "<Nombre>": con ese nombre la ven ListAgents y cerrar-sesion.ps1.
# exit 0: cuando termina claude, la pestana se cierra sola.
$contenido = @"
@echo off
$sets
cd /d "$(Ruta-Cmd $Carpeta)"
$llamar"$(Ruta-Cmd $claude)" -n "$Nombre" $flags "$mensaje"
exit 0
"@
Set-Content -Path $cmd -Value $contenido -Encoding ascii

if ($SoloMostrar) {
    Write-Host "SoloMostrar: no se abrio nada. Este es el .cmd ($cmd):"
    Write-Host $contenido
    exit 0
}

# -w 0 = la ultima ventana de Windows Terminal que se uso (la de esta sesion):
# pestana nueva ahi, no una ventana mas. /c y no /k: con /k la pestana queda vacia.
Start-Process wt.exe -ArgumentList @('-w', '0', 'new-tab', '--title', $Nombre, 'cmd', '/c', $cmd)
Write-Host "Abierta: $Nombre ($Modelo$(if ($Esfuerzo) {", $Esfuerzo"})$(if ($Resume) {", retoma $Resume"})). Confirmala con ListAgents o 'claude agents --json'."
