script=$(realpath "$0")
script_path=$(dirname "$script")
source ${script_path}/common.sh
print_head "Copying Mongo repo file "
cp mongo.repo /etc/yum.repos.d/mongo.repo &>>$log_file
status_check_func $?
print_head "Install MongoDB  "
dnf install mongodb-org -y &>>$log_file
status_check_func $?
print_head "Update MongoDB listen Address "
sed -i -e 's|127.0.0.1|0.0.0.0|' /etc/mongod.conf &>>$log_file
status_check_func $?

print_head "Start the Mongo DB Services"
systemctl enable mongod &>>$log_file
systemctl restart mongod &>>$log_file

status_check_func $?

