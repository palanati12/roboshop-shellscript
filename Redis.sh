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

if [ $ID -ne 0 ]:
then
    echo -e "$R ERROR::please run the script with root access $N"
    exit 1
else
    echo -e "$G You are the root user $N"  
fi

dnf install https://rpms.remirepo.net/enterprise/remi-release-8.rpm -y &>> $LOGFILE

VALIDATE $? "installing remi-release"

dnf module enable redis:remi-6.2 -y &>> $LOGFILE

VALIDATE $? "enabling the 6.2 version"

dnf install redis -y  &>> $LOGFILE

VALIDATE $? "installing the redis"

sed -i 's/127.0.0.1/0.0.0.0/g'  /etc/redis/redis.conf  &>> $LOGFILE

VALIDATE  $? "validating the file"

systemctl enable redis   &>> $LOGFILE

VALIDATE $? "enabling  the redis"

systemctl start redis   &>> $LOGFILE

VALIDATE $? "starting  the redis"


 