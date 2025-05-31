#!/bin/bash
# snapshot_container.sh - Snapshot Codex container structure and metadata

set -e

echo "[*] Creating container snapshot folder..."
mkdir -p container-snapshot

echo "[*] Copying current workspace (excluding build artifacts)..."
rsync -av --progress /workspace/ ./container-snapshot \
    --exclude .git \
    --exclude node_modules \
    --exclude bin \
    --exclude obj \
    --exclude __pycache__

echo "[*] Exporting system information..."
{
    echo "## SYSTEM INFO"
    uname -a
    echo ""
    echo "## OS RELEASE"
    cat /etc/os-release 2>/dev/null || echo "No /etc/os-release found."
} > container-snapshot/SYSTEM_INFO.md

echo "[*] Dumping environment variables..."
printenv > container-snapshot/ENV_VARS.md

echo "[*] Generating directory tree..."
if ! command -v tree &> /dev/null; then
    echo "[*] 'tree' command not found, attempting to install it..."
    apt-get update && apt-get install -y tree
fi
tree -a -L 4 /workspace > container-snapshot/FILESYSTEM_TREE.md

echo "[*] Writing README.md for context..."
cat <<EOF > container-snapshot/README.md
# Container Snapshot

This folder contains a snapshot of the current Codex environment.

## Included:
- SYSTEM_INFO.md – Kernel and OS info
- ENV_VARS.md – All environment variables
- FILESYSTEM_TREE.md – Hierarchical view of the workspace
- Codebase – All source files from /workspace

## Purpose:
This snapshot can be reused to recreate the current environment, build new features (like offline .NET SDK), or run isolated analysis outside the sandbox.
EOF

echo "[*] Git staging and commit (if git is present)..."
if command -v git &> /dev/null; then
    git add container-snapshot
    git commit -m "Snapshot current Codex container into container-snapshot directory"
else
    echo "[!] Git not found. Skipping version control."
fi

echo "[✅] Snapshot complete. Ready for inspection or extension!"