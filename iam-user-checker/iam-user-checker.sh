#!/bin/sh	

IFS='
'

for line in `cat ~/role_list.csv`
         do
#                 role1=`echo ${line} | cut -d ',' -f 1`
#                 role2=`echo ${line} | cut -d ',' -f 2`

#echo "${role1}"  >> ~/check_log/test.txt
#echo "${role2}"  >> ~/check_log/test.txt
#echo "------------------"    >> ~/check_log/test.txt

#echo "${role1}"
#echo "${role2}"
#echo "------------------"

sed  ${line} ~/out4.csv > ~/out4.csv

done
