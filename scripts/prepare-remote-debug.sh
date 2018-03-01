#!/bin/bash
WORKSPACEROOT="$1"
REMOTE_IP="$2"

echo $REMOTE_IP

ssh root@$REMOTE_IP systemctl stop mozart-aptp
ssh root@$REMOTE_IP killall -9 gptpd
ssh root@$REMOTE_IP killall -9 gdbserver
rsync -avh -e ssh $WORKSPACEROOT/build/daemons/gptp root@$REMOTE_IP:/usr/sbin
$MOZART_TERM -e "ssh root@$REMOTE_IP gdbserver --multi :9091 /usr/sbin/gptpd"