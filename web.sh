#!/bin/bash

ID=$(id -u)
R="\e[31m"
G="\e[32m"
N="\e[0m"
MONGODB_HOST=mongodb.hanvika.online

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

dnf install nginx -y &>> $LOGFILE

VALIDATE $? "Installing Nginx"

systemctl enable nginx &>> $LOGFILE

VAILDATE $? "Enabling Nginx"

systemctl start nginx &>> $LOGFILE

VAILDATE $? "Starting Nginx"

rm -rf /usr/share/nginx/html/* &>> $LOGFILE

VAILDATE $? "removed default website"

curl -o /tmp/web.zip https://roboshop-builds.s3.amazonaws.com/web.zip &>> $LOGFILE

VAILDATE $? "Downloaded web application"

cd /usr/share/nginx/html &>> $LOGFILE

VAILDATE $? "moving nginx html directory"

unzip -o /tmp/web.zip &>> $LOGFILE

VAILDATE $? "unzipping web"

cp /home/centos/roboshop-shell/roboshop.conf /etc/nginx/default.d/roboshop.conf &>> $LOGFILE

VAILDATE $? "copied roboshop reverse proxy config"

systemctl restart nginx &>> $LOGFILE

VAILDATE $? "restarted nginx"




