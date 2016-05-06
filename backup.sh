#!/bin/sh

tar c ~/TowerOwnCloud | zbackup --password-file ~/.backup_password backup /Volumes/p01504/backups/backups/towerowncloud-`date '+%Y-%m-%d'`

