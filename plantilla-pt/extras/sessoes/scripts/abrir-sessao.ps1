# abrir-sessao.ps1 -- abre uma sessao nova do Claude Code como aba nova do
# Windows Terminal, com um nome e uma tarefa. Uso:
#   abrir-sessao.ps1 -Nome proposta-cliente -Tarefa "Monte a proposta para ..."
#   abrir-sessao.ps1 -Nome proposta-cliente -Tarefa C:\caminho\tarefa.md
#   abrir-sessao.ps1 -Nome proposta-cliente -Resume <sessionId>
# -Tarefa: o texto da tarefa, ou o caminho de um arquivo que a contem. O texto e
#   salvo em %TEMP%\cerebro-sessoes\<Nome>.tarefa.md e a sessao nova comeca
#   lendo esse arquivo (assim acentos e aspas nao quebram nada).
# -Modelo (padrao opus): SEMPRE se passa --model. Sem isso a sessao nova pega o
#   ultimo /model escolhido, e pode acabar num modelo caro que esgota o limite de
#   uso em poucas horas.
# -Esforco (opcional): low | medium | high | xhigh | max -> --effort.
# -Resume <sessionId>: retoma essa sessao (por exemplo, cortada pelo limite) numa
#   aba nova com o mesmo -Nome; -Tarefa passa a ser opcional. O id sai de
#   `claude agents --json`.
# -Pasta: onde a sessao trabalha. Padrao: a pasta atual se for um cerebro (tem
#   CLAUDE.md); se nao, $HOME\cerebro.
# -SoMostrar: monta o .cmd, mostra e NAO abre nada (para testar).
# ATENCAO: manter este arquivo 100% ASCII -- o PowerShell 5.1 le como ANSI.

param(
    [Parameter(Mandatory)] [string] $Nome,
    [string] $Tarefa,
    [string] $Modelo = 'opus',
    [ValidateSet('low','medium','high','xhigh','max')] [string] $Esforco,
    [string] $Resume,
    [string] $Pasta,
    [switch] $SoMostrar
)
$ErrorActionPreference = 'Stop'

if ($Nome -notmatch '^[A-Za-z0-9][A-Za-z0-9_-]*$') { throw "Nome invalido: so letras sem acento, numeros, - e _ ($Nome)" }
if ($Modelo -notmatch '^[A-Za-z0-9][A-Za-z0-9._\[\]-]*$') { throw "Modelo invalido: $Modelo" }
if ($Resume -and $Resume -notmatch '^[0-9a-fA-F-]{8,36}$') { throw "Resume invalido: tem que ser o sessionId ($Resume)" }
if (-not $Tarefa -and -not $Resume) { throw "Falta -Tarefa (ou -Resume <sessionId> para retomar)" }

# claude.exe: e procurado, nunca um caminho fixo.
$claude = $null
$cmdClaude = Get-Command claude -CommandType Application -ErrorAction SilentlyContinue | Select-Object -First 1
if ($cmdClaude) { $claude = $cmdClaude.Source }
elseif (Test-Path (Join-Path $env:USERPROFILE '.local\bin\claude.exe')) { $claude = Join-Path $env:USERPROFILE '.local\bin\claude.exe' }
else { throw "Nao encontro o Claude Code (claude.exe). Instale com: irm https://claude.ai/install.ps1 | iex" }

# A pasta do cerebro.
if ($Pasta) {
    if (-not (Test-Path -LiteralPath $Pasta -PathType Container)) { throw "A pasta nao existe: $Pasta" }
    $Pasta = (Resolve-Path -LiteralPath $Pasta).Path
} elseif (Test-Path (Join-Path (Get-Location).Path 'CLAUDE.md')) {
    $Pasta = (Get-Location).Path
} elseif (Test-Path (Join-Path $HOME 'cerebro')) {
    $Pasta = (Resolve-Path (Join-Path $HOME 'cerebro')).Path
} else { throw "Nao encontro a pasta do cerebro: passe com -Pasta" }

if (-not $SoMostrar -and -not (Get-Command wt.exe -ErrorAction SilentlyContinue)) {
    throw "Falta o Windows Terminal. Instale com: winget install --id Microsoft.WindowsTerminal -e"
}

$dir = Join-Path $env:TEMP 'cerebro-sessoes'
New-Item -ItemType Directory -Force $dir | Out-Null
$cmd = Join-Path $dir "$Nome.cmd"

