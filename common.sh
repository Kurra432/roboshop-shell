app_user=roboshop

nodejs_func() {
echo -e "\e[36m>>>>>>>>>>>>>>> Install NodeJs<<<<<<<<<\e[0m"
dnf module disable nodejs -y
dnf module enable nodejs:18 -y
dnf install nodejs -y
echo -e "\e[36m>>>>>>>>>>>>>>>Add Application user<<<<<<<<<\e[0m"
useradd ${app_user}
echo -e "\e[36m>>>>>>>>>>>>>>>Creating App Directory<<<<<<<<<\e[0m"
rm -f /app
mkdir /app
echo -e "\e[36m>>>>>>>>>>>>>>>Downloading App Content<<<<<<<<<\e[0m"
curl -o /tmp/${component}.zip https://roboshop-artifacts.s3.amazonaws.com/${component}.zip
echo -e "\e[36m>>>>>>>>>>>>>>>Unzip the content<<<<<<<<<\e[0m"
cd /app
unzip /tmp/${component}.zip
echo -e "\e[36m>>>>>>>>>>>>>>>Downloading Dependecies<<<<<<<<<\e[0m"
 npm install
 echo -e "\e[36m>>>>>>>>>>>>>>>Setup the Systemd service file<<<<<<<<<\e[0m"
 cp ${script_path}/${component}.service /etc/systemd/system/${component}.service
 echo -e "\e[36m>>>>>>>>>>>>>>>Load the service file<<<<<<<<<\e[0m"
 systemctl daemon-reload
 echo -e "\e[36m>>>>>>>>>>>>>>>Start cart service <<<<<<<<<\e[0m"
 systemctl enable ${component}
 systemctl restart ${component}

 }