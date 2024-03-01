app_user=roboshop

print_head() {
  echo -e "\e[35m>>>>>>>>>>>>>>>$1<<<<<<<<<\e[0m"
}



schema_setup() {
  if [ "$schema_setup" == "mongo" ]; then

 print_head"Copying Mongodb repo file"
   cp ${script_path}/mongo.repo /etc/yum.repos.d/mongo.repo
  print_head "Install Mongodb client"
   dnf install mongodb-org-shell -y
   print_head " Update the MongoDB address"
   mongo --host mongodb-dev.vdevops72.online </app/schema/${component}.js
   fi
}

nodejs_func() {
print_head "Install NodeJs"
dnf module disable nodejs -y
dnf module enable nodejs:18 -y
dnf install nodejs -y
print_head "Add Application user"
useradd ${app_user}
print_head "Creating App Directory"
rm -f /app
mkdir /app
print_head"Downloading App Content"
curl -o /tmp/${component}.zip https://roboshop-artifacts.s3.amazonaws.com/${component}.zip
print_head "Unzip the content<<<<<<<<<"
cd /app
unzip /tmp/${component}.zip
print_head "Downloading Dependecies"
 npm install
 print_head "Setup the Systemd service file"
 cp ${script_path}/${component}.service /etc/systemd/system/${component}.service
 print_head "Load the service file"
 systemctl daemon-reload
print_head "Start cart service"
 systemctl enable ${component}
 systemctl restart ${component}

 schema_setup

 }