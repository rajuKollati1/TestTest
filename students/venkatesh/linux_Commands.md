# 🐧 Linux Commands — Complete Cheat Sheet with Explanations

This guide provides detailed Linux commands for beginners and DevOps engineers — including file management, system monitoring, networking, and permissions.

---

## 📁 1. File and Directory Commands

| Command | Description | Example |
|----------|--------------|----------|
| `pwd` | Prints current working directory. | `pwd` |
| `ls` | Lists files and directories. | `ls -l` |
| `cd <dir>` | Changes current directory. | `cd /home/user` |
| `mkdir <dir>` | Creates a new directory. | `mkdir projects` |
| `rmdir <dir>` | Removes empty directory. | `rmdir old_folder` |
| `rm -r <dir>` | Removes directory with files. | `rm -r temp` |
| `touch <file>` | Creates an empty file. | `touch index.html` |
| `cp <src> <dest>` | Copies files or directories. | `cp file.txt backup/` |
| `mv <src> <dest>` | Moves or renames files. | `mv test.txt /home/user/docs/` |
| `cat <file>` | Displays file content. | `cat notes.txt` |
| `more <file>` / `less <file>` | Views file content page by page. | `less /etc/passwd` |
| `head <file>` | Shows first 10 lines of file. | `head -n 5 file.txt` |
| `tail <file>` | Shows last 10 lines of file. | `tail -f /var/log/syslog` |
| `find <path> -name <file>` | Searches for files. | `find /home -name "*.log"` |

---

## 🧾 2. File Permissions & Ownership

| Command | Description | Example |
|----------|--------------|----------|
| `chmod <mode> <file>` | Changes file permissions. | `chmod 755 script.sh` |
| `chown <user>:<group> <file>` | Changes file owner/group. | `chown root:root file.txt` |
| `chgrp <group> <file>` | Changes group ownership. | `chgrp developers code.py` |
| `umask` | Shows or sets default permissions. | `umask 022` |

📘 **Permission Breakdown**
- `r` → Read  
- `w` → Write  
- `x` → Execute  

Example: `chmod 755 file.sh` → Owner has all rights, others can read and execute.

---

## ⚙️ 3. System Information

| Command | Description | Example |
|----------|--------------|----------|
| `uname -a` | Displays system information. | `uname -a` |
| `hostname` | Shows system hostname. | `hostname` |
| `uptime` | Shows system running time. | `uptime` |
| `whoami` | Displays current logged user. | `whoami` |
| `date` | Shows current date and time. | `date` |
| `cal` | Displays calendar. | `cal 2025` |
| `df -h` | Shows disk usage in human-readable form. | `df -h` |
| `du -sh <dir>` | Shows directory size. | `du -sh /var/log` |
| `free -h` | Shows memory usage. | `free -h` |
| `top` | Displays running processes. | `top` |
| `htop` | Interactive process viewer (install first). | `htop` |
| `vmstat` | Displays system performance. | `vmstat 1` |

---

## 🔍 4. Process Management

| Command | Description | Example |
|----------|--------------|----------|
| `ps` | Lists running processes. | `ps aux` |
| `top` | Live process monitor. | `top` |
| `htop` | Enhanced top interface. | `htop` |
| `kill <pid>` | Kills process by ID. | `kill 1234` |
| `killall <name>` | Kills all processes by name. | `killall firefox` |
| `nice` | Starts process with priority. | `nice -n 10 script.sh` |
| `renice` | Changes priority of running process. | `renice +5 -p 1234` |
| `jobs` | Lists background jobs. | `jobs` |
| `bg` | Resumes a stopped job in background. | `bg %1` |
| `fg` | Brings job to foreground. | `fg %1` |

---

## 📦 5. Package Management

### Debian/Ubuntu (APT)
| Command | Description | Example |
|----------|--------------|----------|
| `sudo apt update` | Updates package list. | `sudo apt update` |
| `sudo apt upgrade` | Upgrades all packages. | `sudo apt upgrade` |
| `sudo apt install <pkg>` | Installs a package. | `sudo apt install nginx` |
| `sudo apt remove <pkg>` | Removes a package. | `sudo apt remove nginx` |
| `sudo apt autoremove` | Cleans unused packages. | `sudo apt autoremove` |

### RedHat/CentOS (YUM / DNF)
| Command | Description | Example |
|----------|--------------|----------|
| `sudo yum update` | Updates all packages. | `sudo yum update` |
| `sudo yum install <pkg>` | Installs a package. | `sudo yum install httpd` |
| `sudo yum remove <pkg>` | Removes a package. | `sudo yum remove httpd` |
| `sudo dnf install <pkg>` | Installs using DNF (newer systems). | `sudo dnf install git` |

