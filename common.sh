app_user=roboshop

print_head() {
  echo -e "\e[35m>>>>>>>>>>>>>>>$1<<<<<<<<<\e[0m"
}



schema_setup_func() {
  if [ "$schema_setup" == "mongo" ]; then

 print_head"Copying Mongodb repo file"
   cp ${script_path}/mongo.repo /etc/yum.repos.d/mongo.repo
  print_head "Install Mongodb client"
   dnf install mongodb-org-shell -y
   print_head " Update the MongoDB address"
   mongo --host mongodb-dev.vdevops72.online </app/schema/${component}.js
   fi

   if [ "$schema_setup" == "mysql" ]; then
     print_head "InstallMysql"
        dnf install mysql -y
        print_head " Cpnfiguring Mysql"
        mysql -h mysql-dev.vdevops72.online -uroot -p${mysql_root_password} < /app/schema/${component}.sql

        fi

}

app_prereq_func() {
  print_head "Add Application user"
     useradd ${app_user}
    print_head "Creating Application directory"
    rm -rf /app
     mkdir /app
    print_head "Downloading Application Content"
     curl -L -o /tmp/${component}.zip https://roboshop-artifacts.s3.amazonaws.com/${component}.zip
   print_head "Unzip the Content"
     cd /app
     unzip /tmp/${component}.zip
}

systemd_setup_func() {
  print_head "Setup the SystemD service file"
    cp ${script_path}/${component}.service /etc/systemd/system/${component}.service
    print_head " Start the ${component}Service"
    systemctl daemon-reload
    systemctl enable ${component}
    systemctl restart ${component}
}
nodejs_func() {
print_head "Install NodeJs"
dnf module disable nodejs -y
dnf module enable nodejs:18 -y
dnf install nodejs -y

app_prereq_func

print_head "Downloading Dependecies"
 npm install

schema_setup_func
 systemd_setup_func

 }

 java_func() {
  print_head "Install Maven<<<<<<<<<"
   dnf install maven -y

   app_prereq_func

print_head "Download the dependencies"
   mvn clean package
   mv target/${component}-1.0.jar ${component}.jar

schema_setup_func
  systemd_setup_func
 }
