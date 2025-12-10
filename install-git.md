# 📥 How to Install Git

This guide provides simple, step-by-step instructions for installing Git, the most popular version control system, on your computer.

---

## On Windows

The easiest way to install Git on Windows is to use the official "Git for Windows" installer.

1.  **Download the Installer**: Go to the official Git website: [https://git-scm.com/download/win](https://git-scm.com/download/win). The download should start automatically.

2.  **Run the Installer**: Once downloaded, run the installer. The default options are sensible for most users, so you can generally click "Next" through all the steps. This will install Git and the useful "Git Bash" terminal.

3.  **Verify Installation**: Open a new Command Prompt or Git Bash and run:
    ```bash
    git --version
    ```

---

## On macOS

The most common way to install Git on macOS is with [Homebrew](https://brew.sh/), a package manager for macOS.

1.  **Install Homebrew** (if you don't have it): Open your Terminal and run the command found on the Homebrew homepage.

2.  **Install Git**: Once Homebrew is ready, run:
    ```bash
    brew install git
    ```

3.  **Verify Installation**: In the same terminal, run:
    ```bash
    git --version
    ```

---

## On Linux (Debian/Ubuntu)

1.  **Update and Install**: Open a terminal and run the following commands:
    ```bash
    sudo apt update
    sudo apt install git
    ```

2.  **Verify Installation**:
    ```bash
    git --version
    ```