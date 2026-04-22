#!/bin/bash
/sbin/drbdadm up r0
# 1. Stop NFS first to release file locks
systemctl stop nfs-kernel-server
systemctl stop lsyncd
# 2. Unmount safely
umount /data
# 3. Demote DRBD
drbdadm secondary r0

