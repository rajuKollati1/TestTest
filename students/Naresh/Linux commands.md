# 🐧 Linux Basic Commands

## 📂 1. File and Directory Commands
| Command | Description | Example |
|----------|--------------|----------|
| `pwd` | Show current working directory | `pwd` |
| `ls` | List files and directories | `ls -l` |
| `cd` | Change directory | `cd Documents` |
| `mkdir` | Create new directory | `mkdir myfolder` |
| `rmdir` | Remove empty directory | `rmdir oldfolder` |
| `rm` | Delete files or directories | `rm file.txt`, `rm -r folder` |
| `cp` | Copy files or folders | `cp file.txt backup.txt` |
| `mv` | Move or rename files | `mv old.txt new.txt` |
| `touch` | Create new empty file | `touch newfile.txt` |
| `cat` | View file contents | `cat file.txt` |
| `head` | Show first 10 lines of file | `head file.txt` |
| `tail` | Show last 10 lines of file | `tail -f logfile.txt` |

---

## ⚙️ 2. System Information Commands
| Command | Description |
|----------|-------------|
| `uname -a` | Show system information |
| `hostname` | Display system hostname |
| `uptime` | Show how long the system has been running |
| `whoami` | Show current logged-in user |
| `top` | Display running processes |
| `ps` | Show current processes |
| `df -h` | Show disk space usage |
| `free -h` | Show memory usage |
| `lscpu` | Show CPU details |
| `lsblk` | List storage devices |

---

## 🧑‍💻 3. User Management
| Command | Description |
|----------|-------------|
| `who` | Show logged-in users |
| `adduser username` | Create a new user |
| `passwd username` | Set user password |
| `deluser username` | Delete a user |
| `su username` | Switch user |
| `id` | Show current user ID and groups |

---

## 🔒 4. Permissions and Ownership
| Command | Description | Example |
|----------|-------------|----------|
| `chmod` | Change file permissions | `chmod 755 file.txt` |
| `chown` | Change file owner | `chown user:group file.txt` |
| `ls -l` | View file permissions | `ls -l` |

---

## 🌐 5. Network Commands
| Command | Description | Example |
|----------|-------------|----------|
| `ping` | Check connectivity | `ping google.com` |
| `ifconfig` | Show IP and network interfaces | |
| `ip addr` | Show IP address | |
| `netstat -tuln` | Show active network ports | |
| `curl` | Transfer data from URLs | `curl https://example.com` |
| `wget` | Download files | `wget https://example.com/file.txt` |

---

## 📦 6. Package Management
| Command | Description | Example |
|----------|-------------|----------|
| `sudo apt update` | Update package lists | |
| `sudo apt upgrade` | Upgrade installed packages | |
| `sudo apt install packagename` | Install new package | `sudo apt install git` |
| `sudo apt remove packagename` | Remove a package | `sudo apt remove nginx` |
| `sudo apt autoremove` | Remove unused packages | |

---

## 🧰 7. File Compression
| Command | Description | Example |
|----------|-------------|----------|
| `tar -cvf file.tar folder/` | Create tar archive | |
| `tar -xvf file.tar` | Extract tar archive | |
| `gzip file.txt` | Compress file | |
| `gunzip file.txt.gz` | Decompress file | |

---

## 🔍 8. Searching and Finding
| Command | Description | Example |
|----------|-------------|----------|
| `find /path -name filename` | Search file by name | `find /home -name test.txt` |
| `grep "text" filename` | Search for text in a file | `grep "root" /etc/passwd` |

---

## 🧹 9. System Maintenance
| Command | Description |
|----------|-------------|
| `sudo reboot` | Restart the system |
| `sudo shutdown now` | Shut down immediately |
| `history` | Show command history |
| `clear` | Clear the terminal screen |

---

## 🧾 10. Useful Shortcuts
| Shortcut | Action |
|-----------|--------|
| `Ctrl + C` | Stop running command |
| `Ctrl + L` | Clear terminal |
| `Ctrl + D` | Logout or exit terminal |
| `↑ / ↓` | Browse command history |

---

## 🧑‍🏫 Example Practice Commands
```bash
pwd
mkdir practice
cd practice
touch hello.c
ls -l
cat > hello.c
gcc hello.c -o hello
./hello
```

---

### ✅ Tip:
Use `man commandname` to learn more. Example:
```bash
man ls
```
