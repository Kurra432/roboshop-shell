app_user=roboshop
script=$(realpath "$0")
script_path=$(dirname "$script")
log_file=/tmp/roboshop.log
#rm -f log_file

print_head() {
  echo -e "\e[35m>>>>>>>>>>>>>>>$1<<<<<<<<<\e[0m"
  echo -e "\e[35m>>>>>>>>>>>>>>>$1<<<<<<<<<\e[0m" &>>$log_file
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
   cp ${script_path}/mongo.repo /etc/yum.repos.d/mongo.repo &>>$log_file
   status_check_func $?
  print_head "Install Mongodb client"
   dnf install mongodb-org-shell -y &>>$log_file
   status_check_func $?
   print_head " Update the MongoDB address"
   mongo --host mongodb-dev.vdevops72.online </app/schema/${component}.js &>>$log_file
   status_check_func $?
   fi

   if [ "$schema_setup" == "mysql" ]; then
     print_head "InstallMysql"
        dnf install mysql -y &>>$log_file
        status_check_func $?
        print_head " Cpnfiguring Mysql"
        mysql -h mysql-dev.vdevops72.online -uroot -p${mysql_root_password} < /app/schema/${component}.sql &>>$log_file
       status_check_func $?
        fi

}

app_prereq_func() {
  print_head "Add Application user"
     useradd ${app_user} &>>$log_file
     status_check_func $?
    print_head "Creating Application directory"
    rm -rf /app &>>$log_file
     mkdir /app &>>$log_file
     status_check_func $?
    print_head "Downloading Application Content"
     curl -L -o /tmp/${component}.zip https://roboshop-artifacts.s3.amazonaws.com/${component}.zip &>>$log_file
     status_check_func $?
   print_head "Unzip the Content"
     cd /app
     unzip /tmp/${component}.zip &>>$log_file
     status_check_func $?
}

systemd_setup_func() {
  print_head "Setup the SystemD service file"
    cp ${script_path}/${component}.service /etc/systemd/system/${component}.service &>>$log_file
    status_check_func $?
    print_head " Start the ${component}Service"
    systemctl daemon-reload &>>$log_file
    systemctl enable ${component} &>>$log_file
    systemctl restart ${component} &>>$log_file
    status_check_func $?
}
nodejs_func() {
print_head "Install NodeJs"
dnf module disable nodejs -y &>>$log_file
dnf module enable nodejs:18 -y &>>$log_file
dnf install nodejs -y &>>$log_file
status_check_func $?

app_prereq_func

print_head "Downloading Dependecies"
 npm install &>>$log_file
status_check_func $?
schema_setup_func
 systemd_setup_func

 }

 java_func() {
  print_head "Install Maven"
   dnf install maven -y &>>$log_file

status_check_func $?
   app_prereq_func

print_head "Download the dependencies"
   mvn clean package &>>$log_file

   status_check_func $?
   mv target/${component}-1.0.jar ${component}.jar

schema_setup_func
  systemd_setup_func
 }
