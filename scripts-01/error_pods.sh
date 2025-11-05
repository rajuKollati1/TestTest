#!/bin/bash

# Problematic pod states to search for
ISSUES="Error|CrashLoopBackOff|ImagePullBackOff|ErrImagePull|ContainerCreating|Unknown|Pending"

echo "========================================"
echo "Checking problematic pods in current cluster context: $(kubectl config current-context)"
echo "========================================"

kubectl get pods --all-namespaces --no-headers -o wide | \
  grep -E "$ISSUES" || echo "✅ No problematic pods found"
