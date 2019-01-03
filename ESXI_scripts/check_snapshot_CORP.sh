#!/bin/sh
z=`cat /scripts/WM_Name.txt | wc -l`
for i in `seq 1 $z`;  do
#echo $z
name=`cat /scripts/WM_Name.txt | head -n $i | tail -n 1`        #  WM_Name.txt -   файл содержащий   имена виртуальных машины (см. start_up.sh)
#echo $name
id=`vim-cmd vmsvc/getallvms | grep $name | awk '{print $1}'`     # vim-cmd vmsvc/getallvms - вывод списка виртуальных машин со всей лабудой 

dir="/vmfs/volumes/datastore1/$name"
curdate="`date \+\%Y_\%m_\%d`"   
LOGFILE=/tmp/$curdate.txt                                   
dest="/vmfs/volumes/NAS_IP6"                                       # Смонтированная на хосте ESXi директория NFS    
cd $dir
find . -name '*vmdk' | cut -c 3-  > /file_list.txt                # Записываем в  file_list.txt все с расширением vmdk - образ диска ВМ. 
find . \( -name "*vmx" -or -name "*vmx~*" \) -type f | cut -c 3- >> /file_list.txt  # *vmx и vmx~  - файлы конфигураций ВМ
vim-cmd vmsvc/snapshot.create $id Snapshot_$name                                   # Команда создания снапшота.
sleep 5s
task=`vim-cmd vmsvc/get.tasklist $id`                                                      # Вывод списка процессов
pattern="(ManagedObjectReference) []"                                                      #Вывод команды когда все действия с ВМ завершены. 

log()                                                                                     # Функция Логирования
       {
           echo $(date)" "$1 >> $LOGFILE
       }

Movefiles(){                                                                              # Функция  копирования файлов ВМ на NFS                                    

              file="/file_list.txt"
              mkdir $dest/"$name"_"$curdate"
              while read line
              do
              cp $line $dest/"$name"_"$curdate" 2>>$LOGFILE
              log "Files Copy is complet"
              done < $file
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
done
                                                                                              




            
                                                
                                                  
                                            
                                                    




             
             


  


  







  












     
