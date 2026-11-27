# fechar-sessao.ps1 -- fecha SO a aba de uma sessao aberta com abrir-sessao.ps1.
# Mata o claude.exe dela (com a arvore); o cmd /c segue para o exit 0 e a aba
# fecha sozinha. Nunca fecha a janela (ali estao esta sessao e as outras abas). Uso:
#   fechar-sessao.ps1 -Nome proposta-cliente
# Encontra pelo nome, nova ou retomada com -Resume, porque abrir-sessao.ps1
# sempre passa `-n "<Nome>"`. Se houver duas com o mesmo nome, nao fecha nenhuma.
# ATENCAO: manter este arquivo 100% ASCII -- o PowerShell 5.1 le como ANSI.

param([Parameter(Mandatory)] [string] $Nome)

if ($Nome -notmatch '^[A-Za-z0-9][A-Za-z0-9_-]*$') { throw "Nome invalido: $Nome" }

# claude.exe (instalador oficial) ou node.exe (se foi instalado com npm).
$procs = @(Get-CimInstance Win32_Process |
    Where-Object { $_.Name -in 'claude.exe','node.exe' -and $_.CommandLine -like "*-n `"$Nome`"*" })

if ($procs.Count -gt 1) {
    $procs | ForEach-Object { Write-Host ("  PID {0}: {1}" -f $_.ProcessId, $_.CommandLine) }
    throw "Ha $($procs.Count) sessoes '$Nome': nao fecho nenhuma. Escolha o PID a mao."
}
if ($procs.Count -eq 0) { Write-Host "Nao ha nenhuma sessao '$Nome' aberta."; exit 0 }

# So esse PID, com a arvore. Nunca taskkill por nome (mataria todas as sessoes)
# nem o cmd.exe pai (deixa a aba travada).
taskkill /PID $procs[0].ProcessId /T /F | Out-Null
Write-Host "Fechada: $Nome (PID $($procs[0].ProcessId))"
