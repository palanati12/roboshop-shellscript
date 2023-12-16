#!/bin/bash

ID=$(id -u)
R="\e[31m"
G="\e[32m"
Y="\e[33m"
N="\e[0m"

MONGO_HOST =mongodb.praveenapp.online

TIMESTAMP=$(date +%F-%H-%M-%S)

LOGFILE="/tmp/$0-$TIMESTAMP.log"

echo "script stareted executing at $TIMESTAMP" &>> $LOGFILE

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

VALIDATE $? "disabling node js"

dnf module enable nodejs:18 -y &>> $LOGFILE

VALIDATE $? "enabling nodejs 18"

dnf install nodejs -y  &>> $LOGFILE

VALIDATE  $? "installing nodejs"

id roboshop
if ( $? -ne 0)
then 
    useradd roboshop
    VALIDATE $? "roboshop user creation"
else
    echo -e "id creation already exists $Y skipping $N"

useradd roboshop &>> $LOGFILE

VALIDATE  $? "validating the id"

mkdir -p /app  &>> $LOGFILE

curl -o /tmp/catalogue.zip https://roboshop-builds.s3.amazonaws.com/catalogue.zip

cd /app   &>> $LOGFILE

unzip  -o /tmp/catalogue.zip

cd /app

npm install 

cp /home/centos/roboshop-shellscript/catalogue.service  /etc/systemd/system/catalogue.service &>> $LOGFILE

VALIDATE  $? "coping the catalogue service data"

systemctl daemon-reload

VALIDATE  $? "validating the dameon reload"

systemctl enable catalogue  &>> $LOGFILE

VALIDATE $? " enable the catalogue service"

systemctl start catalogue  &>> $LOGFILE

VALIDATE $? "starting the cataloge service"

cp /home/centos/robosop-shellscript/mylink.repo   /etc/yum.repos.d/mylink.repo   &>> $LOGFILE

VALIDATE $?  " coping the mongodata repo to catalgue"

dnf install mongodb-org-shell -y   &>> $LOGFILE

VALIDATE $? " installing the mongo-db client"

mongo --host $MONGO_HOST </app/schema/catalogue.js