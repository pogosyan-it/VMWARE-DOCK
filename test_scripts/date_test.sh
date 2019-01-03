#!/bin/bash

date_start=$(date)
echo $date_start
sleep 1m
date_end=$(date)
echo "date_start=$date_start and date_stop=$date_end" | mail -s "Time Interval" it@int.dmcorp.ru
