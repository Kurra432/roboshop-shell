source common.sh
dnf module disable nodejs -y
dnf module enable nodejs:18 -y
dnf install nodejs -y
echo -e "\e[36m>>>>>>>>>>>>>>>Add Application user<<<<<<<<<\e[0m"
useradd ${app_user}
echo -e "\e[36m>>>>>>>>>>>>>>>Creating App Directory<<<<<<<<<\e[0m"
rm -f /app
mkdir /app
echo -e "\e[36m>>>>>>>>>>>>>>>Downloading App Content<<<<<<<<<\e[0m"
curl -o /tmp/cart.zip https://roboshop-artifacts.s3.amazonaws.com/cart.zip
echo -e "\e[36m>>>>>>>>>>>>>>>Unzip the content<<<<<<<<<\e[0m"
cd /app
unzip /tmp/user.zip
echo -e "\e[36m>>>>>>>>>>>>>>>Downloading Dependecies<<<<<<<<<\e[0m"
 npm install
 echo -e "\e[36m>>>>>>>>>>>>>>>Setup the Systemd service file<<<<<<<<<\e[0m"
 cp /home/centos/roboshop-shell/cart.service /etc/systemd/system/cart.service
 echo -e "\e[36m>>>>>>>>>>>>>>>Load the service file<<<<<<<<<\e[0m"
 systemctl daemon-reload
 echo -e "\e[36m>>>>>>>>>>>>>>>Start cart service <<<<<<<<<\e[0m"
 systemctl enable cart
 systemctl restart cart

