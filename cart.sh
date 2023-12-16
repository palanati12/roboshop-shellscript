#!/bin/bash

D=$(id -u)
R="\e[31m"
G="\e[32m"
Y="\e[33m"
N="\e[0m"

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

VALIDATE $? "disabling nodejs"

dnf module enable nodejs:18 -y &>> $LOGFILE

VALIDATE $? "enabling nodejs"

dnf install nodejs -y &>> $LOGFILE

VALIDATE $? "installing nodejs"

id roboshop
if [ $? -ne 0 ]
then 
    adduser roboshop
    VALIDATE $? "roboshop user creation"
 else
     echo -e "user already exists $Y skipping $N"
fi

mkdir -p /app &>> $LOGFILE

curl -L -o /tmp/cart.zip https://roboshop-builds.s3.amazonaws.com/cart.zip  &>> $LOGFILE

cd /app 

unzip -o /tmp/cart.zip

cd /app 

npm install &>> $LOGFILE

VALIDATE $? "installing the dependies"

cp /home/centos/roboshop-shellscript/cart.service  /etc/systemd/system/cart.service

VALIDATE $? "coping the cart file"

systemctl daemon-reload &>> $LOGFILE

systemctl enable cart 

VALIDATE $? "enabling  the cart"

systemctl start cart

VALIDATE $? "start the cart"
       