#!bin/bash;
#入参 数据库root账号 数据库root密码 mysql休眠上限（秒）
if (( $# < 3 ))
then
    echo "入参：数据库root账号 数据库root密码 mysql休眠上限（秒）"
    exit 0
fi

acount=$1
pwd=$2
list=`mysqladmin -u$acount -p$pwd processlist|grep -i sleep|awk -F'|' '{print $2,$7}'|sort -n -k2`
IFS=$'\n' #按行读取，换行分隔符
overtime=$3 #sleep上限，超额kill
regx="sleep"
kilist=""

for i in $list
do
    pid=`echo $i|awk '{print $1}'`
    time=`echo $i|awk '{print $2}'`
    if (( $time >= $overtime ))
    then
        #组装pid
        if (( ${#pid} > 0 ))
        then
            regx=$regx"|"$pid
            kilist=$kilist","$pid
        fi
    fi
done

if (( ${#kilist} > 0 ))
then
    #写日志
    echo -e "[`date -d today +"%Y-%m-%d %T"`] [kill overtime[$overtime s] mysql handle ] : [${kilist: 1}]" >> ./kill_slowSql_log.txt
    `mysqladmin -u$acount -p$pwd processlist|grep -E $regx >> ./kill_slowSql_log.txt`
    #kill 
    `mysqladmin -u$acount -p$pwd kill ${kilist: 1}`
fi