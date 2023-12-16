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

dnf install nginx -y &>> $LOGFILE

VALIDATE $? "installing nginx"

systemctl enable nginx  &>> $LOGFILE

VALIDATE $? "enabling nginx"

systemctl start nginx  &>> $LOGFILE

VALIDATE $? "starting nginx"

rm -rf /usr/share/nginx/html/* &>> $LOGFILE

VALIDATE $? "removing the default html file"

curl -o /tmp/web.zip https://roboshop-builds.s3.amazonaws.com/web.zip

cd /usr/share/nginx/html

unzip -o /tmp/web.zip

cp /home/centos/roboshop-shellscript/roboshop.config  /etc/nginx/default.d/roboshop.config &>> $LOGFILE 

systemctl restart nginx &>> $LOGFILE

VALIDATE $? "restarted nginx"