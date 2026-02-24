#!/bin/bash

source ./common.sh
check_rootuser

dnf module disable redis -y &>>$logs_file
validate $? "disable redis default version"

dnf module enable redis:7 -y &>>$logs_file
validate $? "enable redis 7 version"

dnf install redis -y &>>$logs_file
validate $? "installing redis"

sed -i 's/127.0.0.1/0.0.0.0/g' /etc/redis/redis.conf
sed -i '/protected-mode/ c protected-mode no' /etc/redis/redis.conf  #c means change in the line from yes to no

systemctl enable redis &>>$logs_file
systemctl start redis
validate $? "enable and start redis"
