#!/bin/sh

# Backup WSL2 ~/dev directory to Windows partition
# Using ignore patterns from .gitignore_global file
# Set-up with Windows Task Scheduler https://stephenreescarter.net/automatic-backups-for-wsl2/
# BACKUP_DESTINATION_PATH="/mnt/d/Dev/wsl2-dev"
BACKUP_DESTINATION_PATH="/mnt/e/FileHistory/Viktor/LAPTOP-ELNSR21S/Data/D/Code"
BACKUP_PATH="/home/viktor/dev/"

rsync -W -avrt --no-whole-file --inplace --delete --exclude-from ~/.gitignore_global $BACKUP_PATH $BACKUP_DESTINATION_PATH
