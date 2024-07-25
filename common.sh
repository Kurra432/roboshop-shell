app_user=roboshop

print_head() {

  echo -e "\e[35m>>>>>>>>>>$1<<<<<<<<<<<<<<\e[0m"

}
func_schema_setup() {

  if [ "$schema_setup" == "moongo" ]; then

  print_head "Copying Mongodb repo file"
  cp ${script_path}/mongo.repo /etc/yum.repos.d/mongo.repo
  print_head "Install Mongodb"

  dnf install mongodb-org-shell -y
  print_head "Setup Mongodb"

  mongo --host mongodb-dev.vdevops72.online </app/schema/catalogue.js

 fi
}




func_nodejs() {

 print_head "Configuring Nodejs"
  dnf module disable nodejs -y
  dnf module enable nodejs:18 -y
  print_head "Install Nodejs"
  dnf install nodejs -y
 print_head "Add Application user"
  useradd ${app_user}
  print_head "Creating App directory"
  rm -rf /app
  mkdir /app
  print_head "Download APP content"
  curl -L -o /tmp/{component}.zip https://roboshop-artifacts.s3.amazonaws.com/${component}.zip
  cd /app
  print_head "Unzip the Content"
  unzip /tmp/${component}.zip
  print_head "Install Nodejs Dependecies"
  npm install
  print_head "Copying Systemd Service file"
  cp ${script_path}/${component}.service /etc/systemd/system/${component}.service
  print_head "Start Cart service"
  systemctl daemon-reload
  systemctl enable ${component}
  systemctl rstart ${component}

func_schema_setup

}


func_python() {
  print_head "Install Python"
    dnf install python36 gcc python3-devel -y
  print_head "Add Application user"
  useradd roboshop
  print_head "Add App Directory"
  rm -rf /app
  mkdir /app
  print_head "Unzip the content"
  curl -L -o /tmp/{component}.zip https://roboshop-artifacts.s3.amazonaws.com/${component}.zip
  cd /app
  unzip /tmp/${component}.zip
  print_head "Download the Dependecies"
  pip3.6 install -r requirements.txt
 print_head "Copying Systemd Service file"
  sed -i -e 's|rabbitmq_app_password|${rabbitmq_app_password}|' ${script_path}/${component}.service
  cp ${script_path}/${component}.service /etc/systemd/system/${component}.service

 print_head "Start Payment Service"
  systemctl daemon-reload
  systemctl enable ${component}
  systemctl restart ${component}
}