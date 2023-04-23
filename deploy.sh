#!/bin/bash

TARGET=$1
USERNAME=$2
PASSW=$3
if [ -z "$TARGET" ] || [ -z "$USERNAME" ] || [ -z "$PASSW" ] ; then
  echo "Usage: bash deploy.sh 39.104.205.93 kx xiaoxiao\!1"
	exit 0
fi

echo "hugo -D"
hugo -D

echo "Building..."
tar -czf public.tar public

echo "$PASSW" | ssh -tt $USERNAME@$TARGET '
[ ! -d /opt/soft/webapp ] && sudo mkdir -p /opt/soft/webapp && sudo chown -R '$USERNAME':'$USERNAME' /opt/soft/webapp'

echo "scp -p -C overwatchservice.tar.gz $USERNAME@$TARGET:/opt/soft"
scp -p -C public.tar $USERNAME@$TARGET:/opt/soft/webapp

echo "$PASSW" | ssh -tt $USERNAME@$TARGET '
cd /opt/soft/webapp &&
rm -rf kanxingkeji &&
tar -xzf public.tar &&
mv public kanxingkeji
'
