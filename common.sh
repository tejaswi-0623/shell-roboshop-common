#!bin/bash


userid=$(id -u)
logs_folder="/var/log/shell-script"
logs_file="$logs_folder/$0.log"
R="\e[31m"
G="\e[32m"
Y="\e[33m"
N="\e[0m"
START_TIME=$(date +%s)
script_dir=$PWD


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

nodejs_setup(){ #writting function for coomon commands for nodejs in backend script
    dnf module disable nodejs -y &>>$logs_file
    validate $? "disabling nodejs default version"

    dnf module enable nodejs:20 -y &>>$logs_file
    validate $? "enable nodejs 20 version"

    dnf install nodejs -y &>>$logs_file
    validate $? "intsalling nodejs"

    npm install &>>$logs_file
    validate $? "installing dependencies"
}

system_roboshopuser(){
    id roboshop &>>$logs_file #creating system user 
     if [$? -ne 0 ]; then
       useradd --system --home /app --shell /sbin/nologin --comment "roboshop system user" roboshop
       validate $? "creating roboshop user"
    else 
       echo -e "roboshop user already exists...$Y skipping $N"
    fi
}

app_setup(){ #creating app folder, downloading the code
    mkdir -p /app &>>$logs_file
    validate $? "creating app directory"

    curl -o /tmp/$appname.zip https://roboshop-artifacts.s3.amazonaws.com/$appname-v3.zip 
    validate $? "download the app code"

    rm -rf /app/*
    VALIDATE $? "Removing existing code" 

    cd /app
    validate $? "moving to app directory"

    unzip /tmp/$appname.zip &>>$logs_file
    validate $? "unzipping the app code"

}


service_file(){
    cp $script_dir/$appname.service /etc/systemd/system/$appname.service
    validate $? "configure system file"
}
 
 systemctl_services(){
     systemctl daemon-reload &>>$logs_file
     validate $? "reload the service"

     systemctl enable $appname &>>$logs_file
     systemctl start $appname
     validate $? "enable and start the $appname"

     systemctl restart $appname &>>$logs_file
     validate $? "restarting the $appname"
 }

print_total_time(){
    END_TIME=$(date +%s)
    TOTAL_TIME=$(( $END_TIME - $START_TIME ))
    echo -e "$(date "+%Y-%m-%d %H:%M:%S") | Script execute in: $G $TOTAL_TIME seconds $N" | tee -a $logs_file 
}