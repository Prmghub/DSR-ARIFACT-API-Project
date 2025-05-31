#!/bin/bash
# generate_container_snapshot.sh – Archive full container state and encode it

set -e

echo "[*] Creating output directory..."
mkdir -p cloned-container

echo "[*] Archiving /workspace into tar.gz..."
tar -czf cloned-container/container_dump.tar.gz -C /workspace .

echo "[*] Encoding archive to base64..."
base64 cloned-container/container_dump.tar.gz > cloned-container/container_dump.b64

echo "[*] Creating extraction instructions..."
cat <<EOF > cloned-container/EXTRACTION_INFO.md
# Container Extraction Info

This base64 file \`container_dump.b64\` contains a \`.tar.gz\` archive of the full \`/workspace\` directory.

## How to Extract:

\`\`\`bash
base64 -d container_dump.b64 > container_dump.tar.gz
tar -xzf container_dump.tar.gz -C ./restored/
\`\`\`

After extraction, the full original environment will be restored.
EOF

echo "[*] Cleaning up intermediate tar..."
rm cloned-container/container_dump.tar.gz

echo "[✅] Snapshot ready: cloned-container/container_dump.b64"