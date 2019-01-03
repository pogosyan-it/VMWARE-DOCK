dir1="/mnt/backup_share"
dir2="/home/it/1C_Backup"
date_NOW="`date +%s`"
#temp_dir="/home/it/temp"
#echo $date_NOW
for dir in $dir1 $dir2 
do
 cd $dir
      for file1 in `find . -type f -regex '.*\(rar\|gz\)'`
 do
   ATime=`stat -c%Y $file1`
   let "delta = $date_NOW - $ATime";
  # echo $delta
   if [ $delta -gt  604800 ]; then
   #echo "$file1 must be deleted"
   rm $file1
  else
   echo "$file1 is good yet"
  fi
 done
done
