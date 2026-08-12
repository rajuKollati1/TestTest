# Script to retrieve initial ArgoCD admin password
# This script retrieves the auto-generated initial password from the ArgoCD secret

Write-Host "========================================" -ForegroundColor Cyan
Write-Host "ArgoCD Initial Password Retriever" -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""

try {
    # Check if the initial admin secret exists
    $secretExists = kubectl get secret argocd-initial-admin-secret -n argocd -o name 2>$null
    
    if ($secretExists) {
        Write-Host "Found initial admin secret!" -ForegroundColor Green
        Write-Host ""
        
        # Retrieve the password
        $secret = kubectl get secret argocd-initial-admin-secret -n argocd -o jsonpath="{.data.password}"
        $password = [System.Text.Encoding]::UTF8.GetString([System.Convert]::FromBase64String($secret))
        
        Write-Host "Initial Admin Password:" -ForegroundColor Yellow
        Write-Host "=======================" -ForegroundColor Yellow
        Write-Host "Username: admin" -ForegroundColor Green
        Write-Host "Password: $password" -ForegroundColor Green
        Write-Host ""
        Write-Host "⚠️  Change this password after first login!" -ForegroundColor Yellow
        Write-Host ""
        Write-Host "Use this command to change password:" -ForegroundColor Cyan
        Write-Host "powershell -ExecutionPolicy Bypass -File './set-password.ps1' -NewPassword 'your-new-password'" -ForegroundColor White
    }
    else {
        Write-Host "Initial admin secret not found." -ForegroundColor Yellow
        Write-Host "This could mean:" -ForegroundColor Yellow
        Write-Host "1. ArgoCD has not been deployed yet" -ForegroundColor White
        Write-Host "2. The initial secret has been deleted" -ForegroundColor White
        Write-Host "3. The deployment is still initializing" -ForegroundColor White
        Write-Host ""
        Write-Host "Try again in a few moments or check pod status:" -ForegroundColor Cyan
        Write-Host "kubectl get pods -n argocd" -ForegroundColor White
    }
}
catch {
    Write-Host "Error retrieving password:" -ForegroundColor Red
    Write-Host $_.Exception.Message -ForegroundColor Red
    Write-Host ""
    Write-Host "Troubleshooting:" -ForegroundColor Yellow
    Write-Host "1. Verify kubectl is configured correctly" -ForegroundColor White
    Write-Host "2. Verify ArgoCD namespace exists: kubectl get ns argocd" -ForegroundColor White
    Write-Host "3. Check pod status: kubectl get pods -n argocd" -ForegroundColor White
}
