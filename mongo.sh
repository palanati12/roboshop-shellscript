#!/bin/bash

ID=$(id -u)
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

cp mongolink  /etc/yum.repos.d/mongolink &>> $LOGFILE

dnf install mongodb-org -y 

VALIDATE $? "installing mongodb"

systemctl enable mongod &>> $LOGFILE

VALIDATE $? "enabling mongodb"

systemctl start mongod

VALIDATE $? "started mongodb"

sed -i 's/127.0.0.1/0.0.0.0/' /etc/mongod.conf &>> $LOGFILE

VALIDATE $? "started processing the config"

systemctl restart mongod &>> $LOGFILE

VALIDATE $? "Restarting mongodb"

