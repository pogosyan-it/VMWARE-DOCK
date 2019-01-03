#!/bin/bash

curdate="`date \+\%Y_\%m_\%d_\%H_\%M`"
backupdir="/home/it/1C_Backup/$curdate"
log="/home/it/1C_Backup/LOG"
log_name="`date \+\%Y_\%m_\%d`"

fromdir1="/mnt/1C/AccountingBase"
fromdir2="/mnt/1C/ZUP_NEW"

todir1="$backupdir/BUH/"
todir2="$backupdir/ZUP/"

        mkdir $backupdir
        mkdir $todir1
        mkdir $todir2
        mkdir -p $log
        chmod 0777 $backupdir
        chmod 0777 $todir1
        chmod 0777 $todir2
       
        cp $fromdir1 $todir1 -r
        cp $fromdir2 $todir2 -r

   cd "/home/it/1C_Backup"
   tar -czf "$curdate".gz $curdate 2>$log/$log_name.txt
   rm $backupdir -r
 
        cd $log
        
        size=$(du -b $log_name.txt | awk '{print $1}')

        if [ $size -eq 0 ]; then
              rm $log_name.txt
              echo "1C DOCK Backup done successfully" | mail -s "1C DOCK backup" it@int.dmcorp.ru
        else
              mail -s "1C backup REPORT" it@int.dmcorp.ru < $log/$log_name.txt
        fi


