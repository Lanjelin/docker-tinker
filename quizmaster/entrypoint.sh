#!/bin/bash
# Checking volume for files, copy if not
if ! [ -e /app/conf/application.conf ]
then
    cp -R /app/conf-bk/* /app/conf/
fi

# Getting stored permissions
LUID=$(cat /entry/perm.txt | awk '{split($0,a,":");print a[1]}')
LGID=$(cat /entry/perm.txt | awk '{split($0,a,":");print a[2]}')
UPD=0
# Checking against parsed permissions
re='^[0-9]+$'
if [[ $PUID =~ $re ]] && [[ $PUID != $LUID ]] ; then
    echo "$PUID:$LGID" > perm.txt
    UPD=1
fi
LUID=$(cat /entry/perm.txt | awk '{split($0,a,":");print a[1]}')
LGID=$(cat /entry/perm.txt | awk '{split($0,a,":");print a[2]}')
if [[ $PGID =~ $re ]] && [[ $PGID != $LGID ]] ; then
    echo "$LUID:$PGID" > perm.txt
    UPD=1
fi
# Updating permissions if changed permissions
if [[ $UPD == 1 ]] ; then
    chown -R $PUID:$PGID /app
fi
# Getting stored permissions
RUID=$(cat /entry/perm.txt | awk '{split($0,a,":");print a[1]}')
RGID=$(cat /entry/perm.txt | awk '{split($0,a,":");print a[2]}')
# Running with stored permissions
/entry/su-exec/su-exec $RUID:$RGID /app/bin/server
