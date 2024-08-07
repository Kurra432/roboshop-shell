script=$(realpath "$0")
script_path=$(dirname "$script")
source ${script_path}/common.sh
mysql_root_passwd=$1

if [ -z "$mysql_root_passwd" ]; then
  echo Input Missing
  exit
fi

print_head "Configuring Mysql repo"
dnf module disable mysql -y &>>$log_file
func_status_check $?

print_head "Copying SystemD service file"
cp ${script_path}/mysql.repo /etc/yum.repos.d/mysql.repo &>>$log_file
func_status_check $?

print_head "Install Mysql"
dnf install mysql-community-server -y &>>$log_file
func_status_check $?

print_head "Start Mysql"
systemctl enable mysqld &>>$log_file
systemctl restart mysqld &>>$log_file
func_status_check $?

print_head "Reset Mysql Passwd"
mysql_secure_installation --set-root-pass ${mysql_root_passwd}

