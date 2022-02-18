#!/bin/bash
# mysqldump with Date+Time in Name, compress and delete Files older then X Days
# H.Eudenbach in 2021 - holger@eude.rocks - no warranties given!

db_name1=database1  #Name of Database to dump
db_name2=database2  #Name of Database to dump, add more if you need more Databases
back_path=/backup   #Path to Backup Directory no / at end!
back_ret=+5         #Retention in Days

mysqldump $db_name1 | gzip -c > $back_path\/$db_name1\_$(date +%Y-%m-%d-%H.%M.%S).gz #&& #uncomment && to add more Databases, or enabled deleting further down

#uncomment to enable 2nd Database dump, add more for more Databases
#mysqldump $db_name2 | gzip -c > $back_path\/$db_name2\_$(date +%Y-%m-%d-%H.%M.%S).gz #&& #uncomment && to add more Databases

#uncomment following line to Search the back_path Directory for .gz files older then back_ret in Days and DELETE them! - no warranties, check twice what you are doing!
#find $back_path -type f -mtime $back_ret -name '*.gz' -execdir rm -- '{}' \;