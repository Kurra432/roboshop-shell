script_path=$(dirname $0)
source ${script_path}/common.sh

 exit
echo -e "\e[36m>>>>>>>>>>>>>>>Install Nodejs<<<<<<<<<\e[0m"
dnf module disable nodejs -y
dnf module enable nodejs:18 -y
dnf install nodejs -y
echo -e "\e[36m>>>>>>>>>>>>>>>Add Application user<<<<<<<<<\e[0m"
useradd $ {app_user}
echo -e "\e[36m>>>>>>>>>>>>>>>Creating App Directory<<<<<<<<<\e[0m"
rm -f /app
mkdir /app
echo -e "\e[36m>>>>>>>>>>>>>>>Downloading App Content<<<<<<<<<\e[0m"
curl -o /tmp/user.zip https://roboshop-artifacts.s3.amazonaws.com/user.zip
echo -e "\e[36m>>>>>>>>>>>>>>>Unzip the content<<<<<<<<<\e[0m"
cd /app
unzip /tmp/user.zip
echo -e "\e[36m>>>>>>>>>>>>>>>Downloading Dependecies<<<<<<<<<\e[0m"
 npm install
 echo -e "\e[36m>>>>>>>>>>>>>>>Setup the Systemd service file<<<<<<<<<\e[0m"
 cp /home/centos/roboshop-shell/user.service /etc/systemd/system/user.service
 echo -e "\e[36m>>>>>>>>>>>>>>>Load the service file<<<<<<<<<\e[0m"
 systemctl daemon-reload
 echo -e "\e[36m>>>>>>>>>>>>>>>Copying Mongodb repo file<<<<<<<<<\e[0m"
 cp /home/centos/roboshop-shell/mongo.repo /etc/yum.repos.d/mongo.repo
 echo -e "\e[36m>>>>>>>>>>>>>>>Install Mongodb client<<<<<<<<<\e[0m"
 dnf install mongodb-org-shell -y
 echo -e "\e[36m>>>>>>>>>>>>>>> Update the MongoDB address<<<<<<<<<\e[0m"
 mongo --host mongodb-dev.vdevops72.online </app/schema/user.js
echo -e "\e[36m>>>>>>>>>>>>>>>Start Catalogue service <<<<<<<<<\e[0m"
systemctl enable user
systemctl restart user
