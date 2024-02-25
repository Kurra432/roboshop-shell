echo -e "\e[36>>>>>>>>>>>>Setup the repo file<<<<<<<<<<<<<\e[0m"
cp mongo.repo /etc/yum.repos.d/mongo.repo
echo -e "\e[36>>>>>>>>>>>>Install MongoDB<<<<<<<<<<<<<\e[0m"
dnf install mongodb-org -y
echo -e "\e[36>>>>>>>>>>>>Start MongoDB <<<<<<<<<<<<<\e[0m"
sed -e -i 's|127.0.0.1|0.0.0.0|' /etc/mongod.conf
echo -e "\e[36>>>>>>>>>>>>Start MongoDB <<<<<<<<<<<<<\e[0m"
systemctl enable mongod
systemctl restart mongod

