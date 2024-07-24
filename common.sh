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
  curl -L -o /tmp/{component}.zip https://roboshop-artifacts.s3.amazonaws.com/${component}.zip
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
  echo -e "\e[36m>>>>>>>>>>> Install Python<<<<<<<<<<<<<<<<\e[0m"
    dnf install python36 gcc python3-devel -y
  echo -e "\e[36m>>>>>>>>>>> Add Application user<<<<<<<<<<<<<<<<\e[0m"
  useradd roboshop
  echo -e "\e[36m>>>>>>>>>>>>Add App Directory <<<<<<<<<<<<<<<<\e[0m"
  rm -rf /app
  mkdir /app
  echo -e "\e[36m>>>>>>>>>>>>Unzip the content <<<<<<<<<<<<<<<<\e[0m"
  curl -L -o /tmp/{component}.zip https://roboshop-artifacts.s3.amazonaws.com/${component}.zip
  cd /app
  unzip /tmp/${component}.zip
  echo -e "\e[36m>>>>>>>>>>>>Download the Dependecies <<<<<<<<<<<<<<<<\e[0m"
  pip3.6 install -r requirements.txt
  echo -e "\e[36m>>>>>>>>>>Copying Systemd Service file>>>>>>>>>>\e[0m "
  sed -i -e 's|rabbitmq_app_password|${rabbitmq_app_password}|' ${script_path}/${component}.service
  cp ${script_path}/${component}.service /etc/systemd/system/${component}.service

  echo -e "\e[36m>>>>>>>>>>>>Start Payment Service>>>>>>>>>>>>>\e[0m"
  systemctl daemon-reload
  systemctl enable ${component}
  systemctl restart ${component}
}