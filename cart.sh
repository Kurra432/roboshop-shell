echo -e "\e[36m>>>>>>>>>>>>>>>Install Nodejs<<<<<<<<<\e[0m"
dnf module disable nodejs -y
dnf module enable nodejs:18 -y
dnf install nodejs -y
echo -e "\e[36m>>>>>>>>>>>>>>>Add application User<<<<<<<<<\e[0m"
useradd roboshop
echo -e "\e[36m>>>>>>>>>>>>>>>Creating App Directory<<<<<<<<<\e[0m"
mkdir /app
echo -e "\e[36m>>>>>>>>>>>>>>>Download the App Content<<<<<<<<<\e[0m"
curl -L -o /tmp/cart.zip https://roboshop-artifacts.s3.amazonaws.com/cart.zip
echo -e "\e[36m>>>>>>>>>>>>>>>Changing to App Directory<<<<<<<<<\e[0m"
cd /app
echo -e "\e[36m>>>>>>>>>>>>>>>Unzip the App content<<<<<<<<<\e[0m"
unzip /tmp/cart.zip
echo -e "\e[36m>>>>>>>>>>>>>>>Download Dependices<<<<<<<<<\e[0m"
npm install
echo -e "\e[36m>>>>>>>>>>>>>>>Setup the SystemD service file/<<<<<<<<<\e[0m"
cp /home/centos/roboshop-shell/cart.service /etc/systemd/system/cart.service
echo -e "\e[36m>>>>>>>>>>>>>>>Load the Schema<<<<<<<<<\e[0m"
systemctl daemon-reload
echo -e "\e[36m>>>>>>>>>>>>>>>Start the cart Service<<<<<<<<<\e[0m"
systemctl enable cart
systemctl restart cart

