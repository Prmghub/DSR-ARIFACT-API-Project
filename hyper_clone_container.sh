#!/bin/bash
# hyper_clone_container.sh – Full Codex rootfs archive with metadata

set -e

OUT_DIR="hyperspace-container"
ARCHIVE_NAME="codex_full_dump.tar.gz"
BASE64_NAME="codex_full_dump.b64"

echo "[🚀] Creating hyperspace export directory..."
mkdir -p "$OUT_DIR"

echo "[📦] Archiving root filesystem (excluding runtime paths)..."
tar --exclude=/proc \
    --exclude=/sys \
    --exclude=/dev \
    --exclude=/tmp \
    --exclude=/mnt \
    --exclude=/media \
    --exclude=/run \
    -czf "$OUT_DIR/$ARCHIVE_NAME" -C / .

echo "[🌲] Generating filesystem tree view..."
command -v tree &> /dev/null && tree -a -L 5 / > "$OUT_DIR/FILESYSTEM_TREE.md" || echo "[!] 'tree' not found"

echo "[🧬] Writing TOML system description..."
cat <<EOF > "$OUT_DIR/system.toml"
[system]
distro = "Ubuntu 24.04"
kernel = "$(uname -r)"
arch = "$(uname -m)"
shell = "/bin/bash"
entrypoint = "/bin/bash"

[metadata]
generated_by = "hyper_clone_container.sh"
timestamp = "$(date -u +"%Y-%m-%dT%H:%M:%SZ")"
EOF

echo "[🔁] Encoding archive to base64..."
base64 "$OUT_DIR/$ARCHIVE_NAME" > "$OUT_DIR/$BASE64_NAME"

echo "[📘] Creating rehydration guide..."
cat <<EOF > "$OUT_DIR/rebuild.md"
# Rehydrating Codex Snapshot

This archive contains a base64-encoded full filesystem dump.

## To extract:

\`\`\`bash
base64 -d $BASE64_NAME > $ARCHIVE_NAME
mkdir restored
tar -xzf $ARCHIVE_NAME -C restored/
cd restored
./bin/bash
\`\`\`

EOF

echo "[🧼] Cleaning up intermediate archive..."
rm "$OUT_DIR/$ARCHIVE_NAME"

echo "[✅] Done! All output in '$OUT_DIR'."