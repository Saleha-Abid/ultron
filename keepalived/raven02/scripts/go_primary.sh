#!/bin/bash
/sbin/drbdadm up r0
# 1. Promote DRBD
drbdadm primary r0
# 2. Mount the drive
mount /dev/drbd0 /data
# 3. Start NFS
systemctl start nfs-kernel-server
systemctl start lsyncd

