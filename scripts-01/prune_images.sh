#!/bin/bash

# ===============================
# ContainerD Image Prune Script
# ===============================

THRESHOLD=70

# Inputs
read -p "Enter the worker node IP or hostname: " NODE
read -p "Enter SSH username (non-root user): " USER
read -sp "Enter SSH password for $USER: " USERPASS
echo
read -sp "Enter root password for $NODE: " ROOTPASS
echo

# Check disk usage using user credentials
echo "Checking disk usage on $NODE..."
USAGE=$(sshpass -p "$USERPASS" ssh -o StrictHostKeyChecking=no "$USER@$NODE" "df -h / | awk 'NR==2 {print \$5}' | sed 's/%//'")

if [ -z "$USAGE" ]; then
    echo "❌ Error: Unable to retrieve disk usage. Check SSH connection or permissions."
    exit 1
fi

echo "✅ Disk usage on $NODE is $USAGE%."

if [ "$USAGE" -ge "$THRESHOLD" ]; then
    echo "⚠️ Disk usage is above $THRESHOLD%. Switching to root and pruning images..."

    sshpass -p "$USERPASS" ssh -tt -o StrictHostKeyChecking=no "$USER@$NODE" << EOF
        su - << ROOTCMDS
            $ROOTPASS
            if ! ctr version &>/dev/null; then
                echo "❌ Error: ContainerD (ctr) command not found. Aborting."
                exit 1
            fi
            echo "Pruning unused images..."
            ctr -n k8s.io images prune --all
            echo "✅ Image pruning complete."
ROOTCMDS
EOF
else
    echo "✅ Disk usage is below threshold. No action needed."
fi
