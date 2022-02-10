#!/usr/bin/env bash
# Please run with sudo / root for hdparm

BACKUP_FOLDER=/hddpool/backup  # local backup folder
LOG_FOLDER=/hddpool/logs

SSH_USER=
SSH_PORT=
SRV_ADDRESS=
SRV_FOLDER=  # server folder to be backed up

DISKS_TO_SPINDOWN=(/dev/sda /dev/sdb)  # 30s after the script, these drives will go to standby, replace with your drives

mkdir -p $BACKUP_FOLDER
mkdir -p $LOG_FOLDER
rsync -av --log-file="/hddpool/logs/$(date +%Y.%m.%d_%H:%M:%S)_backup_log.log" \
	-e "ssh -p $SSH_PORT" $SSH_USER@$SRV_ADDRESS:$SRV_FOLDER $BACKUP_FOLDER

sleep 30

for DISK in $DISKS_TO_SPINDOWN; do
	hdparm -y $DISK
done
