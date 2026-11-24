<# :
@echo off
rem Instalador del cerebro de Claude. Doble clic y seguir lo que dice.
powershell -NoProfile -ExecutionPolicy Bypass -Command "$f='%~f0'; $env:CEREBRO_PAQUETE='%~dp0'; iex ([IO.File]::ReadAllText($f, [Text.Encoding]::UTF8))"
echo.
pause
exit /b
#>

# ---- PowerShell desde aca (el bloque de arriba lo saltea) ----
$ErrorActionPreference = 'Stop'
$Paquete  = $env:CEREBRO_PAQUETE.TrimEnd('\')
$Destino  = if ($env:CEREBRO_DESTINO) { $env:CEREBRO_DESTINO } else { Join-Path $HOME 'cerebro' }
$Prueba   = $env:CEREBRO_PRUEBA -eq '1'   # solo para probar: no toca ~/.claude ni crea acceso directo
$ClaudeDir = if ($env:CEREBRO_CLAUDE_DIR) { $env:CEREBRO_CLAUDE_DIR } else { Join-Path $HOME '.claude' }

function Paso($n, $t) { Write-Host ""; Write-Host "[$n/8] $t" -ForegroundColor Cyan }
function Ok($t)       { Write-Host "   OK  $t" -ForegroundColor Green }
function Aviso($t)    { Write-Host "   OJO $t" -ForegroundColor Yellow }
function Frenar($t)   { Write-Host ""; Write-Host "   NO SE PUDO: $t" -ForegroundColor Red; Write-Host "   Mandale una foto de esta pantalla a quien te paso este link."; exit 1 }
function Refrescar-Path {
  $env:Path = [Environment]::GetEnvironmentVariable('Path','Machine') + ';' + [Environment]::GetEnvironmentVariable('Path','User')
  $local = Join-Path $HOME '.local\bin'
  if (Test-Path $local) { $env:Path = "$local;$env:Path" }
}
function Hay($cmd) { [bool](Get-Command $cmd -ErrorAction SilentlyContinue) }
function Python-Real { try { $v = & python --version 2>&1; return ($v -match 'Python 3') } catch { return $false } }
function Instalar-Programa($id, $extra) {
  $a = @('install','--id',$id,'-e','--silent','--accept-package-agreements','--accept-source-agreements') + $extra
  & winget.exe @a | Out-Host
  Refrescar-Path
}

Write-Host "Instalador de Mi cerebro (Claude Code)" -ForegroundColor White
Write-Host "Tarda unos minutos. Si Windows pregunta si permitis cambios, toca 'Si'."
$Idioma = if ($env:CEREBRO_IDIOMA) { $env:CEREBRO_IDIOMA } else { '' }
while (@('es','pt') -notcontains "$Idioma".Trim().ToLower()) { $Idioma = Read-Host '   Idioma de tu sistema / Idioma do seu sistema (es = espanol, pt = portugues)'; if ($null -eq $Idioma) { Frenar 'no pude leer el idioma.' } }
$Idioma = $Idioma.Trim().ToLower()
$Plantilla = "plantilla-$Idioma"
$ModsSrc   = "mods-$Idioma"
$Atajo     = if ($Idioma -eq 'pt') { 'Meu cerebro' } else { 'Mi cerebro' }
$Primero   = if ($Idioma -eq 'pt') { '/comecar' } else { '/empezar' }
if (-not (Test-Path (Join-Path $Paquete "$Plantilla\CLAUDE.md"))) { Frenar "no encuentro la carpeta '$Plantilla' al lado de este archivo. Descomprimi todo el paquete antes." }

# 1. winget
Paso 1 'Revisando la compu'
Refrescar-Path
if (-not (Hay 'winget')) { Frenar "falta 'Instalador de aplicaciones' (App Installer). Instalalo desde la Microsoft Store y volve a abrir este archivo." }
Ok 'Windows listo'

# 2. Git (guarda el historial del cerebro para poder volver atras)
Paso 2 'Git (historial para volver atras)'
if (-not (Hay 'git')) { Instalar-Programa 'Git.Git' @(); if (-not (Hay 'git')) { Frenar 'Git no quedo instalado.' } }
Ok (git --version)

# 3. Python + yt-dlp (subtitulos de videos)
Paso 3 'Python (para leer videos de YouTube)'
if (-not (Python-Real)) {
  Instalar-Programa 'Python.Python.3.13' @('--override','/quiet InstallAllUsers=0 PrependPath=1 Include_launcher=1')
  if (-not (Python-Real)) { Frenar 'Python no quedo instalado.' }
}
& python -m pip install --user --quiet --disable-pip-version-check --upgrade yt-dlp
if ($LASTEXITCODE -ne 0) { Aviso 'no se pudo instalar yt-dlp (solo afecta a /video).' } else { Ok ((& python --version 2>&1) + ' + yt-dlp') }

# 4. uv (lo usa Windows MCP, que deja a Claude manejar programas de la compu)
Paso 4 'uv y Node (para Windows MCP y Playwright)'
if (-not (Hay 'uvx')) { Instalar-Programa 'astral-sh.uv' @() }
if (Hay 'uvx') { Ok 'uv listo' } else { Aviso 'uv no quedo instalado: Windows MCP no va a andar (lo demas si).' }
if (-not (Hay 'npx')) { Instalar-Programa 'OpenJS.NodeJS.LTS' @() }
if (Hay 'npx') { Ok 'Node listo (para Playwright)' } else { Aviso 'Node no quedo instalado: Playwright no va a andar (lo demas si).' }

# 5. Claude Code
Paso 5 'Claude Code'
Refrescar-Path
if (-not (Hay 'claude')) {
  & powershell -NoProfile -ExecutionPolicy Bypass -Command 'irm https://claude.ai/install.ps1 | iex' | Out-Host
  $local = Join-Path $HOME '.local\bin'
  $userPath = [Environment]::GetEnvironmentVariable('Path','User')
  if ($userPath -notlike "*$local*") { [Environment]::SetEnvironmentVariable('Path', "$local;$userPath", 'User') }
  Refrescar-Path
  if (-not (Hay 'claude')) { Frenar 'Claude Code no quedo instalado.' }
}
Ok ((& claude --version 2>&1) | Select-Object -First 1)

# 6. La carpeta del cerebro (nunca pisa lo que ya existe)
Paso 6 "Tu carpeta 'cerebro'"
$nueva = -not (Test-Path (Join-Path $Destino 'CLAUDE.md'))
& powershell -NoProfile -ExecutionPolicy Bypass -File (Join-Path $Paquete 'herramientas\copiar-plantilla.ps1') -Plantilla (Join-Path $Paquete $Plantilla) -Destino $Destino | Select-Object -Last 1 | Out-Host
if ($LASTEXITCODE -ne 0) { Frenar 'no se pudo copiar la carpeta.' }
$origen = @{ repo = $Paquete; idioma = $Idioma } | ConvertTo-Json
[IO.File]::WriteAllText((Join-Path $Destino '.claude\origen.json'), $origen, (New-Object System.Text.UTF8Encoding $false))
if (-not (Test-Path (Join-Path $Destino '.git'))) {
  $nombre = if ($env:CEREBRO_NOMBRE) { $env:CEREBRO_NOMBRE } else { '' }
  while ("$nombre".Trim().Length -lt 2) { $nombre = Read-Host '   Tu nombre'; if ($null -eq $nombre) { Frenar 'no pude leer el nombre.' } }
  cmd /c "git -C ""$Destino"" init -q 2>&1" | Out-Null
  git -C $Destino config user.name $nombre.Trim()
  git -C $Destino config user.email 'cerebro@local'
  cmd /c "git -C ""$Destino"" config core.autocrlf false 2>&1" | Out-Null
  cmd /c "git -C ""$Destino"" add -A 2>&1" | Out-Null
  cmd /c "git -C ""$Destino"" commit -q -m ""Cerebro nuevo"" 2>&1" | Out-Null
}
if ($nueva) { Ok "cerebro nuevo en $Destino" } else { Ok "ya existia en ${Destino}: solo se sumaron archivos que faltaban, no se piso nada" }

# 7. Herramientas de Claude para tu usuario (mods, plugins, Windows MCP)
Paso 7 'Herramientas (barras de uso y cache, navegador, Windows MCP)'
$mods = Join-Path $ClaudeDir 'mods'
New-Item -ItemType Directory -Force $mods | Out-Null
foreach ($m in 'uso','cache-reloj') { Copy-Item -Recurse -Force (Join-Path $Paquete "$ModsSrc\$m") $mods }
$setPath = Join-Path $ClaudeDir 'settings.json'
$set = if (Test-Path $setPath) { Get-Content $setPath -Raw -Encoding UTF8 | ConvertFrom-Json } else { New-Object PSObject }
if (-not $set.PSObject.Properties['env']) { $set | Add-Member -NotePropertyName env -NotePropertyValue (New-Object PSObject) }
$dirs = @("$mods\uso", "$mods\cache-reloj")
$prev = if ($set.env.PSObject.Properties['CLAUDE_CODE_PLUGIN_DIRS']) { $set.env.CLAUDE_CODE_PLUGIN_DIRS -split ';' | Where-Object { $_ } } else { @() }
$todos = @($prev) + ($dirs | Where-Object { $prev -notcontains $_ })
$set.env | Add-Member -Force -NotePropertyName CLAUDE_CODE_PLUGIN_DIRS -NotePropertyValue ($todos -join ';')
if (Test-Path $setPath) { Copy-Item $setPath "$setPath.antes-del-cerebro" -Force }
[IO.File]::WriteAllText($setPath, ($set | ConvertTo-Json -Depth 30), (New-Object System.Text.UTF8Encoding $false))
Ok 'barras de uso (contexto, 5 h, semana) y de cache'
if (-not $Prueba) {
  cmd /c "claude plugin marketplace add anthropics/claude-plugins-official 2>&1" | Out-Null
  foreach ($p in 'playwright@claude-plugins-official','skill-creator@claude-plugins-official') {
    cmd /c "claude plugin install $p 2>&1" | Out-Host
  }
  if (Hay 'uvx') {
    cmd /c "claude mcp remove -s user windows-mcp 2>&1" | Out-Null
    cmd /c "claude mcp add -s user windows-mcp -e ANONYMIZED_TELEMETRY=false -- uvx windows-mcp serve 2>&1" | Out-Host
  }
  Ok 'Playwright (navegador propio), skill-creator (crear herramientas) y Windows MCP'
} else { Ok '(prueba: sin plugins ni MCP)' }

# 8. Acceso directo
Paso 8 'Acceso directo en el escritorio'
if (-not $Prueba) {
  $escritorio = [Environment]::GetFolderPath('Desktop')
  $sh  = New-Object -ComObject WScript.Shell
  $lnk = $sh.CreateShortcut((Join-Path $escritorio "$Atajo.lnk"))
  $lnk.TargetPath       = (Get-Command powershell).Source
  $lnk.Arguments        = '-NoExit -NoProfile -Command "claude"'
  $lnk.WorkingDirectory = $Destino
  $lnk.Save()
  Ok "'$Atajo' en el escritorio"
} else { Ok '(prueba: sin acceso directo)' }

Write-Host ""
Write-Host "LISTO." -ForegroundColor Green
Write-Host "1. Abri '$Atajo' en el escritorio. La primera vez, Claude pide entrar con TU cuenta en el navegador."
Write-Host "2. Escribi:  $Primero"
Write-Host "3. Para Chrome: instala la extension 'Claude' desde la Chrome Web Store y en Claude escribi /chrome."
