#!/bin/bash
#echo "FUCK"
ssh -T  192.168.0.222  << EOF                #  Соединение по ключу с сервером
/bin/sh /scripts/WM_backup_remove_new.sh     # Запускаем скрипт
exit                                         # Закрываем ssh
EOF

