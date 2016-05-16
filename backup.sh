#!/bin/sh

tar c ~/TowerOwnCloud | /usr/local/bin/zbackup --password-file ~/.backup_password backup /Volumes/p01504/backups/backups/towerowncloud-`date '+%Y-%m-%d'`

