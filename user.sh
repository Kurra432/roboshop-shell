script=$(realpath "$0")
script_path=$(dirname "$script")
source ${script_path}/common.sh
echo -e "\e[36m>>>>>>>>>>Configuring Nodejsrepo>>>>>>>>>>\e[0m "
dnf module disable nodejs -y
dnf module enable nodejs:18 -y
echo -e "\e[36m>>>>>>>>>>Install Nodejs>>>>>>>>>>\e[0m "
dnf install nodejs -y
echo -e "\e[36m>>>>>>>>>>Add Application User>>>>>>>>>>\e[0m "
useradd $app_user
echo -e "\e[36m>>>>>>>>>>Create App directory>>>>>>>>>>\e[0m "
rm -rf /app
mkdir /app
echo -e "\e[36m>>>>>>>>>>Download App content>>>>>>>>>>\e[0m "
curl -L -o /tmp/user.zip https://roboshop-artifacts.s3.amazonaws.com/user.zip
cd /app
echo -e "\e[36m>>>>>>>>>>Unzip the content>>>>>>>>>>\e[0m "
unzip /tmp/user.zip
echo -e "\e[36m>>>>>>>>>>Download Dependices>>>>>>>>>>\e[0m "
npm install
echo -e "\e[36m>>>>>>>>>>Copying SystemD service file>>>>>>>>>>\e[0m "
cp ${script_path}/user.service /etc/systemd/system/user.service

echo -e "\e[36m>>>>>>>>>>Start User Service>>>>>>>>>>\e[0m "
systemctl daemon-reload
systemctl enable user
systemctl restart user

echo -e "\e[36m>>>>>>>>>>Copying Mongodb repo file>>>>>>>>>>\e[0m "
cp ${script_path}/mongo.repo /etc/yum.repos.d/mongo.repo
echo -e "\e[36m>>>>>>>>>>Install Mongodb>>>>>>>>>>\e[0m "

dnf install mongodb-org-shell -y
echo -e "\e[36m>>>>>>>>>>Setup Mongodb>>>>>>>>>>\e[0m "

mongo --host mongodb-dev.vdevops72.online </app/schema/user.js