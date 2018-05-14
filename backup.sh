#!/bin/bash

# Backup file to a directory

curr_dir=$(cd $(dirname $0); pwd)
[ -f $curr_dir/common.sh ] && source "$curr_dir/common.sh"

PROD_BACKUP_DIR=${PROD_BACKUP_DIR:-""}

mkdir -p "$PROD_BACKUP_DIR"
rsync -av --progress "$curr_dir/" "$PROD_BACKUP_DIR/" --exclude python-telegram-bot --exclude python-telegram-bot.tar.gz --exclude .git
