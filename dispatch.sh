script=$(realpath "$0")
script_path=$(dirname "$script")
source ${script_path}/common.sh
echo -e "\e[36m>>>>>>>>>>Install Golang>>>>>>>>>>\e[0m "
dnf install golang -y
echo -e "\e[36m>>>>>>>>>>Add Application user>>>>>>>>>>\e[0m "
useradd ${app_user}
echo -e "\e[36m>>>>>>>>>>Add App Directory>>>>>>>>>>\e[0m "
rm -rf /app
mkdir /app
echo -e "\e[36m>>>>>>>>>> Download App Content>>>>>>>>>>\e[0m "
curl -L -o /tmp/dispatch.zip https://roboshop-artifacts.s3.amazonaws.com/dispatch.zip
cd /app
echo -e "\e[36m>>>>>>>>>> Unzip the Content>>>>>>>>>>\e[0m "
unzip /tmp/dispatch.zip
echo -e "\e[36m>>>>>>>>>> Setup the Golang>>>>>>>>>>\e[0m "
go mod init dispatch
go get
go build
echo -e "\e[36m>>>>>>>>>>Copying SystemD service file>>>>>>>>>>\e[0m "
cp ${script_path}/dispatch.service /etc/systemd/system/dispatch.service
echo -e "\e[36m>>>>>>>>>>Start Dispatch Service>>>>>>>>>>\e[0m "
systemctl daemon-reload
systemctl enable dispatch
systemctl restart dispatch