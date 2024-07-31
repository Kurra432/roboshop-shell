script=$(realpath "$0")
script_path=$(dirname "$script")
source ${script_path}/common.sh
log_file=/tmp/roboshop.log

print_head "Configuring redis repo file"
dnf install https://rpms.remirepo.net/enterprise/remi-release-8.rpm -y &>>log_file
dnf module enable redis:remi-6.2 -y &>>log_file
func_status_check $?

print_head "Install Redis"
dnf install redis -y &>>log_file
func_status_check $?

print_head "Edit the Listen address "
sed -i -e  's|127.0.0.1|0.0.0.0|' /etc/redis.conf  /etc/redis/redis.conf &>>log_file
func_status_check $?

print_head "Start Redis service"
systemctl enable redis &>>log_file
systemctl restart redisssh &>>log_file
func_status_check $?