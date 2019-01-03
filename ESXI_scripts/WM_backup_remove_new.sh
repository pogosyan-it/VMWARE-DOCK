#!bin/sh

dir1="/vmfs/volumes/Backup_for_Win2008"
dir2="/vmfs/volumes/WM_Store/SAMBA_backup"
log="/scripts/WM_Log"
curdate="`date \+\%Y_\%m_\%d`"
for dir in $dir1 $dir2; do
#echo $i
cd $dir

N=$(ls | wc -l)
t1=$(stat -c%n\ %Y * | awk '{print $2}'| head -n 1)
dir3=$(stat -c%n\ %Y * | awk '{print $1}'| head -n 1)
t2=$(stat -c%n\ %Y * | awk '{print $2}'| tail -n 1)
dir4=$(stat -c%n\ %Y * | awk '{print $1}'| tail -n 1)
echo "t1=$t1 dir3=$dir3"
echo "t2=$t2 dir4=$dir4"
if [ "$N" -eq 2 ]; then
if  [ "$t1" -lt "$t2" ]; then 
    echo $dir3
    rm -r $dir3
  
elif [ "$t2" -lt "$t1" ]; then

     echo $dir4
     rm -r $dir4
  
fi
else
 echo "DO nothing"
 fi
done
