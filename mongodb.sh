script=$(realpath "$0")
script_path=$(dirname "$script")
source ${script_path}/common.sh

cp ${script_path}/mongo.repo /etc/yum.repos.d/mongo.repo
echo -e "\e[36m>>>>>>>>>>>>>>>Install Mongo <<<<<<<<<\e[0m"
dnf install mongodb-org -y
echo -e "\e[36m>>>>>>>>>>>>>>>Edit the IP <<<<<<<<<\e[0m"
sed -i -e 's|127.0.0.1|0.0.0.0|' /etc/mongod.conf

echo -e "\e[36m>>>>>>>>>>>>>>>Start the Mongo DB<<<<<<<<<\e[0m"
systemctl enable mongod
systemctl restart mongod

