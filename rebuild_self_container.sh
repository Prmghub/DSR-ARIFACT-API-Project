#!/bin/bash
# rebuild_self_container.sh – Reverse-engineer current Codex container

set -e

mkdir -p cloned-container

echo "[*] Extracting base image and system info..."
{
    echo "## Kernel"
    uname -a
    echo ""
    echo "## OS Release"
    cat /etc/os-release
    echo ""
    echo "## Installed Shell"
    echo $SHELL
} > cloned-container/SYSTEM_INFO.md

echo "[*] Dumping environment variables..."
printenv > cloned-container/ENV_VARS.md

echo "[*] Generating Dockerfile template..."
cat <<EOF > cloned-container/Dockerfile
FROM ubuntu:24.04

# Simulated image matching the current container
LABEL description="Cloned Codex Environment"
WORKDIR /app

# Reconstruct environment if needed
ENV DEBIAN_FRONTEND=noninteractive

# (Optional) Install .NET manually later

COPY . .

CMD ["/bin/bash"]
EOF

echo "[*] Adding README to describe purpose..."
cat <<EOF > cloned-container/README.md
# Cloned Codex Container

This container attempts to replicate the environment in which Codex is currently running.

It includes:
- Kernel and OS info
- Environment variables
- A template Dockerfile based on Ubuntu 24.04

This can be used as a base image for installing additional runtimes like .NET SDK in isolation.

To build it:
\`\`\`bash
cd cloned-container
docker build -t codex-clone .
\`\`\`
EOF

echo "[*] Snapshot complete. Container structure exported to 'cloned-container/'"