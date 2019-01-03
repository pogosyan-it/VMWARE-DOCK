#!/bin/sh

cd /scripts
rm file_list.txt 2>>/dev/null
#z=`cat /scripts/WM_Name.txt | wc -l`
#for i in `seq 1 $z`;  do 
name=`cat WM_Name.txt | tail -n 1`
id=`vim-cmd vmsvc/getallvms | grep $name | awk '{print $1}'`

dir="/vmfs/volumes/Backup"
curdate="`date \+\%Y_\%m_\%d`"
LOGFILE=/scripts/Log/"$curdate"_Samba.txt
dest="/vmfs/volumes/WM_Store/SAMBA_backup"

vim-cmd vmsvc/snapshot.create $id Snapshot_$name
sleep 5s
task=`vim-cmd vmsvc/get.tasklist $id`
pattern="(ManagedObjectReference) []"

log()
       {
           echo $(date)" "$1 >> $LOGFILE
       }

Movefiles()
           {  
              mkdir $dest/"$name"_"$curdate"
           cd $dir
           find . -name "$name*.vmdk" -exec cp '{}' $dest/"$name"_"$curdate" \;  2>>$LOGFILE
           find . \( -name "$name*.vmx" -or -name "$name.*vmx~*" \) -type f -exec cp '{}' $dest/"$name"_"$curdate" \; 2>>$LOGFILE
           log "Files Copy is complet"
           vim-cmd vmsvc/snapshot.removeall $id
             }

WaitForcomplete()
  {
      log " Not done yet, waiting 2m"
      sleep 2m
      Chekstate

  }
Chekstate()
   {
      task=`vim-cmd vmsvc/get.tasklist $id`
      if [ "$task" == "$pattern" ]; then

          res="TRUE"
          echo $res
          Movefiles
          log "Task completed!"
        else

           res="FALSE"
           echo $res
           WaitForcomplete

       fi
     }

 Chekstate











     
