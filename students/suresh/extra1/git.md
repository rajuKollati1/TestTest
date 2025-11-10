# 🧭 Git Commands Cheat Sheet

## 🪜 1. Basic Setup
```bash
git init
```
> Initializes a new Git repository in the current directory.

```bash
git config --global user.name "Your Name"
git config --global user.email "you@example.com"
```
> Sets your username and email (used in commits).

```bash
git version
```
> Displays the installed Git version.

---

## 📁 2. Working with Files
```bash
git add .
```
> Stages all changes in the current directory for the next commit.

```bash
git status
```
> Shows which files are staged, unstaged, or untracked.

```bash
git commit -m "your message"
```
> Records the staged changes in the repository with a message.

```bash
git log
```
> Shows the commit history.

---

## 🌿 3. Branching
```bash
git branch
```
> Lists all local branches.

```bash
git branch <branch_name>
```
> Creates a new branch.

```bash
git checkout <branch_name>
```
> Switches to the specified branch.

```bash
git checkout -b <branch_name>
```
> Creates and switches to a new branch.

```bash
git merge <branch_name>
```
> Merges the specified branch into the current one.

```bash
git branch -d <branch_name>
```
> Deletes the specified branch.

---

## 🌐 4. Remote Repositories
```bash
git remote -v
```
> Lists all remote connections.

```bash
git remote add origin <repository_URL>
```
> Adds a new remote repository.

```bash
git remote rename <old_name> <new_name>
```
> Renames an existing remote.

```bash
git remote remove <name>
```
> Removes a remote connection.

---

## 🚀 5. Pushing and Pulling
```bash
git push -u origin <branch_name>
```
> Pushes local commits to the remote branch and sets upstream tracking.

```bash
git push
```
> Pushes your committed changes to the remote repository.

```bash
git pull
```
> Fetches and merges changes from the remote repository into the current branch.

---

## 🔄 6. Cloning and Fetching
```bash
git clone <repository_URL>
```
> Creates a copy of a remote repository locally.

```bash
git fetch
```
> Downloads objects and refs from another repository without merging.

---

## 🧹 7. Undoing and Cleaning
```bash
git restore <file>
```
> Restores a file from the last commit.

```bash
git reset <file>
```
> Unstages a staged file.

```bash
git reset --hard
```
> Resets the working directory and staging area to match the last commit (⚠️ discards changes).

---

## 🧠 8. Helpful Tips
- `git help` → Displays available Git commands.
- `git diff` → Shows changes not yet staged.
- `git stash` → Temporarily saves uncommitted work.
- `git tag` → Lists and manages version tags.
- `git show <commit_id>` → Shows details of a specific commit.
