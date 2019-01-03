#!/bin/sh

cd /scripts
rm file_list.txt 2>>/dev/null
#z=`cat /scripts/WM_Name.txt | wc -l`
#for i in `seq 1 $z`;  do 
name=`cat WM_Name.txt | head -n 1`                               #  WM_Name.txt -   ���� ����������   ��� ����������� ������ (��. start_up.sh)
id=`vim-cmd vmsvc/getallvms | grep $name | awk '{print $1}'`     # vim-cmd vmsvc/getallvms - ����� ������ ����������� ����� �� ���� ������� 

dir1="/vmfs/volumes/datastore1/$name"
dir2="/vmfs/volumes/WM_Store/Win_SRV_2008"
dir3="/vmfs/volumes/WM_Store/1C"
curdate="`date \+\%Y_\%m_\%d`"   
LOGFILE=/scripts/Log/$curdate.txt                                   
dest="/vmfs/volumes/Backup_for_Win2008"                                            # ���������� ��� ������   
    
vim-cmd vmsvc/snapshot.create $id Snapshot_$name                                   # ������� �������� ��������.
sleep 5s
task=`vim-cmd vmsvc/get.tasklist $id`                                                      # ����� ������ ���������
pattern="(ManagedObjectReference) []"                                                      #����� ������� ����� ��� �������� � �� ���������. 

log()                                                                                     # ������� �����������
       {
           echo $(date)" "$1 >> $LOGFILE
       }

Movefiles()
           {  
                                                                            # �������  ����������� ������ �� �� NFS                                    
              mkdir $dest/"$name"_"$curdate"
              
              for dir in "$dir1" "$dir2" "$dir3" 
        do                                      
           cd $dir
           find . -name "*.vmdk" -exec cp '{}' $dest/"$name"_"$curdate" \;  2>>$LOGFILE     # ����������� ���� ������  � ����������� vmdk (������ ������) �� �������� ���� 
           find . \( -name "*vmx" -or -name "*vmx~*" \) -type f -exec cp '{}' $dest/"$name"_"$curdate" \; 2>>$LOGFILE  # *vmx � vmx~  - ����� ������������ ��
           log "Files Copy is complet"
        done 
         vim-cmd vmsvc/snapshot.removeall $id
             }

WaitForcomplete()                                                                         # ������� �������� ��������� ���������� ��������.
  {
      log " Not done yet, waiting 2m"
      sleep 2m
      Chekstate

  }
Chekstate()                                                                              # ������� �������� ���������� �������� ���� �������� �� ������� �� Movefiles 
   {                                                                                     # ���� ��� �� ������� 2 ������ (���� � WaitForcomplete )
      task=`vim-cmd vmsvc/get.tasklist $id`                                              # ����� ������ ���������
                                                                                               
      if [ "$task" == "$pattern" ]; then                                                 # �������� ��������� �������� �������� ��������

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



            
                                                
                                                  
                                            
                                                    




             
             


  


  







  












     
