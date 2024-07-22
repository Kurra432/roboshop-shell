app_user=roboshop


func_nodejs() {

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
  curl -L -o /tmp/cart.zip https://roboshop-artifacts.s3.amazonaws.com/${component}.zip
  cd /app
  echo -e "\e[36m>>>>>>>>>>Unzip the Content >>>>>>>>>>\e[0m "
  unzip /tmp/${component}.zip
  echo -e "\e[36m>>>>>>>>>>Install Nodejs Dependecies>>>>>>>>>>\e[0m "
  npm install
  echo -e "\e[36m>>>>>>>>>Copying Systemd Service file>>>>>>>>>>\e[0m "
  cp ${script_path}/${component}.service /etc/systemd/system/${component}.service
  echo -e "\e[36m>>>>>>>>> Start Cart service>>>>>>>>>>\e[0m "
  systemctl daemon-reload
  systemctl enable ${component}
  systemctl rstart ${component}


}


func_python() {
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
}