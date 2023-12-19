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

dnf install maven -y

id roboshop # if roboshop user does not exist, then it is failure
if [ $? -ne 0 ]
then
    useradd roboshop
    VALIDATE $? "roboshop user creation"
else
    echo -e "roboshop user already exist $Y SKIPPING $N"
fi

mkdir  -p /app  

VALIDATE $? "Creating app directory"

curl -L -o /tmp/shipping.zip https://roboshop-builds.s3.amazonaws.com/shipping.zip

VAILDATE $? "Downloading shipping"

cd /app

VAILDATE $? "moving to app directory"

unzip  -o /tmp/shipping.zip

VAILDATE $? "unzipping shipping"

mvn clean package

VAILDATE $? "Installing dependencies"

mv target/shipping-1.0.jar shipping.jar

VAILDATE $? "renaming jar file"

cp /home/centos/roboshop-shell/shipping.service /etc/systemd/system/shipping.service

VAILDATE $? "copying shipping service"

systemctl daemon-reload

VAILDATE $? "daemon reload"

systemctl enable shipping 

VAILDATE $? "enable shipping"

systemctl start shipping

Validate $? "start shipping"

dnf install mysql -y

VAILDATE $? "Installing MYSQL client"

mysql -h mysql.hanvika.online -uroot -pRoboShop@1 < /app/schema/shipping.sql 

VAILDATE $? "loading shipping data"

systemctl restart shipping

VAILDATE $? "restart shipping"











