.

🧾 git-commands.md
# 🧠 Git Commands Cheat Sheet

A complete list of essential Git commands with short descriptions.

---

## ⚙️ Setup

```bash
git config --global user.name "Your Name"
git config --global user.email "you@example.com"
git config --list


📁 Repository Setup
git init                     # Initialize a new Git repository
git clone <repo-url>          # Clone an existing repository


💾 Basic Snapshotting
git status                   # Show the status of changes
git add <file>                # Stage a specific file
git add .                     # Stage all files
git commit -m "Message"       # Commit staged changes
git commit -am "Message"      # Stage and commit all tracked files


🔀 Branching and Merging
git branch                    # List branches
git branch <name>             # Create a new branch
git checkout <name>           # Switch to another branch
git checkout -b <name>        # Create and switch to new branch
git merge <branch>            # Merge branch into current branch
git branch -d <branch>        # Delete a branch


🌐 Remote Repositories
git remote -v                 # Show remote URLs
git remote add origin <url>   # Add a remote repository
git push -u origin main       # Push first time to main branch
git push                      # Push committed changes
git pull                      # Pull latest changes
git fetch                     # Download objects and refs from remote


🧹 Undoing Changes
git restore <file>            # Discard local changes
git restore --staged <file>   # Unstage a file
git reset --hard HEAD         # Remove all local changes
git revert <commit>           # Create a new commit that undoes a previous one


🕒 Viewing History
git log                       # View commit history
git log --oneline --graph     # Short view with branch graph
git show <commit>             # Show details of a commit


🧭 Working with Tags
git tag                       # List tags
git tag <name>                # Create a new tag
git push origin <tag>         # Push tag to remote


🧰 Advanced Commands
git stash                     # Save uncommitted changes
git stash apply               # Reapply stashed changes
git cherry-pick <commit>      # Apply changes from specific commit
git reflog                    # Show reference log of HEAD changes


🧽 Clean Working Tree
git clean -n                  # Show files to be removed
git clean -f                  # Remove untracked files


🧑‍💻 Helpful Shortcuts
git diff                      # Show changes not yet staged
git diff --staged             # Show staged changes
git blame <file>              # Show who changed each line
git shortlog -sn              # Contributor summary


🧭 Example Workflow
git clone <repo-url>
git checkout -b feature-branch
git add .
git commit -m "Added new feature"
git push origin feature-branch
git merge feature-branch
git push origin main


📝 Author: DevOps/Git Learning Guide
📅 Updated: 2025-11-10

---

Would you like me to **generate and give you the actual `.md` file to download** (named `git-commands.md`)?  
I can create it and provide a direct download link.
