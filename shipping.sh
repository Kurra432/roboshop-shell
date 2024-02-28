script=$(realpath "$0")
script_path=$(dirname "$script")
source ${script_path}/common.sh
echo -e "\e[36m>>>>>>>>>>>>>>>Install Maven<<<<<<<<<\e[0m"
dnf install maven -y
echo -e "\e[36m>>>>>>>>>>>>>>>Add Application user<<<<<<<<<\e[0m"
useradd ${app_user}
echo -e "\e[36m>>>>>>>>>>>>>>>Creating Application directory<<<<<<<<<\e[0m"
mkdir /app
echo -e "\e[36m>>>>>>>>>>>>>>>Downloading App Content<<<<<<<<<\e[0m"
curl -L -o /tmp/shipping.zip https://roboshop-artifacts.s3.amazonaws.com/shipping.zip
echo -e "\e[36m>>>>>>>>>>>>>>>Unzip the Content<<<<<<<<<\e[0m"
cd /app
unzip /tmp/shipping.zip
echo -e "\e[36m>>>>>>>>>>>>>>>Download the dependencies<<<<<<<<<\e[0m"
mvn clean package
mv target/shipping-1.0.jar shipping.jar
echo -e "\e[36m>>>>>>>>>>>>>>>Setup the SystemD service file<<<<<<<<<\e[0m"
cp ${script_path}/shipping.service /etc/systemd/system/shipping.service
echo -e "\e[36m>>>>>>>>>>>>>>>Load the Schema<<<<<<<<<\e[0m"
systemctl daemon-reload
echo -e "\e[36m>>>>>>>>>>>>>>>InstallMysql<<<<<<<<<\e[0m"
dnf install mysql -y
echo -e "\e[36m>>>>>>>>>>>>>>> Cpnfiguring Mysql<<<<<<<<<\e[0m"
mysql -h mysql-dev.vdevops72.online -uroot -pRoboShop@1 < /app/schema/shipping.sql

echo -e "\e[36m>>>>>>>>>>>>>>>Start the Shipping Service<<<<<<<<<\e[0m"
systemctl enable shipping
systemctl restart shipping