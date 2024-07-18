script=$(realpath "$0")
script_path=$(dirname "$script")
source ${script_path}/common.sh
echo -e "\e[36m>>>>>>>>>>Configuring Nodejs>>>>>>>>>>\e[0m "
dnf module disable nodejs -y
dnf module enable nodejs:18 -y
echo -e "\e[36m>>>>>>>>>>Install Nodejs>>>>>>>>>>\e[0m "
dnf install nodejs -y
echo -e "\e[36m>>>>>>>>>>Add Application user >>>>>>>>>>\e[0m "
useradd ${app_user}
echo -e "\e[36m>>>>>>>>>>Creating App directory>>>>>>>>>>\e[0m "
rm -rf /app
mkdir /app
echo -e "\e[36m>>>>>>>>>>Download APP content>>>>>>>>>>\e[0m "
curl -L -o /tmp/cart.zip https://roboshop-artifacts.s3.amazonaws.com/cart.zip
cd /app
echo -e "\e[36m>>>>>>>>>>Unzip the Content >>>>>>>>>>\e[0m "
unzip /tmp/cart.zip
echo -e "\e[36m>>>>>>>>>>Install Nodejs Dependecies>>>>>>>>>>\e[0m "
npm install
echo -e "\e[36m>>>>>>>>>Copying Systemd Service file>>>>>>>>>>\e[0m "
cp ${script_path}/cart.service /etc/systemd/system/cart.service
echo -e "\e[36m>>>>>>>>> Start Cart service>>>>>>>>>>\e[0m "
systemctl daemon-reload
systemctl enable cart
systemctl rstart cart