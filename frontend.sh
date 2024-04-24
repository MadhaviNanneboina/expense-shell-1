#!/bin/bash

#implementing frontend using shell script
source ./common.sh
check_root

echo "Please enter DB password:"
read mysql_root_password
    
dnf install nginx -y &>>$LOGFILE
VALIDATE $? "installing nginx"

systemctl enable nginx &>>$LOGFILE
VALIDATE $? "enabling nginx"

systemctl start nginx &>>$LOGFILE
VALIDATE $? "starting nginx"

rm -rf /usr/share/nginx/html/*  &>>$LOGFILE
VALIDATE $? "removing existing content"

curl -o /tmp/frontend.zip https://expense-builds.s3.us-east-1.amazonaws.com/expense-frontend-v2.zip &>>$LOGFILE
VALIDATE $? "downloading frontend code"

cd /usr/share/nginx/html &>>$LOGFILE
unzip /tmp/frontend.zip &>>$LOGFILE
VALIDATE $? "extracting frontend code"

cp /home/ec2-user/expense-shell-1/expense.conf /etc/nginx/default.d/expense.conf &>>$LOGFILE
VALIDATE $? "copied expense conf"

systemctl restart nginx &>>$LOGFILE
VALIDATE $? "restarting nginx"
