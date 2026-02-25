#!/bin/bash

source ./common.sh
check_rootuser
appname=shipping
java_setup
system_roboshopuser
app_setup
service_file
systemctl_services
MYSQL_HOST=mysql.jarugula.online

dnf install mysql -y &>>$logs_file
validate $? "installing mysql"

mysql -h $MYSQL_HOST -uroot -pRoboShop@1 -e 'use cities'
if [ $? -ne 0 ]; then

    mysql -h $MYSQL_HOST -uroot -pRoboShop@1 < /app/db/schema.sql &>>$logs_file
    mysql -h $MYSQL_HOST -uroot -pRoboShop@1 < /app/db/app-user.sql &>>$logs_file
    mysql -h $MYSQL_HOST -uroot -pRoboShop@1 < /app/db/master-data.sql &>>$logs_file
    VALIDATE $? "Loaded data into MySQL"
else
    echo -e "data is already loaded ... $Y SKIPPING $N"
fi

systemctl restart "shipping"
validate $? "restarting shipping"

print_total_time