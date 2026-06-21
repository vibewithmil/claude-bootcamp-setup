# Pilipinas AI Bootcamp — One-Line Setup

Public installer scripts for hands-on participants. Installs **Node.js LTS**, **VS Code**, and **Claude Code**, then creates a `Desktop/claude-bootcamp` folder.

> Claude Pro or Max is required for the hands-on Claude Code parts. Claude Free users can still watch the demos.

## Windows

Open **PowerShell** and paste:

```powershell
powershell -ExecutionPolicy Bypass -NoProfile -Command "irm https://raw.githubusercontent.com/vibewithmil/claude-bootcamp-setup/main/win.ps1 | iex"
```

## Mac

Open **Terminal** and paste:

```bash
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/vibewithmil/claude-bootcamp-setup/main/mac.sh)"
```

## What it does

- Windows: installs Node.js LTS + VS Code via `winget`, then Claude Code via `npm`.
- Mac: installs Homebrew (if needed), Node.js, VS Code (cask), then Claude Code via `npm`.
- Both: create `Desktop/claude-bootcamp` and print a setup summary.

If something gets stuck, send `STUCK + Windows/Mac + screenshot` in the class chat.
