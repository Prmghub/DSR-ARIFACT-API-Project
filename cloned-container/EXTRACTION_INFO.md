# Container Extraction Info

This base64 file represents a compressed archive of: /workspace  
Original filename: container_dump.tar.gz  
Encoded as: container_dump.b64  
Compression: gzip  
Encoding: base64

To restore:
```bash
base64 -d container_dump.b64 > container_dump.tar.gz
tar -xzf container_dump.tar.gz -C output_folder/
```

