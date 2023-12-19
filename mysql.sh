#!/bin/bash

ID=$(id -u)
R="\e[31m"
G="\e[32m"
Y="\e[33m"
N="\e[0m"

TIMESTAMP=$(date +%F-%H-%M-%S)
LOGFILE="/tmp/$0-$TIMESTAMP.log"

echo "script stareted executing at $TIMESTAMP" &>> $LOGFILE

VALIDATE(){
    if [ $1 -ne 0 ]
    then
        echo -e "$2 ...$R FAILED $N"
        exit 1
    else
        echo -e "$2 ...$G SUCCESS $N"
    fi

}

if [ $ID -ne 0 ]
then
    echo -e "$R ERROR: Please run this script with root acess $N"
    exit 1 # you can give other than 0
else
    echo "you are root user"
fi # fi means reverse of if, indicating condition end

dnf module disable mysql -y &>> $LOGFILE

VAILDATE $? "Disable current MYSQL version"

cp mysql.repo /etc/yum.repos.d/mysql.repo &>> $LOGFILE

VAILDATE $? "Copied MYSQL repo"

dnf install mysql-community-server -y &>> $LOGFILE

VAILDATE $? "Installing  MYSQL server"

systemctl enable mysqld &>> $LOGFILE

VAILDATE $? "Enabling  MYSQL server"

systemctl start mysqld &>> $LOGFILE

VAILDATE $? "starting  MYSQL server"

mysql_secure_installation --set-root-pass RoboShop@1 &>> $LOGFILE

VAILDATE $? "Setting  MYSQL root password"











