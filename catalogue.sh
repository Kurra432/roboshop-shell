script=$(realpath "$0")
script_path=$(dirname "$script")
source ${script_path}/common.sh

component=catalogue

func_nodejs

echo -e "\e[36m>>>>>>>>>>Copying Mongodb repo file>>>>>>>>>>\e[0m "
cp ${script_path}/mongo.repo /etc/yum.repos.d/mongo.repo
echo -e "\e[36m>>>>>>>>>>Install Mongodb>>>>>>>>>>\e[0m "

dnf install mongodb-org-shell -y
echo -e "\e[36m>>>>>>>>>>Setup Mongodb>>>>>>>>>>\e[0m "

mongo --host mongodb-dev.vdevops72.online </app/schema/catalogue.js
