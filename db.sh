#!/bin/bash


source ./common.sh

check_root

echo "please enter db password:"
read mysql_root_password


dnf install mysql-server -y &>>$logfile
validate $? "installing mysql server"

systemctl enable mysqld &>>$logfile
validate $? "enabling mysql server"

systemctl start mysqld &>>logfile
validate $? "starting my sql server"

# mysql_secure_installation --set-root-pass ExpenseApp@1 &>>logfile
# validate $? "settingup root password"

# Idempotent nature
 mysql -h db.jasdevops.cloud -uroot -p${mysql_root_password} -e 'show datbases;' &>>logfile
 if [ $? -ne 0 ]
 then
    mysql_secure_installation --set-root-pass ${mysql_root_password} &>>logfile
validate $? "mysql root passwod setup"
else
    echo -e "mysql root password is already setup...$Y SKIPPING $N"
fi
