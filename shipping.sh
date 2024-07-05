echo -e "\e[36m>>>>>>>>>>Install Maven>>>>>>>>>>\e[0m "
dnf install maven -y
echo -e "\e[36m>>>>>>>>>>Add Application User>>>>>>>>>>\e[0m "
useradd roboshop
echo -e "\e[36m>>>>>>>>>>Create App Directory>>>>>>>>>>\e[0m "
rm -rf /app
mkdir /app
echo -e "\e[36m>>>>>>>>>>Download App Content>>>>>>>>>>\e[0m "
curl -L -o /tmp/shipping.zip https://roboshop-artifacts.s3.amazonaws.com/shipping.zip
echo -e "\e[36m>>>>>>>>>>Unzip the Content>>>>>>>>>>\e[0m "
cd /app
unzip /tmp/shipping.zip
echo -e "\e[36m>>>>>>>>>>Clean Maven Package>>>>>>>>>>\e[0m "
mvn clean package
mv target/shipping-1.0.jar shipping.jar
echo -e "\e[36m>>>>>>>>>>Copying Systemd Service file>>>>>>>>>>\e[0m "
cp yes
shipping.service /etc/systemd/system/shipping.service

echo -e "\e[36m>>>>>>>>>> Install Mysql>>>>>>>>>>\e[0m "
dnf install mysql -y
mysql -h mysql-dev.vdevops72.online -uroot -pRoboShop@1 < /app/schema/shipping.sql

echo -e "\e[36m>>>>>>>>>>Start Shipping Service>>>>>>>>>>\e[0m "
systemctl daemon-reload
systemctl enable shipping
systemctl restart shipping