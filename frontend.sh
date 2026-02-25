#!/bin/bash

source ./common.sh
check_rootuser
nginx_setup


rm -rf /usr/share/nginx/html/* &>>$logs_file
validate $? "remove default content "

curl -o /tmp/frontend.zip https://roboshop-artifacts.s3.amazonaws.com/frontend-v3.zip
validate $? "download frontend code"

curl -o /tmp/frontend.zip https://roboshop-artifacts.s3.amazonaws.com/frontend-v3.zip
validate $? "download the frontend code"

cd /usr/share/nginx/html 
validate $? "moving to nginx html folder"

unzip /tmp/frontend.zip &>>$logs_file
validate $? "unzipping the frontend code"

rm -rf /etc/nginx/nginx.conf #remove default content of service if script runs again

cp $script_dir/nginx.conf /etc/nginx/nginx.conf
validate $? "creating nginx configuration file"

systemctl restart nginx &>>$logs_file
validate $? "restarting nginx"
