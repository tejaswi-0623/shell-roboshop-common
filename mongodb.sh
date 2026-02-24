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


#sudo sh mongodb.sh
#2026-02-24 22:35:25 | Script started executing at: Tue Feb 24 22:35:25 UTC 2026
#2026-02-24 22:35:25| copying mongo repo is...... success
#MongoDB Repository                                                                                                             17 kB/s | 1.3 kB     00:00
#Package mongodb-org-7.0.30-1.el9.x86_64 is already installed.
#Dependencies resolved.
#Nothing to do.
#Complete!
#2026-02-24 22:35:32| installing mongodb is...... success
#2026-02-24 22:35:32| enable and start mongodb is...... success
#2026-02-24 22:35:32| allow remote connections is...... success
#2026-02-24 22:35:33| restart mongodb is...... success
#2026-02-24 22:35:33 | Script execute in:  8 seconds
#above is the output we got with exact time and date stamp and also we got total time taken to execute the script
