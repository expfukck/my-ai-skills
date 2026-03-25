#!/bin/bash
# Download latest codex_patcher.py from GitHub

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PATCHER_PATH="$SCRIPT_DIR/codex_patcher.py"
GITHUB_RAW="https://raw.githubusercontent.com/ryfineZ/codex-session-patcher/main/codex_patcher.py"

echo "📥 Downloading latest codex_patcher.py..."

if command -v curl &> /dev/null; then
    curl -fsSL "$GITHUB_RAW" -o "$PATCHER_PATH"
elif command -v wget &> /dev/null; then
    wget -q "$GITHUB_RAW" -O "$PATCHER_PATH"
else
    echo "❌ Error: curl or wget required"
    exit 1
fi

chmod +x "$PATCHER_PATH"
echo "✅ Downloaded to: $PATCHER_PATH"
