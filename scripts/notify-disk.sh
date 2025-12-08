#!/bin/sh
# Shows disk usage notification
DISK_FREE=$(df -h / | awk 'NR==2 {print $4 " free out of " $2}')
notify-send "Disk Space" "Root Partition: $DISK_FREE" -i drive-harddisk
