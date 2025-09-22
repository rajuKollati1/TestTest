#!/bin/bash

# ===============================
# ContainerD Image Prune Script
# ===============================

# Configurable threshold
THRESHOLD=70

# Interactive prompt
read -p "Enter the worker node IP or hostname: " NODE
read -p "Enter SSH username (default: root): " USER
USER=${USER:-root}

# Check disk usage on the worker node
echo "Checking disk usage on $NODE..."
USAGE=$(ssh "$USER@$NODE" "df -h / | awk 'NR==2 {print \$5}' | sed 's/%//'")

if [ -z "$USAGE" ]; then
    echo "❌ Error: Unable to retrieve disk usage. Check SSH connection or permissions."
    exit 1
fi

echo "✅ Disk usage on $NODE is $USAGE%."

if [ "$USAGE" -ge "$THRESHOLD" ]; then
    echo "⚠️ Disk usage is above $THRESHOLD%. Proceeding with ContainerD image pruning..."

    ssh "$USER@$NODE" bash << 'EOF'
        # Decide whether to use sudo
        SUDO=""
        if [ "$(id -u)" -ne 0 ]; then
            if command -v sudo &>/dev/null; then
                SUDO="sudo"
            else
                echo "❌ Error: Not running as root and sudo not available."
                exit 1
            fi
        fi

        # Verify ctr command
        if ! $SUDO ctr version &>/dev/null; then
            echo "❌ Error: ContainerD (ctr) command not found. Aborting."
            exit 1
        fi

        echo "📋 Listing unused ContainerD images..."
        $SUDO ctr images list | grep -v 'TAG' | awk '{print $1}' > /tmp/all_images.txt

        echo "📋 Listing used images from running containers..."
        $SUDO ctr containers list | awk '{print $2}' > /tmp/used_images.txt

        echo "📋 Identifying unused images..."
        grep -vxFf /tmp/used_images.txt /tmp/all_images.txt > /tmp/unused_images.txt

        echo "🗑️ Pruning unused images..."
        while read -r image; do
            if [ -n "$image" ]; then
                echo "   → Removing image: $image"
                $SUDO ctr images remove "$image"
            fi
        done < /tmp/unused_images.txt

        echo "✅ Pruning complete."
        $SUDO rm -f /tmp/all_images.txt /tmp/used_images.txt /tmp/unused_images.txt
EOF

else
    echo "✅ Disk usage is below threshold ($THRESHOLD%). No pruning needed."
fi
