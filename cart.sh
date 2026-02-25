#!/bin/bash

source ./common.sh
appname=cart
check_rootuser
nodejs_setup
system_roboshopuser
app_setup
service_file
systemctl_services
print_total_time

npm install &>>$logs_file
validate $? "installing dependencies"

systemctl restart cart
validate $? "restarting cart"
