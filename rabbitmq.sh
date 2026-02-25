#!/bin/bash

source ./common.sh
check_rootuser

cp $script_dir/rabbtimq.repo /etc/yum.repos.d/rabbitmq.repo
validate $? "copying rabbitmq repo"

dnf install rabbitmq-server -y &>>$logs_file
validate $? "installing rabbitmq"

systemctl enable rabbitmq &>>$logs_file
systemctl start rabbitmq
validate $? "enable and start rabbitmq"

rabbitmqctl add_user roboshop roboshop123
rabbitmqctl set_permissions -p / roboshop ".*" ".*" ".*"
validate $? "adding user and setting permissions"

print_total_time