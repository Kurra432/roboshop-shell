app_user=roboshop

print_head() {
  echo -e "\e[35m>>>>>>>>>>>>>>>$1<<<<<<<<<\e[0m"
}

status_check_func() {
  if [ $1 -eq  0 ]; then

          echo -e "\e[32mSuccess\e[0m"

          else
            echo -e "\e[31mFailure\e[0m"
            echo "Refer the log file  /tmp/roboshop.log for more information"
      exit 1
     fi
}

schema_setup_func() {
  if [ "$schema_setup" == "mongo" ]; then

 print_head"Copying Mongodb repo file"
   cp ${script_path}/mongo.repo /etc/yum.repos.d/mongo.repo
   status_check_func $?
  print_head "Install Mongodb client"
   dnf install mongodb-org-shell -y
   status_check_func $?
   print_head " Update the MongoDB address"
   mongo --host mongodb-dev.vdevops72.online </app/schema/${component}.js
   status_check_func $?
   fi

   if [ "$schema_setup" == "mysql" ]; then
     print_head "InstallMysql"
        dnf install mysql -y
        status_check_func $?
        print_head " Cpnfiguring Mysql"
        mysql -h mysql-dev.vdevops72.online -uroot -p${mysql_root_password} < /app/schema/${component}.sql
       status_check_func $?
        fi

}

app_prereq_func() {
  print_head "Add Application user"
     useradd ${app_user} &>/tmp/roboshop.log
     status_check_func $?
    print_head "Creating Application directory"
    rm -rf /app
     mkdir /app
     status_check_func $?
    print_head "Downloading Application Content"
     curl -L -o /tmp/${component}.zip https://roboshop-artifacts.s3.amazonaws.com/${component}.zip
     status_check_func $?
   print_head "Unzip the Content"
     cd /app
     unzip /tmp/${component}.zip
     status_check_func $?
}

systemd_setup_func() {
  print_head "Setup the SystemD service file"
    cp ${script_path}/${component}.service /etc/systemd/system/${component}.service
    status_check_func $?
    print_head " Start the ${component}Service"
    systemctl daemon-reload
    systemctl enable ${component}
    systemctl restart ${component}
    status_check_func $?
}
nodejs_func() {
print_head "Install NodeJs"
dnf module disable nodejs -y
dnf module enable nodejs:18 -y
dnf install nodejs -y
status_check_func $?

app_prereq_func

print_head "Downloading Dependecies"
 npm install
status_check_func $?
schema_setup_func
 systemd_setup_func

 }

 java_func() {
  print_head "Install Maven"
   dnf install maven -y >/tmp/roboshop.log

status_check_func $?
   app_prereq_func

print_head "Download the dependencies"
   mvn clean package

   status_check_func $?
   mv target/${component}-1.0.jar ${component}.jar

schema_setup_func
  systemd_setup_func
 }
