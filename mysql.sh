dnf module disable mysql -y
cp msql.repo /etc/yum.repos.d/mysql.repo
dnf install mysql-community-server -y
mysql_secure_installation --set-root-pass RoboShop@1
mysql -uroot -pRoboShop@1
systemctl enable mysqld
systemctl restart mysqld