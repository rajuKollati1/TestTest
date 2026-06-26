# WSL Management

Run these commands in **Windows PowerShell**, not inside the Linux terminal:

* `wsl --install` - To install WSL.
* `wsl -l -v` - To list installed distributions and their versions.



wsl -d ubuntu --- for only ubuntu


# Asible install 

sudo apt update
sudo apt install software-properties-common -y
sudo add-apt-repository --yes --update ppa:ansible/ansible
sudo apt install ansible -y
