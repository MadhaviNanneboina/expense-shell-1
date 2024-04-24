#!/bin/bash

#implementing mysql DB using shell script
source ./common.sh

check_root
echo "please enter DB password:"
read -s db_root_password

dnf install mysql-server -y &>>$LOGFILE
VALIDATE $? "installing mysql"

systemctl enable mysqld &>>$LOGFILE
VALIDATE $? "enabling mysql"

systemctl start mysqld &>>$LOGFILE
VALIDATE $? "starting mysql"

#shell is not idempotency by default if we exicute this script it will faile
# mysql_secure_installation --set-root-pass ExpenseApp@1 &>>$LOGFILE
# VALIDATE $? "setting up password"

# implementing idempotency
mysql -h db.vishruth.online -uroot -p${db_root_password} -e 'show databases;' &>>$LOGFILE
if [ $? -ne 0 ]
then
mysql_secure_installation --set-root-pass ${db_root_password} &>>$LOGFILE
VALIDATE $? "settingup root password"
else
echo -e "root password already setup...$Y skipping $N"
fi

