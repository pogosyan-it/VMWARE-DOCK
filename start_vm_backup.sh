#!/bin/sh
dir="/home/it/scripts"
echo "Время начало бэкапа: $(date)" > $dir/date.txt
#bash SVR_WM_ARCHIVE_new.sh 2>/dev/null
scp  $dir/WM_Name.txt 192.168.0.222:/scripts/WM_Name.txt # копируем файл с названием виртуальной машины подлежащей бэкапу на ESXi

ssh -T 192.168.0.222 << EOF                #  Соединение по ключу с гипервизором ESXi
sh /scripts/WM_backup_remove_new.sh           # Запуск скрипта на удаление  старых бекапов
sh /scripts/check_snapshot_SAMBA.sh        # Запускаем скрипт бэкапа виртуальной машины с самбой  
sh /scripts/check_snapshot.sh              # Запускаем скрипт  с виртуальной машиной WinSRV 2008 
sh /scripts/result_report.sh               # Запускаем скрипт  получения отчета о сделанных бэкапах
exit                                                # Закрываем ssh сессию
EOF
cd $dir
echo "Время завершения бэкапа: $(date)" >> date.txt
scp root@192.168.0.222:/scripts/res.txt .
cat res.txt >> date.txt
rm res.txt
mail -s "VM Bacup Dock" it@int.dmcorp.ru < date.txt

