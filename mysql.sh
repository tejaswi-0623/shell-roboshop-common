#!/bin/bash

source ./common.sh #calling common script
check_rootuser

dnf install mysql-server -y &>>$logs_file
validate $? "installing mysql"

systemctl enable mysqld &>>$logs_file
systemctl start mysqld
validate $? "enable and start mysql"

mysql_secure_installation --set-root-pass RoboShop@1 &>>$logs_file
validate $? "setting root user password"

print_total_time
