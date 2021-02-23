#!/bin/bash
mkdir -p /tmp/.test/
blkid  |/bin/grep -v grep | grep -vEi 'bc397d12-bb61-41f4-9114-afea7b540442|5480b81e-1d08-4bad-bc72-4173794df38e|gIWKiB-HJ6c-Z8bF-dL7V-dlKn-c5UB-N2Dvws|fd8437b0-fd07-4839-b105-53c662e5d020' |awk '{print $1 "#" $2}' |sed 's/://g'| awk -F# '{print $1}'  >/tmp/.test/hd.txt

blkid  |/bin/grep -v grep | grep -vEi 'bc397d12-bb61-41f4-9114-afea7b540442|5480b81e-1d08-4bad-bc72-4173794df38e|gIWKiB-HJ6c-Z8bF-dL7V-dlKn-c5UB-N2Dvws|fd8437b0-fd07-4839-b105-53c662e5d020' |awk '{print $1 "#" $2}' |sed 's/://g'| awk -F# '{print $2}'  >/tmp/.test/uuid.txt

lvs  |/bin/grep -v grep | grep -vEi 'vg_zzz' | awk '{print $2}' > /tmp/.test/lvm.txt

while true; do
cat /tmp/.test/hd.txt | while read hd;do
cat /tmp/.test/lvm.txt | while read lvm;do
cat /tmp/.test/uuid.txt | while read uuid;do
vgexport $lvm
umount $hd
umount -l $uuid
chmod 000 /media/
done
done
done
done
