🧩 File 1: install_gitbash.md
# 🧰 Install Git Bash on Windows

## 🪄 Prerequisites
- Windows 10 or 11 (64-bit)
- Internet connection
- Administrator access

---

## 🔹 What is Git Bash?
Git Bash is a command-line tool that provides a Unix-like terminal on Windows.  
It helps you use **Git** commands and **Linux-like** utilities (ls, rm, etc.) easily.

---

## ⚙️ Installation Steps

1. Visit the official Git website:  
   👉 [https://git-scm.com/downloads](https://git-scm.com/downloads)

2. Click **“Download for Windows”** and save the `.exe` file.

3. Run the installer and follow the steps below:
   - ✅ Choose **“Use Git from Git Bash only”**
   - ✅ Leave default settings for line endings
   - ✅ Choose **“Use MinTTY (the default terminal)”**
   - ✅ Click **Install**

4. After installation, open **Git Bash** from the Start menu.

5. Verify installation:
   ```bash
   git --version


Example Output:

git version 2.47.0.windows.1

🔧 Configuration (Optional)

Set your Git username and email:

git config --global user.name "Your Name"
git config --global user.email "your_email@example.com"


Check configuration:

git config --list

🧹 Uninstall Git Bash

Go to Control Panel → Programs → Uninstall a program.

Select Git → Uninstall.

✅ Summary
Command	Description
git --version	Verify Git installation
git config --list	Check Git configuration
git config --global user.name	Set username
git config --global user.email	Set email

🎉 Git Bash installation completed successfully!