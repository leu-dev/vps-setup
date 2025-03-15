#!/bin/bash

set -e

# Update system
apt update && apt upgrade -y

# Install required packages
apt install -y unzip

# Install Docker
if ! command -v docker &> /dev/null; then
    curl -fsSL https://get.docker.com | sh
    systemctl enable --now docker
fi

# Install Docker Compose
if ! command -v docker-compose &> /dev/null; then
    curl -L "https://github.com/docker/compose/releases/latest/download/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
    chmod +x /usr/local/bin/docker-compose
fi

# Install LazyDocker if not already installed
if ! command -v lazydocker &> /dev/null; then
    LATEST_URL=$(curl -s https://api.github.com/repos/jesseduffield/lazydocker/releases/latest | grep "browser_download_url.*Linux_x86_64.tar.gz" | cut -d '"' -f 4)
    
    if [ -z "$LATEST_URL" ]; then
        echo "Failed to fetch LazyDocker latest release URL."
        exit 1
    fi
    
    echo "Downloading LazyDocker from: $LATEST_URL"
    curl -L "$LATEST_URL" -o lazydocker.tar.gz
    
    tar -xvf lazydocker.tar.gz
    sudo mv lazydocker /usr/local/bin/
    sudo chmod +x /usr/local/bin/lazydocker
    
    # Cleanup
    rm lazydocker.tar.gz
fi

# Enable automatic security updates
apt install -y unattended-upgrades
systemctl enable --now unattended-upgrades

# Print installation summary
echo "Installation completed successfully!"
docker --version
docker-compose --version
lazydocker --version
