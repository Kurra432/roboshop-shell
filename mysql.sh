script=$(realpath "$0")
script_path=$(dirname "$script")
source ${script_path}/common.sh
mysql_root_password=$1
if [ -z "$mysql_root_password" ]; then

   echo My Sql Password  missing
exit
   fi

print_head "MySQL Disable"
dnf module disable mysql -y &>>$log_file

status_check_func $?

print_head "Copying MySQL repo file"
cp ${script_path}/mysql.repo  /etc/yum.repos.d/mysql.repo &>>$log_file

status_check_func $?

print_head "Install MySQL"
dnf install mysql-community-server -y &>>$log_file
status_check_func $?

print_head  "Start  MySQL "
systemctl enable mysqld
systemctl restart mysqld
status_check_func $?

print_head "reset MySQL password"
mysql_secure_installation --set-root-pass $mysql_root_password &>>$log_file
status_check_func $?

