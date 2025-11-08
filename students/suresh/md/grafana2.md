sssCommand	Description
export EDITOR=nano	Sets nano as the default editor for command-line tools.
export VISUAL=nano	Sets nano as the default editor for visual applications.
File and Directory Management
Command	Description
ls -la	List all files and directories with detailed information, including hidden ones.
cd /path/to/directory	Change the current directory.
mkdir mydirectory	Create a new directory.
mkdir -p /path/to/new/directory	Create a directory and all its parent directories if they don't exist.
rmdir mydirectory	Remove an empty directory.
rm file.txt	Delete a file.
rm -r mydirectory	Recursively remove a directory and all its contents.
touch file.txt	Create an empty file or update its modification timestamp.
cp file1.txt file2.txt	Copy a file.
cp -r dir1/ dir2/	Recursively copy a directory and its contents.
mv file.txt /path/to/destination	Move or rename a file or directory.
File Permissions
Command	Description
chmod 755 file.txt	Change file permissions to rwxr-xr-x (owner can read/write/execute, group/others can read/execute).
chmod -R 755 /path/to/directory	Recursively change permissions for all files and subdirectories.
chown user:group file.txt	Change the owner and group of a file.
chown -R user:group /path/to/dir	Recursively change the owner and group for all files and directories.
File Content Operations
Command	Description
cat file.txt	Display the entire contents of a file.
less file.txt	View the contents of a file page by page, with navigation.
head file.txt	Show the first 10 lines of a file.
tail file.txt	Show the last 10 lines of a file.
tail -f /var/log/syslog	Continuously watch and display new lines added to a file, like a log.
echo "Text" > file.txt	Write text to a file, overwriting its current content.
echo "More text" >> file.txt	Append text to the end of a file.
nano file.txt	Open a file in the nano text editor.
Searching and Filtering
Command	Description
grep "keyword" file.txt	Search for a specific keyword within a file.
grep -r "keyword" /path/to/dir	Recursively search for a keyword in all files within a directory.
find /path/to/dir -name "*.txt"	Find all files with a .txt extension in a directory.
find /path -type f -size +1M	Find all files larger than 1 MB in a given path.
awk '{print $1}' file.txt	Print the first column of a file's content.
sed 's/old/new/g' file.txt	Replace all occurrences of 'old' with 'new' in a file's content.
Network Operations
Command	Description
ping google.com	Check network connectivity to a host.
curl http://example.com	Fetch the contents of a URL.
curl -I http://example.com	Fetch only the HTTP headers of a URL.
wget http://example.com/file.zip	Download a file from a URL.
netstat -tuln	Show all listening TCP and UDP ports.
ifconfig	Show network interface configurations and IP addresses (legacy).
ip a	Show network interfaces and IP addresses (modern).
ss -tuln	Show active network connections (a modern replacement for netstat).
traceroute google.com	Show the network path (route) packets take to a host.
Process Management
Command	Description
ps aux	Show all running processes on the system.
top	Display real-time system statistics and running processes.
htop	An interactive process viewer (more user-friendly than top).
kill <PID>	Terminate a process with a specific Process ID (PID).
kill -9 <PID>	Forcefully terminate a process that is not responding.
pkill -f "process name"	Kill processes that match a given name.
systemctl start <service>	Start a system service (using systemd).
systemctl stop <service>	Stop a system service.
systemctl restart <service>	Restart a system service.
systemctl status <service>	Check the current status of a service.
Disk and System Information
Command	Description
df -h	Show disk space usage in a human-readable format.
du -sh /path/to/dir	Show the total size of a directory.
free -m	Show available and used memory in megabytes.
uname -a	Show detailed system and kernel information.
hostname	Show or set the system's hostname.
uptime	Show how long the system has been running.
whoami	Show the current logged-in username.
last	Show a list of the last logged-in users.
Package Management
Debian/Ubuntu
Command	Description
apt-get update	Update the local package index.
apt-get upgrade	Upgrade all installed packages to their latest versions.
apt-get install <package>	Install a new package.
apt-get remove <package>	Remove a package.
dpkg -i package.deb	Install a package from a .deb file.
RHEL/CentOS
Command	Description
yum update	Update all installed packages.
yum install <package>	Install a new package.
yum remove <package>	Remove a package.
rpm -i package.rpm	Install a package from a .rpm file.
System Monitoring and Analysis
Command	Description
dmesg	Show kernel and boot messages.
journalctl -xe	Show systemd journal logs with detailed error information.
iostat	Show CPU and I/O statistics.
vmstat	Show virtual memory statistics.
sar	Collect, report, or save system activity information.
SSH and Remote Management
Command	Description
ssh user@remote_host	Connect to a remote host via SSH.
scp file.txt user@remote:/path	Securely copy a file to a remote host.
scp user@remote:/path/file.txt .	Securely copy a file from a remote host to the current directory.
rsync -av /source/ /dest/	Synchronize files and directories between locations.
User Management
Command	Description
useradd username	Create a new user account.
usermod -aG sudo username	Add a user to the sudo group to grant administrative privileges.
passwd username	Change a user's password.
userdel username	Delete a user account.
groupadd groupname	Create a new user group.
usermod -aG groupname username	Add a user to an existing group.
System Configuration
Command	Description
crontab -e	Edit the current user's scheduled cron jobs.
crontab -l	List the current user's cron jobs.
history	Show the history of commands executed in the current session.
alias ll='ls -la'	Create a shortcut (alias) for a command.
export PATH=$PATH:/new/path	Add a new directory to the system's PATH variable.
Useful Tools
Command	Description
tar -cvf archive.tar /path	Create a .tar archive from a file or directory.
tar -xvf archive.tar	Extract files from a .tar archive.
zip -r archive.zip /path	Create a .zip archive from a file or directory.
unzip archive.zip	Extract files from a .zip archive.
md5sum file.txt	Compute the MD5 checksum for a file.
sha256sum file.txt	Compute the SHA-256 checksum for a file.
Miscellaneous
Command	Description
date	Show or set the system date and time.
cal	Show a calendar for the current month.
echo $VARIABLE	Print the value of an environment variable.
env	Show all environment variables.
clear	Clear the terminal screen.
