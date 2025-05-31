#!/bin/bash
# extract_container_payload.sh - Archive current container state into base64 string

set -e

echo "[🔥] Archiving container environment..."

# Step 1: Define output
OUT_DIR="cloned-container"
ARCHIVE_NAME="container_dump.tar.gz"
BASE64_NAME="container_dump.b64"
TARGET_PATH="/workspace"  # Or change to /app or /

# Ensure output directory exists
mkdir -p $OUT_DIR

# Step 2: Create tar.gz archive from selected root
echo "[📦] Creating archive from $TARGET_PATH ..."
tar -czf $OUT_DIR/$ARCHIVE_NAME -C "$TARGET_PATH" .

# Step 3: Encode to base64
echo "[🔁] Converting archive to base64 ..."
base64 $OUT_DIR/$ARCHIVE_NAME > $OUT_DIR/$BASE64_NAME

# Step 4: Metadata
echo "[🧾] Writing info..."
cat <<EOF > $OUT_DIR/EXTRACTION_INFO.md
# Container Extraction Info

This base64 file represents a compressed archive of: $TARGET_PATH  
Original filename: $ARCHIVE_NAME  
Encoded as: $BASE64_NAME  
Compression: gzip  
Encoding: base64

To restore:
\`\`\`bash
base64 -d $BASE64_NAME > $ARCHIVE_NAME
tar -xzf $ARCHIVE_NAME -C output_folder/
\`\`\`

EOF

echo "[✅] Archive created and base64 encoded at: $OUT_DIR/$BASE64_NAME"