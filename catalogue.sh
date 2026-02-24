#!/bin/bash

source ./common.sh #calling another script
check_rootuser  #checking root user access
nodejs_setup   #calling nodejs function
system_roboshopuser #roboshop user function
app_setup
appname=catalogue

service_file
systemctl_services
MONGODB_HOST=mongodb.jarugula.online



npm install &>>$logs_file
validate $? "installing dependencies"

cp $script_dir/mongo.repo /etc/yum.repos.d/mongo.repo
validate $? "copying the mongo repo"

dnf install mongodb-mongosh -y
validate $? "installing mongodb"

INDEX=$(mongosh --host $MONGODB_HOST --quiet  --eval 'db.getMongo().getDBNames().indexOf("catalogue")')

if [ $INDEX -le 0 ]; then
    mongosh --host $MONGODB_HOST </app/db/master-data.js &>>$logs_file
    VALIDATE $? "Loading products"
else
    echo -e "Products already loaded ... $Y SKIPPING $N"
fi

