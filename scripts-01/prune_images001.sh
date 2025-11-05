#!/bin/bash

# List of worker nodes

worker_nodes=("192.168.0.35") # Add more as needed

# Define the threshold for space usage (70%)

THRESHOLD=70

# Function to check space usage on a node and remove unused containerd images if necessary

check_and_cleanup() {

   local node=$1

   echo "Checking disk space on $node..."

   # Get the containerd disk usage using containerd or Docker (depending on setup)

   usage=$(ssh $node "df -h /var/lib/containerd | grep -v Filesystem | awk '{print \$5}' | sed 's/%//g'")

   # Compare usage with the threshold

   if [ "$usage" -gt "$THRESHOLD" ]; then

       echo "Disk usage on $node is above $THRESHOLD%. Removing unused images..."

       # Run the cleanup on the node (removes unused images)

       ssh $node "sudo crictl rmi --prune"

       echo "Unused images removed on $node."

   else

       echo "Disk usage on $node is below $THRESHOLD%. No action needed."

   fi

}

# Iterate over each worker node and check space

for node in "${worker_nodes[@]}"; do

   check_and_cleanup $node

done
 
