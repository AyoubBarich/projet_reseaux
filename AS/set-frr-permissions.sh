#!/bin/bash

# This script sets the correct permissions for FRR files
# Run as root or with sudo

FRR_DIR="./routers/router1/frr"  # Adjust this path if your FRR files are stored elsewhere

# Ensure the directory exists
if [ ! -d "$FRR_DIR" ]; then
    echo "Error: Directory $FRR_DIR does not exist!"
    exit 1
fi

# Create messagebus user and group if they don't exist
if ! getent group messagebus > /dev/null; then
    echo "Creating messagebus group..."
    groupadd messagebus
fi

if ! id -u messagebus > /dev/null 2>&1; then
    echo "Creating messagebus user..."
    useradd -g messagebus messagebus
fi

# Set ownership for all files
echo "Setting ownership for files in $FRR_DIR..."
chown -R messagebus:messagebus "$FRR_DIR"

# Set specific permissions for each file type
echo "Setting file permissions..."

# General config files: owner rw, group r, others none (640)
find "$FRR_DIR" -type f -name "*.conf" -exec chmod 640 {} \;
find "$FRR_DIR" -type f -name "daemons" -exec chmod 640 {} \;

# Support bundle commands: owner rw, group rw, others r (664)
find "$FRR_DIR" -type f -name "support_bundle_commands.conf" -exec chmod 664 {} \;

# For vtysh.conf specifically
if [ -f "$FRR_DIR/vtysh.conf" ]; then
    chmod 640 "$FRR_DIR/vtysh.conf"
fi

# Set directory permissions (750 - owner rwx, group rx, others none)
find "$FRR_DIR" -type d -exec chmod 750 {} \;

echo "Done setting permissions for FRR files." 