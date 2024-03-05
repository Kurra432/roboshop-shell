script=$(realpath "$0")
script_path=$(dirname "$script")
source ${script_path}/common.sh
print_head "Setup the Redis repo File"
dnf install https://rpms.remirepo.net/enterprise/remi-release-8.rpm -y &>>$log_file
status_check_func $?
print_head "Enable the Redis  Service"
dnf module enable redis:remi-6.2 -y &>>$log_file
status_check_func $?
print_head "Install Redis"
dnf install redis -y &>>$log_file
status_check_func $?
print_head "Update the  Redis listen address"

sed -i -e 's|127.0.0.1|0.0.0.0|' /etc/redis.conf /etc/redis/redis.conf &>>$log_file
status_check_func $?

print_head "Start the Redis service"
systemctl enable redis &>>$log_file
systemctl restart redis &>>$log_file
status_check_func $?



