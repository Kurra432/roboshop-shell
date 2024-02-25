echo -e "\e[36m>>>>>>>>>>>>>>>Install Nodejs<<<<<<<<<\e[0m"
dnf module disable nodejs -y
dnf module enable nodejs:18 -y
dnf install nodejs -y
echo -e "\e[36m>>>>>>>>>>>>>>>Add Application User<<<<<<<<<\e[0m"
useradd roboshop
echo -e "\e[36m>>>>>>>>>>>>>>>Creating App Directory<<<<<<<<<\e[0m"
mkdir /app
echo -e "\e[36m>>>>>>>>>>>>>>>Downloading App Content<<<<<<<<<\e[0m"
curl -L -o /tmp/user.zip https://roboshop-artifacts.s3.amazonaws.com/user.zip
echo -e "\e[36m>>>>>>>>>>>>>>>Unzip Content<<<<<<<<<\e[0m"
cd /app
unzip /tmp/user.zip
echo -e "\e[36m>>>>>>>>>>>>>>>Downloading Dependices <<<<<<<<<\e[0m"
npm install
echo -e "\e[36m>>>>>>>>>>>>>>>Setup the SystemD service<<<<<<<<<\e[0m"
cp /home/centos/roboshop-shell/user.service /etc/systemd/system/user.service
echo -e "\e[36m>>>>>>>>>>>>>>>Load the service<<<<<<<<<\e[0m"
systemctl daemon-reload
echo -e "\e[36m>>>>>>>>>>>>>>>Start the User service<<<<<<<<<\e[0m"
