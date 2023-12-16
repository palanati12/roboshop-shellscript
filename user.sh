#!/bin/bash


D=$(id -u)
R="\e[31m"
G="\e[32m"
Y="\e[33m"
N="\e[0m"

MONGO_HOST=mongodb.praveenapp.online

TIMESTAMP=$(date +%F-%H-%M-%S)

LOGFILE="/tmp/$0-$TIMESTAMP.log"

VALIDATE(){
if [ $1 -ne 0 ]
then 
    echo -e "ERROR:: $2 ....$R is failed $N"
else
    echo -e "$2 ....$G is success $N" 
fi           
}

if [ $ID -ne 0 ]
then
    echo -e "$R ERROR::please run the script with root access $N"
    exit 1
else
    echo -e "$G You are the root user $N"  
fi

dnf module disable nodejs -y &>> $LOGFILE

VALIDATE $? "diabling nodejs"

dnf module enable nodejs:18 -y &>> $LOGFILE

VALIDATE $? "enabling nodejs"

dnf install nodejs -y  &>> $LOGFILE

VALIDATE $? "installing nodejs"

d roboshop
if [ $? -ne 0 ]
then 
    adduser roboshop
    VALIDATE $? "roboshop user creation"
 else
     echo -e "user already exists $Y skipping $N"
fi

mkdir -p /app &>> $LOGFILE

curl -L -o /tmp/user.zip https://roboshop-builds.s3.amazonaws.com/user.zip  &>> $LOGFILE

cd /app 

unzip -o /tmp/user.zip

cd /app 

npm install &>> $LOGFILE

VALIDATE $? "installing the dependncies"

cp /home/centos/roboshop-shellscript/user.service  /etc/systemd/system/user.service

systemctl daemon-reload &>> $LOGFILE

VALIDATE $? "for te daemon reload to use"

systemctl enable user 

VALIDATE $? "to enable the user"

systemctl start user

VALIDATE $? "starting the user"

cp /home/centos/roboshop-shellscript/mylink.repo   /etc/yum.repos.d/mongo.repo/mylink.repo

dnf install mongodb-org-shell -y &>> $LOGFILE

VALIDATE $? "installing the mongoclient"

mongo --host $MONGO_HOST </app/schema/user.js

VALIDATE $? "loading the data"





