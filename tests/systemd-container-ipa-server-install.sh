#!/bin/bash

set -e
# set -x

C="$1"
shift

if ! docker exec $C ipa-server-install -U -r EXAMPLE.TEST -p Secret123 -a Secret123 --setup-dns --no-forwarders --no-ntp ; then
	FAILED=$( docker exec $C systemctl list-units --state=failed --no-pager -l --no-legend | tee /dev/stderr | sed 's/ .*//' | sort )
	for s in $FAILED ; do
		docker exec $C systemctl status $s --no-pager -l || :
	done
	exit 1
fi
MACHINE_ID=$( docker exec $C cat /etc/machine-id )
docker exec $C ls -la /var/log/journal/$MACHINE_ID/system.journal /var/log/ipaserver-install.log

echo OK $0.

