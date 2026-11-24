# Guarda la clave de Groq del dictado por voz. Lo corre la persona en su propia ventana:
# Claude nunca ve la clave. La clave queda solo en .env, al lado de main.py (fuera de cualquier repo).
$ErrorActionPreference = 'Stop'
$aqui = Split-Path -Parent $MyInvocation.MyCommand.Path
Write-Host ""
Write-Host "Clave de Groq para el dictado / Chave do Groq para o ditado" -ForegroundColor Cyan
Write-Host "Pega la clave (empieza con gsk_) y toca Enter. No se ve mientras la pegas."
Write-Host "Cole a chave (comeca com gsk_) e aperte Enter. Ela nao aparece enquanto voce cola."
$seguro = Read-Host 'Clave / Chave' -AsSecureString
$clave = [Runtime.InteropServices.Marshal]::PtrToStringAuto([Runtime.InteropServices.Marshal]::SecureStringToBSTR($seguro))
$clave = "$clave".Trim()
if (-not $clave.StartsWith('gsk_') -or $clave.Length -lt 20) {
  Write-Host "Esa clave no parece de Groq (tiene que empezar con gsk_). Volve a intentar. / Essa chave nao parece do Groq. Tente de novo." -ForegroundColor Red
  Read-Host 'Enter para cerrar / fechar'
  exit 1
}
[IO.File]::WriteAllText((Join-Path $aqui '.env'), "GROQ_API_KEY=$clave`n", (New-Object System.Text.UTF8Encoding $false))
$clave = $null
Write-Host "Listo, guardada. Ya podes cerrar esta ventana y volver a Claude. / Pronto, salva. Pode fechar esta janela e voltar ao Claude." -ForegroundColor Green
Read-Host 'Enter para cerrar / fechar'
