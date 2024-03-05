script=$(realpath "$0")
script_path=$(dirname "$script")
source ${script_path}/common.sh
rabbitmq_user_password=$1

if [ -z "$rabbitmq_user_password" ]; then

   echo Rabbitmq User Password  missing
exit
   fi

print_head "Configure YUM Repos from the script provided by vendor"
curl -s https://packagecloud.io/install/repositories/rabbitmq/erlang/script.rpm.sh | bash &>>$log_file
status_check_func $?

print_head " Configure YUM Repos for RabbitMQ"
curl -s https://packagecloud.io/install/repositories/rabbitmq/rabbitmq-server/script.rpm.sh | bash &>>$log_file
status_check_func $?

print_head "Install RabbitMQ"
dnf install rabbitmq-server -y &>>$log_file
status_check_func $?
 print_head "Adding app user and passwd forRabbitMQ Service"
 rabbitmqctl add_user roboshop ${rabbitmq_user_password} &>>$log_file
rabbitmqctl set_permissions -p / roboshop ".*" ".*" ".*" &>>$log_file
status_check_func $?

print_head "Start RabbitMQ Service"
systemctl enable rabbitmq-server &>>$log_file
systemctl restart rabbitmq-server &>>$log_file
status_check_func $?