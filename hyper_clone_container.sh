#!/bin/bash
# hyper_clone_container.sh - Full Codex environment snapshot for rehydration

set -e

OUT_DIR="hyperspace-container"
ARCHIVE_NAME="codex_full_dump.tar.gz"
BASE64_NAME="codex_full_dump.b64"

echo "[🚀] Preparing hyperspace container..."

# 1. إنشاء مجلد الإخراج
mkdir -p "$OUT_DIR"

# 2. إنشاء نسخة من ملفات النظام (بإقصاء بعض المسارات)
echo "[📦] Archiving root filesystem..."
tar --exclude=/proc \
    --exclude=/sys \
    --exclude=/dev \
    --exclude=/tmp \
    --exclude=/mnt \
    --exclude=/media \
    --exclude=/run \
    -czf "$OUT_DIR/$ARCHIVE_NAME" -C / .

# 3. توليد شجرة ملفات
echo "[🌲] Generating filesystem tree..."
tree -a -L 5 / > "$OUT_DIR/FILESYSTEM_TREE.md" || echo "[!] tree not found"

# 4. توليد ملف تعريف TOML تقريبي
echo "[📄] Creating system description..."
cat <<EOF > $OUT_DIR/system.toml
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

# 5. تحويل الأرشيف إلى base64
echo "[🔁] Encoding archive to base64..."
base64 "$OUT_DIR/$ARCHIVE_NAME" > "$OUT_DIR/$BASE64_NAME"

# 6. وثيقة إعادة البناء
cat <<EOF > $OUT_DIR/rebuild.md
# 🛠️ Rehydrating Codex System

This document explains how to restore the entire Codex environment on any system with Bash and tar.

## Steps:

1. Save the base64 file as \`$BASE64_NAME\`
2. Run:

\`\`\`bash
base64 -d $BASE64_NAME > $ARCHIVE_NAME
mkdir restored && tar -xzf $ARCHIVE_NAME -C restored/
cd restored
./bin/bash
\`\`\`

Enjoy the Codex clone 🛰️

EOF

echo "[✅] Hyperclone complete. Your container dump is in: $OUT_DIR"