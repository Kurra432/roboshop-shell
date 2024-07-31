app_user=roboshop
log_file=/tmp/roboshop.log
#rm -rf log_file

print_head() {

  echo -e "\e[35m>>>>>>>>>>$1<<<<<<<<<<<<<<\e[0m"
  echo -e "\e[35m>>>>>>>>>>$1<<<<<<<<<<<<<<\e[0m" &>>log_file
}

func_status_check(){

  if [ "$1" -eq 0 ]; then
       echo -e "\e[32m>>>>>>>>>SUCCESS<<<<<<<<<\e[0m"
       else
         echo -e "\e[31m>>>>>>>>>FAIlURE<<<<<<<<<\e[0m"
         echo Refer the log file for more information /tmp/roboshop.log
         exit 1

         fi

}

func_schema_setup() {

  if [ "$schema_setup" == "mongo" ]; then

  print_head "Copying Mongodb repo file"
  cp ${script_path}/mongo.repo /etc/yum.repos.d/mongo.repo &>>log_file
  func_status_check $?
  print_head "Install Mongodb"

  dnf install mongodb-org-shell -y &>>log_file
  func_status_check $?
  print_head "Setup Mongodb"

  mongo --host mongodb-dev.vdevops72.online </app/schema/${component}.js &>>log_file
func_status_check $?
 fi


if [ "$schema_setup" == "mysql" ]; then

   print_head " Install Mysql Client"
     dnf install mysql -y &>>log_file
     func_status_check $?
     print_head "load Schema"
     mysql -h mysql-dev.vdevops72.online -uroot -p${mysql_root_password} < /app/schema/shipping.sql &>>log_file
     func_status_check $?

fi

}

func_apprequsites() {
  print_head "Add Application user"
  id ${app_user} &>>log_file
  if [ $? -ne 0 ]; then
    useradd ${app_user} &>>log_file
    fi
    func_status_check $?
    print_head "Creating App directory"
    rm -rf /app
    mkdir /app &>>log_file
    func_status_check $?
    print_head "Download APP content"
    curl -L -o /tmp/{component}.zip https://roboshop-artifacts.s3.amazonaws.com/${component}.zip &>>log_file
    cd /app
    func_status_check $?
    print_head "Unzip the Content"
    unzip /tmp/${component}.zip &>>log_file
    func_status_check $?


}

func_systemd_setup() {
    print_head "Setup SystemD Service"
     cp ${script_path}/${component}.service /etc/systemd/system/${component}.service &>>$log_file
     func_status_check $?

     print_head "Start ${component} Service"
     systemctl daemon-reload &>>$log_file
     systemctl enable ${component} &>>$log_file
     systemctl restart ${component} &>>$log_file
     func_status_check $?
  }

func_nodejs() {

 print_head "Configuring Nodejs"
  dnf module disable nodejs -y &>>log_file
  dnf module enable nodejs:18 -y &>>log_file
  func_status_check $?
  print_head "Install Nodejs"
  dnf install nodejs -y &>>log_file
  func_status_check $?
func_apprequsites
  print_head "Install Nodejs Dependecies"
  npm install &>>log_file
  func_status_check $?
func_schema_setup
func_systemd_setup
}


func_java() {
 print_head "Install Maven"
   dnf install maven -y &>>log_file
   func_status_check $?
func_apprequsites
   print_head "Clean Maven Package"
   mvn clean package &>>log_file
   func_status_check $?
   mv target/${component}-1.0.jar ${component}.jar &>>log_file
  func_systemd_setup
}


func_python() {
  print_head "Install Python"
    dnf install python36 gcc python3-devel -y &>>log_file
    func_status_check $?
  func_apprequsites
  print_head "Download the Dependecies"
  pip3.6 install -r requirements.txt &>>log_file
  func_status_check $?
 print_head " Updating password in Systemd Service file"
  sed -i -e 's|rabbitmq_app_password|${rabbitmq_app_password}|' ${script_path}/${component}.service &>>log_file
func_status_check $?
  func_systemd_setup
}