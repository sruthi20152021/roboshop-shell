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

dnf module disable nodejs -y &>> $LOGFILE

VAILDATE $? "Disabling current nodeJS:18" 

dnf module enable nodejs:18 -y &>> $LOGFILE

VAILDATE $? "Enabling nodeJS:18" 

dnf install nodejs -y &>> $LOGFILE

VALIDATE $? "Installing NodeJS:18" 

useradd roboshop &>> $LOGFILE

VALIDATE $? "Creating roboshop user"

mkdir /app &>> $LOGFILE

VALIDATE $? "Creating app directory" 

curl -o /tmp/catalogue.zip https://roboshop-builds.s3.amazonaws.com/catalogue.zip

VALIDATE $? "Downloading catalogue application" 

cd /app &>> $LOGFILE


unzip /tmp/catalogue.zip &>> $LOGFILE

VALIDATE $? "unzipping catalogue" 

npm install &>> $LOGFILE

VAILDATE $? "Installing dependices" 

# use absolute, because catalogue.service exists there
cp /home/centos/roboshop-shell/catalogue.service /etc/systemd/system/catalogue.service

VALIDATE $? "Copying catalogue service file"

systemctl daemon-reload &>> $LOGFILE

VAILDATE $? "Catalogue daemon reload" 

systemctl enable catalogue &>> $LOGFILE

VALIDATE $? "Enable catalogue"

systemctl start catalogue &>> $LOGFILE

VALIDATE $? "Starting catalogue"

cp /home/centos/roboshop-shell/mongo.repo /etc/yum.repos.d/mongo.repo

VALIDATE $? "copying mongodb repo"

dnf install mongodb-org-shell -y &>> $LOGFILE

VALIDATE $? "Installing MongoDB client"

mongo --host $MONGODB_HOST </app/schema/catalogue.js &>> $LOGFILE

VALIDATE $? "Loading catalogue data into MongoDB"





















