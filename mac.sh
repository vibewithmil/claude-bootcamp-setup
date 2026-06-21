#!/usr/bin/env bash
set -euo pipefail

step() { printf "\n==> %s\n" "$1"; }
ok()   { printf "    [ok] %s\n" "$1"; }
warn() { printf "    [!] %s\n" "$1"; }

echo "Pilipinas AI Bootcamp - Mac one-line setup"
echo "Installs Homebrew (if needed), Node.js, VS Code, and Claude Code, then creates your bootcamp folder."

# 1. Homebrew
if ! command -v brew >/dev/null 2>&1; then
  step "Installing Homebrew (it may ask for your Mac password)"
  NONINTERACTIVE=1 /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
fi
# Load brew into this shell (Apple Silicon or Intel)
if [ -x /opt/homebrew/bin/brew ]; then eval "$(/opt/homebrew/bin/brew shellenv)"
elif [ -x /usr/local/bin/brew ]; then eval "$(/usr/local/bin/brew shellenv)"
fi
if command -v brew >/dev/null 2>&1; then ok "Homebrew ready"
else echo "Homebrew install failed. Send: STUCK Mac + screenshot"; exit 1; fi

# 2. Node.js
step "Installing Node.js"
brew install node
if command -v node >/dev/null 2>&1; then ok "Node $(node --version) / npm $(npm --version)"
else echo "Node not found after install. Send: STUCK Mac + screenshot"; exit 1; fi

# 3. VS Code
step "Installing VS Code"
brew install --cask visual-studio-code || warn "VS Code may already be installed (continuing)"

# 4. Claude Code
step "Installing Claude Code"
npm install -g @anthropic-ai/claude-code
if command -v claude >/dev/null 2>&1; then ok "Claude Code $(claude --version)"
else warn "Claude Code installed; reopen Terminal if 'claude' is not found"; fi

# 5. Bootcamp folder
step "Creating bootcamp folder"
mkdir -p "$HOME/Desktop/claude-bootcamp"
cd "$HOME/Desktop/claude-bootcamp"
ok "$HOME/Desktop/claude-bootcamp"

# 6. Summary
step "Setup summary"
node_v=$(command -v node >/dev/null 2>&1 && node --version || echo MISSING)
npm_v=$(command -v npm >/dev/null 2>&1 && npm --version || echo MISSING)
if [ -d "/Applications/Visual Studio Code.app" ] || command -v code >/dev/null 2>&1; then code_v="OK"; else code_v="open from Applications"; fi
claude_v=$(command -v claude >/dev/null 2>&1 && echo OK || echo "reopen Terminal")
echo "  Node.js     : $node_v"
echo "  npm         : $npm_v"
echo "  VS Code     : $code_v"
echo "  Claude Code : $claude_v"
echo "  Folder      : $HOME/Desktop/claude-bootcamp"
echo ""
if [ "$node_v" != "MISSING" ] && [ "$claude_v" = "OK" ]; then
  echo "All set. During class, type:  claude"
else
  echo "Almost there. Close Terminal, open a new one, then type:  claude"
fi
