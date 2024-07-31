script=$(realpath "$0")
script_path=$(dirname "$script")
source ${script_path}/common.sh
log_file=/tmp/roboshop.log

print_head  "Copying SystemD service"
cp ${script_path}/mongo.repo /etc/yum.repos.d/mongo.repo &>>log_file
func_status_check $?

print_head  "Install MongoDb"
dnf install mongodb-org -y &>>log_file
 func_status_check $?

print_head  "Modify the MongoDblisten Adress"
sed -i -e 's|127.0.0.1| 0.0.0.0|' /etc/mongod.conf &>>log_file
func_status_check $?

print_head  "Start mongodb"
systemctl enable mongod &>>log_file
systemctl restart mongod &>>log_file
func_status_check $?