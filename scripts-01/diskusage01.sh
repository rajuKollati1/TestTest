#!/bin/bash
set -euo pipefail

# 🔐 Hardcoded credentials (edit these)
NODE="192.168.0.35"
USER="raju"
SSHPASS="VMware1!"
SUDOPASS="VMware1!"
THRESHOLD=50   # change threshold %

# Check disk usage on remote node
echo "Checking disk usage on $NODE..."
USAGE=$(sshpass -p "$SSHPASS" ssh -o StrictHostKeyChecking=no "$USER@$NODE" \
    "df -h /var/lib/containerd | awk 'NR==2 {print \$5}' | sed 's/%//'")

echo "Disk usage on $NODE is $USAGE%."

if [ "$USAGE" -ge "$THRESHOLD" ]; then
    echo "Disk usage is above $THRESHOLD%. Proceeding with ContainerD image pruning..."

    sshpass -p "$SSHPASS" ssh -tt -o StrictHostKeyChecking=no "$USER@$NODE" bash << EOF
        set -euo pipefail
        echo "$SUDOPASS" | sudo -S bash << 'INNER'
            echo "Listing unused ContainerD images..."
            ctr images list -q > /tmp/all_images.txt

            echo "Listing used images from running containers..."
            ctr containers list -q > /tmp/used_images.txt

            echo "Identifying unused images..."
            grep -vxFf /tmp/used_images.txt /tmp/all_images.txt > /tmp/unused_images.txt || true

            if [ -s /tmp/unused_images.txt ]; then
                echo "Pruning unused images..."
                xargs -r ctr images remove < /tmp/unused_images.txt
                echo "Pruning complete."
            else
                echo "No unused images found."
            fi

            rm -f /tmp/all_images.txt /tmp/used_images.txt /tmp/unused_images.txt
INNER
EOF

else
    echo "Disk usage is below threshold. No pruning needed."
fi
