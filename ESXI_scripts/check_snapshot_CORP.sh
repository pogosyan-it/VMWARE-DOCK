#!/bin/sh
z=`cat /scripts/WM_Name.txt | wc -l`
for i in `seq 1 $z`;  do
#echo $z
name=`cat /scripts/WM_Name.txt | head -n $i | tail -n 1`        #  WM_Name.txt -   ���� ����������   ����� ����������� ������ (��. start_up.sh)
#echo $name
id=`vim-cmd vmsvc/getallvms | grep $name | awk '{print $1}'`     # vim-cmd vmsvc/getallvms - ����� ������ ����������� ����� �� ���� ������� 

dir="/vmfs/volumes/datastore1/$name"
curdate="`date \+\%Y_\%m_\%d`"   
LOGFILE=/tmp/$curdate.txt                                   
dest="/vmfs/volumes/NAS_IP6"                                       # �������������� �� ����� ESXi ���������� NFS    
cd $dir
find . -name '*vmdk' | cut -c 3-  > /file_list.txt                # ���������� �  file_list.txt ��� � ����������� vmdk - ����� ����� ��. 
find . \( -name "*vmx" -or -name "*vmx~*" \) -type f | cut -c 3- >> /file_list.txt  # *vmx � vmx~  - ����� ������������ ��
vim-cmd vmsvc/snapshot.create $id Snapshot_$name                                   # ������� �������� ��������.
sleep 5s
task=`vim-cmd vmsvc/get.tasklist $id`                                                      # ����� ������ ���������
pattern="(ManagedObjectReference) []"                                                      #����� ������� ����� ��� �������� � �� ���������. 

log()                                                                                     # ������� �����������
       {
           echo $(date)" "$1 >> $LOGFILE
       }

Movefiles(){                                                                              # �������  ����������� ������ �� �� NFS                                    

              file="/file_list.txt"
              mkdir $dest/"$name"_"$curdate"
              while read line
              do
              cp $line $dest/"$name"_"$curdate" 2>>$LOGFILE
              log "Files Copy is complet"
              done < $file
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
done
                                                                                              




            
                                                
                                                  
                                            
                                                    




             
             


  


  







  












     