# O .cmd e escrito em ASCII. Um caminho com acentos (p.ex. o nome de usuario)
# quebraria: o comeco e trocado por %USERPROFILE% ou %TEMP%, que o cmd expande
# bem. Se mesmo assim sobrar algo nao ASCII, para com uma mensagem clara.
function Caminho-Cmd([string]$p) {
    foreach ($par in @(@($env:TEMP, '%TEMP%'), @($env:USERPROFILE, '%USERPROFILE%'))) {
        $base = $par[0].TrimEnd('\')
        if ($p.StartsWith("$base\", [StringComparison]::OrdinalIgnoreCase) -or $p -ieq $base) {
            $p = $par[1] + $p.Substring($base.Length)
            break
        }
    }
    if ($p -match '[^\x20-\x7E]') { throw "O caminho tem acentos ou outros caracteres especiais e a aba nao consegue abrir: $p. Use uma pasta sem acentos." }
    return $p
}

if ($Tarefa) {
    if (Test-Path -LiteralPath $Tarefa -PathType Leaf) {
        $arquivoTarefa = (Resolve-Path -LiteralPath $Tarefa).Path
    } else {
        $arquivoTarefa = Join-Path $dir "$Nome.tarefa.md"
        [IO.File]::WriteAllText($arquivoTarefa, $Tarefa.Trim() + "`r`n", (New-Object System.Text.UTF8Encoding $false))
    }
    $mensaje = "Leia o arquivo $(Caminho-Cmd $arquivoTarefa): e a sua tarefa nesta sessao. Faca."
} else {
    $mensaje = "A sessao foi interrompida. Retome de onde parou."
}

# Variaveis que a sessao nova NAO pode herdar. Apagam-se todas as do Claude Code
# que a sessao que roda este script tiver, menos as que a pessoa colocou no
# Windows (ambiente de usuario ou de maquina) ou no "env" de
# ~/.claude/settings.json (p.ex. CLAUDE_CODE_PLUGIN_DIRS das barras de uso).
# Por que:
# - CLAUDE_CODE_CHILD_SESSION: a marca de "filha". Uma sessao com essa marca nao
#   salva a conversa, nao pode ser retomada e nao aparece no ListAgents.
# - CLAUDE_CODE_SESSION_ID e outras CLAUDE_*: a identidade da sessao que abre.
#   Se forem herdadas, a aba nova pode sair com o nome da outra.
# - CLAUDE_JOB_DIR: se a que abre roda em segundo plano, a nova pegava a
#   identidade dela.
# - NO_COLOR: a sessao que abre coloca isso no terminal dela e a aba nova saia
#   toda em preto e branco.
$persistentes = @()
foreach ($alcance in 'User','Machine') { $persistentes += [Environment]::GetEnvironmentVariables($alcance).Keys }
try {
    $cfg = Get-Content (Join-Path $env:USERPROFILE '.claude\settings.json') -Raw | ConvertFrom-Json
    if ($cfg.env) { $persistentes += $cfg.env.PSObject.Properties.Name }
} catch { }
$limpiar = @(Get-ChildItem env: | ForEach-Object Name |
    Where-Object { $_ -match '^(CLAUDECODE|CLAUDE_.+|NO_COLOR)$' -and $persistentes -notcontains $_ } |
    Sort-Object)
# Sempre estas, mesmo que nao estejam agora.
foreach ($v in 'CLAUDE_CODE_CHILD_SESSION','CLAUDE_JOB_DIR','CLAUDECODE','NO_COLOR') { if ($limpiar -notcontains $v) { $limpiar += $v } }
$sets = ($limpiar | ForEach-Object { "set $_=" }) -join "`r`n"

$flags = "--model $Modelo"
if ($Esforco) { $flags += " --effort $Esforco" }
if ($Resume)   { $flags += " --resume $Resume" }

# Se o claude for um .cmd (instalado com npm), vai com "call" para voltar ao exit 0.
$llamar = if ($claude -match '\.(cmd|bat)$') { 'call ' } else { '' }

# -n "<Nome>": com esse nome o ListAgents e o fechar-sessao.ps1 a encontram.
# exit 0: quando o claude termina, a aba fecha sozinha.
$contenido = @"
@echo off
$sets
cd /d "$(Caminho-Cmd $Pasta)"
$llamar"$(Caminho-Cmd $claude)" -n "$Nome" $flags "$mensaje"
exit 0
"@
Set-Content -Path $cmd -Value $contenido -Encoding ascii

if ($SoMostrar) {
    Write-Host "SoMostrar: nada foi aberto. Este e o .cmd ($cmd):"
    Write-Host $contenido
    exit 0
}

# -w 0 = a ultima janela do Windows Terminal usada (a desta sessao): aba nova
# ali, nao uma janela a mais. /c e nao /k: com /k a aba fica vazia.
Start-Process wt.exe -ArgumentList @('-w', '0', 'new-tab', '--title', $Nome, 'cmd', '/c', $cmd)
Write-Host "Aberta: $Nome ($Modelo$(if ($Esforco) {", $Esforco"})$(if ($Resume) {", retoma $Resume"})). Confirme com ListAgents ou 'claude agents --json'."
