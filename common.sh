#!bin/bash


userid=$(id -u)
logs_folder="/var/log/shell-script"
logs_file="$logs_folder/$0.log"
R="\e[31m"
G="\e[32m"
Y="\e[33m"
N="\e[0m"

mkdir -p $logs_folder

echo "$(date "+%Y-%m-%d %H:%M:%S") | Script started executing at: $(date)" | tee -a $logs_file #to print date &time stamp


check_rootuser(){  #to check root user access
    if [ $userid -ne 0 ]; then
        echo -e "$R please run the script with root user access $N" |tee -a $logs_file
        exit 1
   fi
}


validate(){ #to check previous command and proceed with next step
    if [ $1 -ne 0 ]; then 
      echo -e "$(date "+%Y-%m-%d %H:%M:%S")| $2 is.......$R failed $N" |tee -a $logs_file 
      exit 1
    else
      echo -e "$(date "+%Y-%m-%d %H:%M:%S")| $2 is......$G success $N" |tee -a $logs_file
    fi
}

print_total_time(){
    END_TIME=$(date +%s)
    TOTAL_TIME=$(( $END_TIME - $START_TIME ))
    echo -e "$(date "+%Y-%m-%d %H:%M:%S") | Script execute in: $G $TOTAL_TIME seconds $N" | tee -a $logs_file
}