---

## 🌐 6. Network Commands

| Command | Description | Example |
|----------|--------------|----------|
| `ifconfig` | Displays network interfaces. | `ifconfig` |
| `ip addr` | Modern alternative to ifconfig. | `ip addr show` |
| `ping <host>` | Tests network connectivity. | `ping google.com` |
| `netstat -tuln` | Shows listening ports. | `netstat -tuln` |
| `ss -tuln` | Modern alternative to netstat. | `ss -tuln` |
| `curl <url>` | Sends HTTP requests. | `curl https://example.com` |
| `wget <url>` | Downloads files. | `wget https://example.com/file.zip` |
| `nslookup <domain>` | Looks up DNS records. | `nslookup google.com` |
| `traceroute <host>` | Traces route to host. | `traceroute google.com` |
| `scp <src> <dest>` | Copies files securely over SSH. | `scp file.txt user@server:/home/user/` |
| `ssh <user>@<host>` | Connects to remote server via SSH. | `ssh ubuntu@192.168.1.10` |

---

## 🔐 7. User Management

| Command | Description | Example |
|----------|--------------|----------|
| `who` | Lists logged-in users. | `who` |
| `id <user>` | Shows user ID and groups. | `id ubuntu` |
| `useradd <name>` | Creates new user. | `sudo useradd devuser` |
| `passwd <user>` | Sets or changes password. | `sudo passwd devuser` |
| `usermod -aG <group> <user>` | Adds user to group. | `sudo usermod -aG sudo devuser` |
| `deluser <name>` | Deletes user (Debian). | `sudo deluser test` |
| `userdel <name>` | Deletes user (RedHat). | `sudo userdel test` |

---

## 🧩 8. Disk & Storage

| Command | Description | Example |
|----------|--------------|----------|
| `lsblk` | Lists block devices (disks). | `lsblk` |
| `blkid` | Shows UUID and filesystem type. | `blkid` |
| `mount <dev> <dir>` | Mounts a device. | `sudo mount /dev/sdb1 /mnt` |
| `umount <dir>` | Unmounts device. | `sudo umount /mnt` |
| `fdisk -l` | Lists disk partitions. | `sudo fdisk -l` |
| `df -Th` | Shows filesystem info. | `df -Th` |

---

## 🧠 9. Compression & Archiving

| Command | Description | Example |
|----------|--------------|----------|
| `tar -cvf <file.tar> <dir>` | Creates a tar archive. | `tar -cvf backup.tar /home/user` |
| `tar -xvf <file.tar>` | Extracts tar file. | `tar -xvf backup.tar` |
| `gzip <file>` | Compresses file. | `gzip notes.txt` |
| `gunzip <file.gz>` | Decompresses file. | `gunzip notes.txt.gz` |
| `zip <archive.zip> <files>` | Creates ZIP file. | `zip code.zip *.py` |
| `unzip <archive.zip>` | Extracts ZIP file. | `unzip code.zip` |

---

## 🧩 10. System Services

| Command | Description | Example |
|----------|--------------|----------|
| `systemctl status <service>` | Checks service status. | `systemctl status nginx` |
| `systemctl start <service>` | Starts service. | `sudo systemctl start nginx` |
| `systemctl stop <service>` | Stops service. | `sudo systemctl stop nginx` |
| `systemctl restart <service>` | Restarts service. | `sudo systemctl restart nginx` |
| `systemctl enable <service>` | Enables service at boot. | `sudo systemctl enable docker` |
| `systemctl disable <service>` | Disables service at boot. | `sudo systemctl disable docker` |

---

## 🧹 11. Cleanup & History

| Command | Description | Example |
|----------|--------------|----------|
| `history` | Lists command history. | `history` |
| `!<number>` | Runs command by history number. | `!100` |
| `clear` | Clears terminal screen. | `clear` |
| `alias` | Creates command shortcut. | `alias ll='ls -la'` |
| `unalias` | Removes alias. | `unalias ll` |

---

## 💡 12. Example Workflow

```bash
# 1. Create and navigate directory
mkdir devops && cd devops

# 2. Create a new file
touch readme.txt

# 3. Edit file
nano readme.txt

# 4. Check disk usage
df -h

# 5. Check running services
systemctl status docker

# 6. Monitor logs
tail -f /var/log/syslog
