#!/bin/bash

MAX_RETRIES=12  # 12 * 5 seconds = 60 seconds total
COUNT=0

# Force a reconnection attempt
/sbin/drbdadm up r0
/sbin/drbdadm connect r0

# Only wait if the peer node is actually online/connected
if /sbin/drbdadm status r0 | grep -q "connection:"; then
    while [ "$(/sbin/drbdadm status r0 | grep -c 'UpToDate/UpToDate')" -eq 0 ] && [ $COUNT -lt $MAX_RETRIES ]; do
        echo "Waiting for DRBD sync... (Attempt $COUNT)"
        sleep 5
        ((COUNT++))
    done
fi

# 1. Stop NFS first to release file locks
systemctl stop nfs-kernel-server #comment these out for now
systemctl stop lsyncd #comment these out for now

# Now proceed with umount and secondary...
# 2. Unmount safely
umount /data
# 3. Demote DRBD
drbdadm secondary r0

