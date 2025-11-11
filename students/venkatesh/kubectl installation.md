🏗️ 1. Title & Short Description

Start your file with a clear title and a brief one-line summary.

# ☸️ Install kubectl (Kubernetes CLI) on Windows
A complete guide to installing and configuring the Kubernetes command-line tool (`kubectl`) on Windows.

🪄 2. Prerequisites

List everything needed before installation (software, permissions, internet access, etc.)

## 🪄 Prerequisites
- Windows 10 or 11 (64-bit)
- Administrator privileges
- Internet connection
- PowerShell or Git Bash

⚙️ 3. Step-by-Step Installation

Break the setup into numbered steps with clear commands and code blocks.

## ⚙️ Step 1: Download kubectl
Open PowerShell and run:
```bash
curl -LO "https://dl.k8s.io/release/stable.txt"

⚙️ Step 2: Move kubectl Binary
mkdir "C:\kubectl"
move kubectl.exe "C:\kubectl"


---

## ⚙️ **4. Environment Setup (if needed)**
Explain how to set PATH variables or configurations.

```markdown
## ⚙️ Step 3: Add kubectl to PATH
1. Go to *Environment Variables*
2. Add: `C:\kubectl` to PATH
3. Click **OK**

🧪 5. Verification

Show how to verify that the installation worked.

## 🧪 Step 4: Verify Installation
```bash
kubectl version --client


✅ Expected output:

Client Version: v1.31.0


---

## 🧠 **6. Common Commands / Examples**
Add a table of frequently used commands.

```markdown
## 🧠 Common Commands

| Command | Description |
|----------|--------------|
| `kubectl get pods` | List all pods |
| `kubectl get nodes` | Show all nodes |
| `kubectl describe pod <pod-name>` | Get detailed info about a pod |

🧹 7. Uninstallation (Optional)

Include cleanup steps.

## 🧹 Uninstall kubectl
Delete:


C:\kubectl

Remove from PATH

✅ 8. Summary

Give a quick overview in a table.

## ✅ Summary

| Step | Description |
|------|--------------|
| 1 | Download binary |
| 2 | Move to system folder |
| 3 | Add to PATH |
| 4 | Verify installation |

🎉 9. Completion / Footer

End with a success message or reference links.

**🎉 kubectl installation completed successfully!**