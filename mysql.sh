#!/bin/bash

source ./common.sh #calling common script
check_rootuser

dnf install mysql-server -y
validate $? "installing mysql"

systemctl enable mysqld
systemctl start mysqld
validate $? "enable and start mysql"

mysql_secure_installation --set-root-pass RoboShop@1
validate $? "setting root user password"
