#!/bin/bash

#implementing backend using shell script

source ./common.sh

check_root

echo "enter DB password:"
read -s db_root_password

dnf module disable nodejs -y &>>LOGFILE
VALIDATE $? "disabling nodejs"

dnf module enable nodejs:20 -y &>>LOGFILE
VALIDATE $? "enabling nodejs"

dnf install nodejs -y &>>LOGFILE
VALIDATE $? "installing nodejs"

id expense &>>LOGFILE
if [ $? -ne 0 ]
then 
    useradd expense  &>>LOGFILE
    VALIDATE $? "creating expenses user"
else
    echo -e "user already exists...$Y SKIPPING $N"

fi

mkdir -p /app
VALIDATE $? "creating app directory"

curl -o /tmp/backend.zip https://expense-builds.s3.us-east-1.amazonaws.com/expense-backend-v2.zip &>>LOGFILE
VALIDATE $? "downloading backend code"

cd /app
rm -rf /app/*
unzip /tmp/backend.zip &>>LOGFILE
VALIDATE $? "unzipping the backend code"

npm install &>>LOGFILE
VALIDATE $? "installing dependencies"

cp /home/ec2-user/expenses-shell-1/backend.service /etc/systemd/system/backend.service &>>LOGFILE
VALIDATE $? "copied backend service"

systemctl daemon-reload &>>LOGFILE
VALIDATE $? "validate deamon reload"

systemctl start backend &>>LOGFILE
VALIDATE $? "start backend service"

systemctl enable backend &>>LOGFILE
VALIDATE $? "enabling backend service"

dnf install mysql -y &>>LOGFILE
VALIDATE $? "installing mysql client"

mysql -h db.vishruth.online -uroot -p${db_root_password} < /app/schema/backend.sql &>>LOGFILE
VALIDATE $? "validate schema loading"

systemctl restart backend &>>LOGFILE
VALIDATE $? "restating backend"


