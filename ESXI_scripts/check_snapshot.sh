#!/bin/sh

cd /scripts
rm file_list.txt 2>>/dev/null
#z=`cat /scripts/WM_Name.txt | wc -l`
#for i in `seq 1 $z`;  do 
name=`cat WM_Name.txt | head -n 1`                               #  WM_Name.txt -   файл содержащий   имя виртуальной машины (см. start_up.sh)
id=`vim-cmd vmsvc/getallvms | grep $name | awk '{print $1}'`     # vim-cmd vmsvc/getallvms - вывод списка виртуальных машин со всей лабудой 

dir1="/vmfs/volumes/datastore1/$name"
dir2="/vmfs/volumes/WM_Store/Win_SRV_2008"
dir3="/vmfs/volumes/WM_Store/1C"
curdate="`date \+\%Y_\%m_\%d`"   
LOGFILE=/scripts/Log/$curdate.txt                                   
dest="/vmfs/volumes/Backup_for_Win2008"                                            # Директория для бэкапа   
    
vim-cmd vmsvc/snapshot.create $id Snapshot_$name                                   # Команда создания снапшота.
sleep 5s
task=`vim-cmd vmsvc/get.tasklist $id`                                                      # Вывод списка процессов
pattern="(ManagedObjectReference) []"                                                      #Вывод команды когда все действия с ВМ завершены. 

log()                                                                                     # Функция Логирования
       {
           echo $(date)" "$1 >> $LOGFILE
       }

Movefiles()
           {  
                                                                            # Функция  копирования файлов ВМ на NFS                                    
              mkdir $dest/"$name"_"$curdate"
              
              for dir in "$dir1" "$dir2" "$dir3" 
        do                                      
           cd $dir
           find . -name "*.vmdk" -exec cp '{}' $dest/"$name"_"$curdate" \;  2>>$LOGFILE     # Копирование всех файлов  с расширением vmdk (образы дисков) на бэкапный диск 
           find . \( -name "*vmx" -or -name "*vmx~*" \) -type f -exec cp '{}' $dest/"$name"_"$curdate" \; 2>>$LOGFILE  # *vmx и vmx~  - файлы конфигураций ВМ
           log "Files Copy is complet"
        done 
         vim-cmd vmsvc/snapshot.removeall $id
             }

WaitForcomplete()                                                                         # Функция ожидания окончания выполнения снапшота.
  {
      log " Not done yet, waiting 2m"
      sleep 2m
      Chekstate

  }
Chekstate()                                                                              # Функция проверки выполнения снапшота если выполнен то переход на Movefiles 
   {                                                                                     # Если нет то ожидаем 2 минуты (идем в WaitForcomplete )
      task=`vim-cmd vmsvc/get.tasklist $id`                                              # Вывод списка процессов
                                                                                               
      if [ "$task" == "$pattern" ]; then                                                 # Проверка окончания процесса создания снапшота

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



            
                                                
                                                  
                                            
                                                    




             
             


  


  







  












     
