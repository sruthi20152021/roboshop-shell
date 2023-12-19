#!/bin/bash

ID=$(id -u)
R="\e[31m"
G="\e[32m"
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

curl -s https://packagecloud.io/install/repositories/rabbitmq/erlang/script.rpm.sh | bash &>> $LOGFILE

VAILDATE $? "Downloading erlang script"

curl -s https://packagecloud.io/install/repositories/rabbitmq/rabbitmq-server/script.rpm.sh | bash &>> $LOGFILE

VAILDATE $? "Downloading rabbitmq script"

dnf install rabbitmq-server -y &>> $LOGFILE

VAILDATE $? "Installing rabbitmq server"

systemctl enable rabbitmq-server &>> $LOGFILE

VAILDATE $? "Enbaling rabbitmq server"

systemctl start rabbitmq-server &>> $LOGFILE

VAILDATE $? "Starting rabbitmq server"

rabbitmqctl add_user roboshop roboshop123 &>> $LOGFILE

VAILDATE $? "Creating user"

rabbitmqctl set_permissions -p / roboshop ".*" ".*" ".*" &>> $LOGFILE

VAILDATE $? "Setting permission"