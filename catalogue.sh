script=$(realpath "$0")
script_path=$(dirname "$script")
source ${script_path}/common.sh
echo -e "\e[36m>>>>>>>>>>>>>>>Install Nodejs<<<<<<<<<\e[0m"
dnf module disable nodejs -y
dnf module enable nodejs:18 -y
dnf install nodejs -y
echo -e "\e[36m>>>>>>>>>>>>>>>Add Application user<<<<<<<<<\e[0m"
useradd ${app_user}
echo -e "\e[36m>>>>>>>>>>>>>>>Creating App Directory<<<<<<<<<\e[0m"
rm -f /app
mkdir /app
echo -e "\e[36m>>>>>>>>>>>>>>>Downloading App Content<<<<<<<<<\e[0m"
curl -o /tmp/catalogue.zip https://roboshop-artifacts.s3.amazonaws.com/catalogue.zip
echo -e "\e[36m>>>>>>>>>>>>>>>Unzip the content<<<<<<<<<\e[0m"
cd /app
unzip /tmp/catalogue.zip
echo -e "\e[36m>>>>>>>>>>>>>>>Downloading Dependecies<<<<<<<<<\e[0m"
 npm install
 echo -e "\e[36m>>>>>>>>>>>>>>>Setup the Systemd service file<<<<<<<<<\e[0m"
 cp ${script_path}/catalogue.service /etc/systemd/system/catalogue.service
 echo -e "\e[36m>>>>>>>>>>>>>>>Load the service file<<<<<<<<<\e[0m"
 systemctl daemon-reload
 echo -e "\e[36m>>>>>>>>>>>>>>>Copying Mongodb repo file<<<<<<<<<\e[0m"
 cp ${script_path}/mongo.repo /etc/yum.repos.d/mongo.repo
 echo -e "\e[36m>>>>>>>>>>>>>>>Install Mongodb client<<<<<<<<<\e[0m"
 dnf install mongodb-org-shell -y
 echo -e "\e[36m>>>>>>>>>>>>>>> Update the MongoDB address<<<<<<<<<\e[0m"
 mongo --host mongodb-dev.vdevops72.online </app/schema/catalogue.js
echo -e "\e[36m>>>>>>>>>>>>>>>Start Catalogue service <<<<<<<<<\e[0m"
systemctl enable catalogue
systemctl restart catalogue
