#!/bin/bash


source ./common.sh #calling common script
check_rootuser



cp mongodb.repo /etc/yum.repos.d/mongo.repo
validate $? "copying mongo repo"

dnf install mongodb-org -y 
validate $? "installing mongodb"

systemctl enable mongod 
systemctl start mongod 
validate $? "enable and start mongodb"

sed -i 's/127.0.0.1/0.0.0.0/g' /etc/mongod.conf
validate $? "allow remote connections"

systemctl restart mongod
validate $? "restart mongodb"

print_total_time