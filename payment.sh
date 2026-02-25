#!/bin/bash

source ./common.sh
check_rootuser
appname="payment"
python_setup
system_roboshopuser
app_setup
service_file
systemctl_services

cp $script_dir/payment.service /etc/systemd/system/$appname.service
validate $? "copyting payment service"

systemctl restart $appname &>>$logs_file
validate $? "restarting $appname"
