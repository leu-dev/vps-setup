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

# Install LazyDocker
if ! command -v lazydocker &> /dev/null; then
    curl -Lo /usr/local/bin/lazydocker "https://github.com/jesseduffield/lazydocker/releases/latest/download/lazydocker_$(uname -s)_$(uname -m)"
    chmod +x /usr/local/bin/lazydocker
fi


# Enable Fail2Ban
systemctl enable --now fail2ban

# Enable automatic security updates
apt install -y unattended-upgrades
systemctl enable --now unattended-upgrades

# Print installation summary
echo "Installation completed successfully!"
docker --version
docker-compose --version
lazydocker --version
