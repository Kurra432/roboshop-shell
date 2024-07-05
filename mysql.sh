echo -e "\e[36m>>>>>>>>>>Configuring Mysql repo>>>>>>>>>>\e[0m "
dnf module disable mysql -y
cp /home/centos/roboshop-shell/msql.repo /etc/yum.repos.d/mysql.repo
echo -e "\e[36m>>>>>>>>>>Install Mysql >>>>>>>>>>\e[0m "
dnf install mysql-community-server -y

echo -e "\e[36m>>>>>>>>>>Start Mysql>>>>>>>>>>\e[0m "
systemctl enable mysqld
systemctl restart mysqld

echo -e "\e[36m>>>>>>>>>>Load Schema>>>>>>>>>>\e[0m "
mysql_secure_installation --set-root-pass RoboShop@1

