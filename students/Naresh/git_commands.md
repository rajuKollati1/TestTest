# Git Commands Cheat Sheet

## 📌 Basic Commands

-   `git init` -- Initialize a new Git repository\
-   `git clone <url>` -- Clone a remote repository\
-   `git status` -- Check the current status\
-   `git add <file>` -- Add a file to staging\
-   `git add .` -- Add all files\
-   `git commit -m "message"` -- Commit changes\
-   `git push` -- Push changes to remote\
-   `git pull` -- Pull latest changes\
-   `git log` -- View commit history

## 📌 Branch Commands

-   `git branch` -- List branches\
-   `git branch <name>` -- Create a branch\
-   `git checkout <branch>` -- Switch branch\
-   `git checkout -b <branch>` -- Create + switch branch\
-   `git merge <branch>` -- Merge a branch

## 📌 Remote Repo

-   `git remote -v` -- Show remote URLs\
-   `git remote add origin <url>` -- Add remote\
-   `git push -u origin main` -- Push first time

## 📌 Undo Commands

-   `git restore <file>` -- Undo file changes\
-   `git reset <file>` -- Unstage file\
-   `git reset --hard` -- Reset everything

## 📌 Stash

-   `git stash` -- Save uncommitted changes\
-   `git stash pop` -- Apply stashed changes

## 📌 Delete

-   `git branch -d <branch>` -- Delete branch\
-   `git rm <file>` -- Delete file from repo
