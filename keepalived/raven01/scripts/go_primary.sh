#!/bin/bash

# --- NEW SYNC CHECK BLOCK ---
MAX_RETRIES=24  # Give it 2 minutes (24 * 5s)
COUNT=0

# Force a reconnection attempt
/sbin/drbdadm up r0
/sbin/drbdadm connect --discard-my-data r0

# Wait until we are UpToDate (meaning head02 has sent us all the data)
# We also check if we can even see the peer
while [ "$(/sbin/drbdadm status r0 | grep -c 'UpToDate/UpToDate')" -eq 0 ] && [ $COUNT -lt $MAX_RETRIES ]; do
    echo "Waiting for recovery sync from head02... (Attempt $COUNT)"
    sleep 5
    ((COUNT++))
done
# ----------------------------

# 1. Promote DRBD (Now that we are UpToDate)
/sbin/drbdadm primary r0

# 2. Mount the drive
/bin/mount /dev/drbd0 /data

# 3. Start NFS
/bin/systemctl start nfs-kernel-server
systemctl start lsyncd

