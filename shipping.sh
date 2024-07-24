script=$(realpath "$0")
script_path=$(dirname "$script")
source ${script_path}/common.sh
mysql_root_password=$1
echo -e "\e[36m>>>>>>>>>>Install Maven
dnf install maven -y
echo -e "\e[36m>>>>>>>>>>Add Application User
useradd ${app_user}
echo -e "\e[36m>>>>>>>>>>Create App Directory
rm -rf /app
mkdir /app
echo -e "\e[36m>>>>>>>>>>Download App Content
curl -L -o /tmp/shipping.zip https://roboshop-artifacts.s3.amazonaws.com/shipping.zip
echo -e "\e[36m>>>>>>>>>>Unzip the Content
cd /app
unzip /tmp/shipping.zip
echo -e "\e[36m>>>>>>>>>>Clean Maven Package
mvn clean package
mv target/shipping-1.0.jar shipping.jar
echo -e "\e[36m>>>>>>>>>>Copying Systemd Service file
cp ${script_path}/shipping.service /etc/systemd/system/shipping.service
echo -e "\e[36m>>>>>>>>>> Install Mysql
dnf install mysql -y
mysql -h mysql-dev.vdevops72.online -uroot -p${mysql_root_password} < /app/schema/shipping.sql

echo -e "\e[36m>>>>>>>>>>Start Shipping Service
systemctl daemon-reload
systemctl enable shipping
systemctl restart shipping