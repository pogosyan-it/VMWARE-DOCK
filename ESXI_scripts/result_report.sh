#!/bin/sh

dir1=`cat /scripts/WM_Name.txt | head -n 1`_`date \+\%Y_\%m_\%d`
dest1="/vmfs/volumes/Backup_for_Win2008"
if [ -d $dest1/$dir1 ]; then
    vol=`du -h $dest1/$dir1 | awk '{print $1}' | cut -f1 -d"."`
    latter=`du -h $dest1/$dir1 | awk '{print $1}' | tail -c 2`
    latter_true="G"
    used_sp=`df -h | grep Backup_for_Win2008 | awk '{print $5}' | cut -f1 -d"%"`
    echo "Vol=$vol$latter, used_space=$used_sp" > /scripts/res.txt
   if [[ $vol -gt 0 && $used_space -lt 100 && $latter == $latter_true ]]; then
       echo "Backup is done successfully" >> /scripts/res.txt
   else
       echo "Backup fail" >> /scripts/res.txt
   fi
else
    echo "Somthing wrong - no backup directory" >> /scripts/res.txt
fi

