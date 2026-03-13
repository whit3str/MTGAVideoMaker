# Lightweight image with FFmpeg pre-installed
FROM jrottenberg/ffmpeg:4.4-alpine

# Install Bash, bc (math) and dos2unix (Windows to Linux line endings)
RUN apk add --no-cache bash bc dos2unix

# Working directory
WORKDIR /app

# Copy the watcher script and fix line endings
COPY entrypoint.sh /app/entrypoint.sh
RUN dos2unix /app/entrypoint.sh && chmod +x /app/entrypoint.sh

# Entrypoint
ENTRYPOINT ["/bin/bash", "/app/entrypoint.sh"]
