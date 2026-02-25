#!bin/bash


source ./common.sh #calling common script
check_rootuser  #root user function
appname="user"  #define app as vairable and calling in script
nodejs_setup    #nodejs function 
system_roboshopuser #system user check
app_setup           #creating directory and downloading code function
service_file        #copying user file function
systemctl_services  #creating systemctl services function
print_total_time   #to know total time take to execute script


npm install &>>$logs_file
validate $? "installing dependencies"

systemctl restart user
validate $? "restart user"