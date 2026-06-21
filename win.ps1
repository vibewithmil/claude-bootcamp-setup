$ErrorActionPreference = "Stop"

function Write-Step($m) { Write-Host ""; Write-Host "==> $m" -ForegroundColor Cyan }
function Write-Ok($m)   { Write-Host "    [ok] $m" -ForegroundColor Green }
function Write-Warn($m) { Write-Host "    [!] $m" -ForegroundColor Yellow }

function Refresh-Path {
  $machine = [Environment]::GetEnvironmentVariable("Path", "Machine")
  $user    = [Environment]::GetEnvironmentVariable("Path", "User")
  $env:Path = "$machine;$user"
  foreach ($p in @("C:\Program Files\nodejs", "$env:APPDATA\npm")) {
    if ((Test-Path $p) -and ($env:Path -notlike "*$p*")) { $env:Path = "$p;$env:Path" }
  }
}

function Has($command) { return $null -ne (Get-Command $command -ErrorAction SilentlyContinue) }

function Winget-Install($id, $name) {
  Write-Step "Installing $name"
  winget install --id $id --exact --silent --accept-package-agreements --accept-source-agreements 2>&1 | Out-Null
  # 0 = installed; -1978335189 / -1978335212 = already installed or no applicable upgrade
  if ($LASTEXITCODE -eq 0) { Write-Ok "$name installed" }
  elseif ($LASTEXITCODE -eq -1978335189 -or $LASTEXITCODE -eq -1978335212) { Write-Ok "$name already installed" }
  else { Write-Warn "$name installer returned code $LASTEXITCODE (continuing)" }
  Refresh-Path
}

Write-Host "Pilipinas AI Bootcamp - Windows one-line setup" -ForegroundColor Green
Write-Host "Installs Node.js LTS, VS Code, and Claude Code, then creates your bootcamp folder."

Write-Step "Checking Windows package manager (winget)"
if (-not (Has winget)) {
  Write-Host ""
  Write-Host "winget is not available on this PC." -ForegroundColor Red
  Write-Host "Fix: open Microsoft Store, install 'App Installer', then paste this command again."
  exit 1
}
Write-Ok "winget found"

Winget-Install "OpenJS.NodeJS.LTS" "Node.js LTS"
Winget-Install "Microsoft.VisualStudioCode" "VS Code"

Write-Step "Checking Node and npm"
if (-not (Has node) -or -not (Has npm)) {
  Write-Host ""
  Write-Host "Node is installed but this window cannot see it yet." -ForegroundColor Yellow
  Write-Host "Fix: close PowerShell, open a NEW PowerShell window, and paste the command again."
  exit 1
}
Write-Ok ("Node " + (node --version) + " / npm " + (npm --version))

Write-Step "Installing Claude Code"
npm install -g @anthropic-ai/claude-code 2>&1 | Out-Null
Refresh-Path
if (Has claude) { Write-Ok ("Claude Code " + (claude --version)) }
else { Write-Warn "Claude Code installed but not visible yet (reopen PowerShell to use 'claude')" }

Write-Step "Creating bootcamp folder"
$folder = Join-Path ([Environment]::GetFolderPath("Desktop")) "claude-bootcamp"
New-Item -ItemType Directory -Force -Path $folder | Out-Null
Set-Location $folder
Write-Ok $folder

Write-Step "Setup summary"
$okNode = Has node; $okNpm = Has npm; $okCode = Has code; $okClaude = Has claude
Write-Host ("  Node.js     : " + $(if ($okNode)   { "OK " + (node --version) } else { "MISSING" }))
Write-Host ("  npm         : " + $(if ($okNpm)    { "OK " + (npm --version) }  else { "MISSING" }))
Write-Host ("  VS Code     : " + $(if ($okCode)   { "OK" } else { "installed (open from Start menu)" }))
Write-Host ("  Claude Code : " + $(if ($okClaude) { "OK" } else { "reopen PowerShell" }))
Write-Host ("  Folder      : " + $folder)
Write-Host ""
if ($okNode -and $okNpm -and $okClaude) {
  Write-Host "All set. During class, type:  claude" -ForegroundColor Green
} else {
  Write-Host "Almost there. Close PowerShell, open a new one, then type:  claude" -ForegroundColor Yellow
}
