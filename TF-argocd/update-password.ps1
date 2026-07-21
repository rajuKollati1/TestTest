$bcrypt_hash = '$2a$10$SXrpMrynKHpDrBPxWWOxIOnuGgc.vyJzL0cITwxlPzXVGPnPLJyXK'
$encoded = [Convert]::ToBase64String([System.Text.Encoding]::UTF8.GetBytes($bcrypt_hash))
Write-Host "Encoded: $encoded"

$patch = @{
    data = @{
        "admin.password" = $encoded
    }
} | ConvertTo-Json

$patch | Out-File -FilePath "$env:TEMP\argocd-password.json" -Encoding UTF8 -Force
Write-Host "Patch file created"

kubectl -n argocd patch secret argocd-secret --type merge --patch-file "$env:TEMP\argocd-password.json"
Write-Host "Secret patched"

kubectl -n argocd rollout restart deployment/argocd-server
Write-Host "Server restarted"
