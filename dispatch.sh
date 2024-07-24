script=$(realpath "$0")
script_path=$(dirname "$script")
source ${script_path}/common.sh


Install Golang
dnf install golang -y
Add Application user
useradd ${app_user}
Add App Directory
rm -rf /app
mkdir /app
 Download App Content
curl -L -o /tmp/dispatch.zip https://roboshop-artifacts.s3.amazonaws.com/dispatch.zip
cd /app
 Unzip the Content
unzip /tmp/dispatch.zip
 Setup the Golang
go mod init dispatch
go get
go build
Copying SystemD service file
cp ${script_path}/dispatch.service /etc/systemd/system/dispatch.service
Start Dispatch Service
systemctl daemon-reload
systemctl enable dispatch
systemctl restart dispatch