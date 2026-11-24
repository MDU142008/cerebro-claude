# Copia la plantilla al cerebro (instalar) o trae lo nuevo (actualizar), SIN pisar lo que la persona cambio.
# Lleva un registro (.claude/plantilla.json) con el hash de cada archivo tal como se instalo:
#   - archivo nuevo en la plantilla            -> se copia            (NUEVO)
#   - archivo que la persona no toco           -> se actualiza        (ACTUALIZADO)
#   - archivo que la persona cambio o es suyo  -> no se toca          (TUYO)
#   - archivo que la persona borro             -> no se vuelve a poner (BORRADO)
# Una skill activada o desactivada (movida entre extras/ y .claude/skills/) se sigue en su lugar nuevo.
param(
  [Parameter(Mandatory)] [string]$Plantilla,
  [Parameter(Mandatory)] [string]$Destino
)
$ErrorActionPreference = 'Stop'
$Plantilla = (Resolve-Path $Plantilla).Path.TrimEnd('\')
New-Item -ItemType Directory -Force $Destino | Out-Null
$Destino = (Resolve-Path $Destino).Path.TrimEnd('\')
$regPath = Join-Path $Destino '.claude\plantilla.json'
$reg = @{}
if (Test-Path $regPath) {
  $obj = Get-Content $regPath -Raw -Encoding UTF8 | ConvertFrom-Json
  foreach ($p in $obj.PSObject.Properties) { $reg[$p.Name] = $p.Value }
}
function Hash($f) { (Get-FileHash -Algorithm SHA256 -LiteralPath $f).Hash }
function Lugar($rel) {
  # Donde esta hoy ese archivo en el cerebro (sigue skills activadas o desactivadas).
  $d = Join-Path $Destino $rel
  if (Test-Path -LiteralPath $d) { return $rel }
  if ($rel -like 'extras\*') { $alt = '.claude\skills\' + $rel.Substring(7) }
  elseif ($rel -like '.claude\skills\*') { $alt = 'extras\' + $rel.Substring(15) }
  else { return $rel }
  $skill = ($alt -split '\\')[0..($(if ($alt -like 'extras\*') {1} else {2}))] -join '\'
  if (Test-Path -LiteralPath (Join-Path $Destino $skill)) { return $alt }
  return $rel
}
$res = [ordered]@{ NUEVO = @(); ACTUALIZADO = @(); TUYO = @(); BORRADO = @(); IGUAL = @() }
$nuevoReg = @{}
Get-ChildItem -LiteralPath $Plantilla -Recurse -File -Force | ForEach-Object {
  $rel = $_.FullName.Substring($Plantilla.Length + 1)
  $hOrigen = Hash $_.FullName
  $relDest = Lugar $rel
  $dest = Join-Path $Destino $relDest
  $instalado = $reg[$rel]
  if (-not (Test-Path -LiteralPath $dest)) {
    if ($instalado) { $res.BORRADO += $rel; $nuevoReg[$rel] = $instalado; return }
    New-Item -ItemType Directory -Force (Split-Path -Parent $dest) | Out-Null
    Copy-Item -LiteralPath $_.FullName $dest -Force
    $res.NUEVO += $relDest; $nuevoReg[$rel] = $hOrigen; return
  }
  $hDest = Hash $dest
  if ($hDest -eq $hOrigen) { $res.IGUAL += $relDest; $nuevoReg[$rel] = $hOrigen; return }
  if ($instalado -and $hDest -eq $instalado) {
    Copy-Item -LiteralPath $_.FullName $dest -Force
    $res.ACTUALIZADO += $relDest; $nuevoReg[$rel] = $hOrigen; return
  }
  $res.TUYO += $relDest
  $nuevoReg[$rel] = $(if ($instalado) { $instalado } else { $hDest })
}
New-Item -ItemType Directory -Force (Split-Path -Parent $regPath) | Out-Null
[IO.File]::WriteAllText($regPath, ($nuevoReg | ConvertTo-Json -Depth 3), (New-Object System.Text.UTF8Encoding $false))
foreach ($k in 'NUEVO','ACTUALIZADO','TUYO','BORRADO') { foreach ($f in $res[$k]) { "{0,-12} {1}" -f $k, $f } }
"RESUMEN nuevos={0} actualizados={1} tuyos-sin-tocar={2} borrados-por-vos={3} iguales={4}" -f $res.NUEVO.Count, $res.ACTUALIZADO.Count, $res.TUYO.Count, $res.BORRADO.Count, $res.IGUAL.Count
