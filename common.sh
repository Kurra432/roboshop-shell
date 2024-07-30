app_user=roboshop

print_head() {

  echo -e "\e[35m>>>>>>>>>>$1<<<<<<<<<<<<<<\e[0m"

}

func_status_check(){

  if [ "$1" -eq 0 ]; then
       echo -e "\e[32m>>>>>>>>>SUCCESS<<<<<<<<<\e[0m"
       else
         echo -e "\e[31m>>>>>>>>>FAIlURE<<<<<<<<<\e[0m"
         exit
         fi

}

func_schema_setup() {

  if [ "$schema_setup" == "mongo" ]; then

  print_head "Copying Mongodb repo file"
  cp ${script_path}/mongo.repo /etc/yum.repos.d/mongo.repo
  func_status_check $?
  print_head "Install Mongodb"

  dnf install mongodb-org-shell -y
  func_status_check $?
  print_head "Setup Mongodb"

  mongo --host mongodb-dev.vdevops72.online </app/schema/${component}.js
func_status_check $?
 fi


if [ "$schema_setup" == "mysql" ]; then

   print_head " Install Mysql Client"
     dnf install mysql -y
     func_status_check $?
     print_head "load Schema"
     mysql -h mysql-dev.vdevops72.online -uroot -p${mysql_root_password} < /app/schema/shipping.sql
     func_status_check $?

fi

}

func_apprequsites() {
  print_head "Add Application user"
    useradd ${app_user}
    func_status_check $?
    print_head "Creating App directory"
    rm -rf /app
    mkdir /app
    func_status_check $?
    print_head "Download APP content"
    curl -L -o /tmp/{component}.zip https://roboshop-artifacts.s3.amazonaws.com/${component}.zip
    cd /app
    func_status_check $?
    print_head "Unzip the Content"
    unzip /tmp/${component}.zip
    func_status_check $?


}

func_systemdsetup() {

  print_head "Copying Systemd Service file"
    cp ${script_path}/${component}.service /etc/systemd/system/${component}.service
    func_status_check $?

    print_head "Start ${component} service"
    systemctl daemon-reload
    systemctl enable ${component}
    systemctl rstart ${component}
    func_status_check $?
}

func_nodejs() {

 print_head "Configuring Nodejs"
  dnf module disable nodejs -y
  dnf module enable nodejs:18 -y
  func_status_check $?
  print_head "Install Nodejs"
  dnf install nodejs -y
  func_status_check $?
func_apprequsites
  print_head "Install Nodejs Dependecies"
  npm install
  func_status_check $?
func_schema_setup
func_systemdsetup
}


func_java() {
 print_head "Install Maven"
   dnf install maven -y
   func_status_check $?
func_apprequsites
   print_head "Clean Maven Package"
   mvn clean package
   func_status_check $?
   mv target/${component}-1.0.jar ${component}.jar
  func_systemdsetup
}


func_python() {
  print_head "Install Python"
    dnf install python36 gcc python3-devel -y
    func_status_check $?
  func_apprequsites
  print_head "Download the Dependecies"
  pip3.6 install -r requirements.txt
  func_status_check $?
 print_head " Updating password in Systemd Service file"
  sed -i -e 's|rabbitmq_app_password|${rabbitmq_app_password}|' ${script_path}/${component}.service
func_status_check $?
  func_systemdsetup
}