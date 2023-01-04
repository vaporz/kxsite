#!/bin/bash

TARGET=$1
USERNAME=$2
PASSW=$3
if [ -z "$TARGET" ] || [ -z "$USERNAME" ] || [ -z "$PASSW" ] ; then
  echo "Usage: deploy.sh ip user_name password [cp-only]"
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
