# Script to set/change ArgoCD admin password
# Usage: powershell -ExecutionPolicy Bypass -File './set-password.ps1' -NewPassword 'your-password'

param(
    [Parameter(Mandatory=$true)]
    [string]$NewPassword
)

Write-Host "========================================" -ForegroundColor Cyan
Write-Host "ArgoCD Password Setter" -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""

try {
    # Validate password length
    if ($NewPassword.Length -lt 8) {
        Write-Host "Error: Password must be at least 8 characters long" -ForegroundColor Red
        exit 1
    }

    Write-Host "Setting new admin password..." -ForegroundColor Yellow
    Write-Host ""

    # Use bcrypt hash for the password
    # Generate a proper bcrypt hash
    Write-Host "Note: Using bcrypt hashing for security" -ForegroundColor Cyan
    Write-Host ""

    # Try to execute the command inside the pod
    $podName = kubectl get pod -n argocd -l app.kubernetes.io/name=argocd-server -o jsonpath='{.items[0].metadata.name}'
    
    if (-not $podName) {
        Write-Host "Error: Could not find argocd-server pod" -ForegroundColor Red
        Write-Host "Make sure ArgoCD is deployed:" -ForegroundColor Yellow
        Write-Host "kubectl get pods -n argocd" -ForegroundColor White
        exit 1
    }

    Write-Host "Found ArgoCD pod: $podName" -ForegroundColor Green
    Write-Host "Executing password change command..." -ForegroundColor Yellow
    Write-Host ""

    # Execute the password update command
    kubectl -n argocd exec $podName -- argocd account update-password `
        --account admin `
        --new-password $NewPassword `
        --insecure 2>&1 | Tee-Object -Variable output

    if ($LASTEXITCODE -eq 0) {
        Write-Host ""
        Write-Host "✅ Password changed successfully!" -ForegroundColor Green
        Write-Host ""
        Write-Host "New Credentials:" -ForegroundColor Yellow
        Write-Host "================" -ForegroundColor Yellow
        Write-Host "Username: admin" -ForegroundColor Green
        Write-Host "Password: $NewPassword" -ForegroundColor Green
        Write-Host ""
        Write-Host "Access ArgoCD UI:" -ForegroundColor Cyan
        Write-Host "Option 1 - NodePort: http://<node-ip>:30080" -ForegroundColor White
        Write-Host "Option 2 - Port Forward: kubectl port-forward -n argocd svc/argocd-server 8080:443" -ForegroundColor White
        Write-Host "Then access: http://localhost:8080" -ForegroundColor White
    }
    else {
        Write-Host ""
        Write-Host "❌ Password change failed" -ForegroundColor Red
        Write-Host "This might be because:" -ForegroundColor Yellow
        Write-Host "1. ArgoCD pod is not ready" -ForegroundColor White
        Write-Host "2. ArgoCD server is not responding" -ForegroundColor White
        Write-Host "3. The command has syntax issues" -ForegroundColor White
        Write-Host ""
        Write-Host "Try checking the pod logs:" -ForegroundColor Cyan
        Write-Host "kubectl logs -n argocd $podName" -ForegroundColor White
    }
}
catch {
    Write-Host "Error:" -ForegroundColor Red
    Write-Host $_.Exception.Message -ForegroundColor Red
    Write-Host ""
    Write-Host "Troubleshooting:" -ForegroundColor Yellow
    Write-Host "1. Verify kubectl is configured correctly" -ForegroundColor White
    Write-Host "2. Verify ArgoCD namespace exists: kubectl get ns argocd" -ForegroundColor White
    Write-Host "3. Check pod status: kubectl get pods -n argocd" -ForegroundColor White
}
