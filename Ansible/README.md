# Ansible Lab Setup

This directory contains a simple Ansible project to test SSH connectivity to lab VMs.

## Installation

### Ubuntu / Debian / WSL (Standard)
```bash
sudo apt update
sudo apt install software-properties-common
sudo add-apt-repository --yes --update ppa:ansible/ansible
sudo apt install ansible
```

## Project Structure
- `inventory.ini`: Defines host IPs (`192.168.1.10`, `192.168.1.20`) and connection variables.
- `ansible.cfg`: Configures default inventory and SSH behavior.
- `ping.yml`: A simple playbook to verify connectivity.

## How to Run
1. Ensure your SSH keys are added to the target VMs.
2. Navigate to this directory.
3. Run the ping test:
   ```bash
   ansible-playbook ping.yml
   ```

## Troubleshooting
If Ansible ignores your `ansible.cfg` due to "world-writable" permissions on Windows/WSL mounts:
1. Move files to your Linux home directory: `cp -r /mnt/c/path/to/ansible ~/`
2. **OR** use the environment variable workaround:
   ```bash
   export ANSIBLE_CONFIG=./ansible.cfg
   ansible-playbook ping.yml
   ```