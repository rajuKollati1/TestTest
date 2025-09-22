#!/bin/bash
 
# Configurable threshold

THRESHOLD=70
 
# Interactive prompt

read -p "Enter the worker node IP or hostname: " NODE

read -p "Enter SSH username: " USER
 
# Check disk usage on the worker node

echo "Checking disk usage on $NODE..."

USAGE=$(ssh "$USER@$NODE" "df -h / | awk 'NR==2 {print \$5}' | sed 's/%//'")
 
if [ -z "$USAGE" ]; then

    echo "Error: Unable to retrieve disk usage. Check SSH connection or permissions."

    exit 1

fi
 
echo "Disk usage on $NODE is $USAGE%."
 
if [ "$USAGE" -ge "$THRESHOLD" ]; then

    echo "Disk usage is above $THRESHOLD%. Proceeding with ContainerD image pruning..."
 
    ssh "$USER@$NODE" << 'EOF'

        if ! command -v ctr &> /dev/null; then

            echo "Error: ContainerD (ctr) command not found. Aborting."

            exit 1

        fi
 
        echo "Listing unused ContainerD images..."

        ctr images list | grep -v 'TAG' | awk '{print $1}' > /tmp/all_images.txt
 
        echo "Listing used images from running containers..."

        ctr containers list | awk '{print $2}' > /tmp/used_images.txt
 
        echo "Identifying unused images..."

        grep -vxFf /tmp/used_images.txt /tmp/all_images.txt > /tmp/unused_images.txt
 
        echo "Pruning unused images..."

        while read -r image; do

            echo "Removing image: $image"

            ctr images remove "$image"

        done < /tmp/unused_images.txt
 
        echo "Pruning complete."

        rm /tmp/all_images.txt /tmp/used_images.txt /tmp/unused_images.txt

EOF
 
else

    echo "Disk usage is below threshold. No pruning needed."

fi
 
