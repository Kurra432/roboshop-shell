script=$(realpath "$0")
script_path=$(dirname "$script")
source ${script_path}/common.sh
rabbitmq_app_password=$1

if [ -z "$rabbitmq_app_password" ]; then
  echo Input Missing
  exit
  fi
echo -e "\e[36m>>>>>>>>>>> Install Python<<<<<<<<<<<<<<<<\e[0m"
  dnf install python36 gcc python3-devel -y
echo -e "\e[36m>>>>>>>>>>> Install Python<<<<<<<<<<<<<<<<\e[0m"
useradd roboshop
echo -e "\e[36m>>>>>>>>>>>>Add App Directory <<<<<<<<<<<<<<<<\e[0m"
rm -rf /app
mkdir /app
echo -e "\e[36m>>>>>>>>>>>>Unzip the content <<<<<<<<<<<<<<<<\e[0m"
curl -L -o /tmp/payment.zip https://roboshop-artifacts.s3.amazonaws.com/payment.zip
cd /app
unzip /tmp/payment.zip
echo -e "\e[36m>>>>>>>>>>>>Download the Dependecies <<<<<<<<<<<<<<<<\e[0m"
pip3.6 install -r requirements.txt
echo -e "\e[36m>>>>>>>>>>Copying Systemd Service file>>>>>>>>>>\e[0m "
sed -i -e 's|rabbitmq_app_password|${rabbitmq_app_password}|' ${script_path}/payment.service
cp ${script_path}/payment.service /etc/systemd/system/payment.service

echo -e "\e[36m>>>>>>>>>>>>Start Payment Service>>>>>>>>>>>>>\e[0m"
systemctl daemon-reload
systemctl enable payment
systemctl restart payment




