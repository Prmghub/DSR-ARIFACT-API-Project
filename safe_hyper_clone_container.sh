#!/bin/bash
# safe_hyper_clone_container.sh – Full container snapshot with excluded paths' structure

set -euo pipefail

OUT_DIR="hyperspace-container"
ARCHIVE_NAME="codex_snapshot.tar.gz"
BASE64_NAME="codex_snapshot.b64"
EXCLUDED_PATHS=(/proc /sys /dev /run /tmp /mnt /media /lost+found)

echo "[🚀] Creating output directory..."
mkdir -p "$OUT_DIR"

echo "[🔍] Logging excluded paths structure..."
for path in "${EXCLUDED_PATHS[@]}"; do
    if [ -d "$path" ]; then
        safe_name=$(echo "$path" | sed 's|/|_|g' | sed 's|^_||')
        tree -a -L 3 "$path" > "$OUT_DIR/excluded_${safe_name}_TREE.txt" 2>/dev/null || echo "[!] Could not list $path"
    else
        echo "[!] Skipping missing path: $path"
    fi
done

echo "[📦] Archiving root filesystem..."
tar -czf "$OUT_DIR/$ARCHIVE_NAME" \
    --one-file-system \
    $(for path in "${EXCLUDED_PATHS[@]}"; do echo --exclude="$path"; done) \
    -C / .

echo "[🌲] Writing main tree..."
tree -a -L 5 / > "$OUT_DIR/FILESYSTEM_TREE.md" 2>/dev/null || echo "[!] Tree not available."

echo "[🧬] Writing system metadata (TOML)..."
cat <<EOF > "$OUT_DIR/system.toml"
[system]
os = "$(grep PRETTY_NAME /etc/os-release | cut -d= -f2 | tr -d \")"
kernel = "$(uname -r)"
arch = "$(uname -m)"
entrypoint = "/bin/bash"

[meta]
generated = "$(date -u +"%Y-%m-%dT%H:%M:%SZ")"
script = "safe_hyper_clone_container.sh"
EOF

echo "[🔁] Encoding archive to base64..."
base64 "$OUT_DIR/$ARCHIVE_NAME" > "$OUT_DIR/$BASE64_NAME"

echo "[📘] Creating rebuild instructions..."
cat <<EOF > "$OUT_DIR/rebuild.md"
# Codex Container Reconstruction

## How to Extract:

\`\`\`bash
base64 -d $BASE64_NAME > $ARCHIVE_NAME
mkdir restored
tar -xzf $ARCHIVE_NAME -C restored/
cd restored && ./bin/bash
\`\`\`

## Excluded Directories:
$(printf -- "- %s\n" "${EXCLUDED_PATHS[@]}")
Structure of each path is logged in individual \`excluded_<name>_TREE.txt\` files.
EOF

echo "[🧼] Cleanup..."
rm "$OUT_DIR/$ARCHIVE_NAME"

echo "[✅] Snapshot complete. Ready in: $OUT_DIR"