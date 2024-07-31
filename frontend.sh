script=$(realpath "$0")
script_path=$(dirname "$script")
source ${script_path}/common.sh
log_file=/tmp/roboshop.log

print_head  "Install Nginx"
dnf install nginx -y &>>log_file
func_status_check $?

print_head "Copying Roboshop Config file"
cp roboshop.conf /etc/nginx/default.d/roboshop.conf &>>log_file
func_status_check $?

print_head"Removing Old content"
rm -rf /usr/share/nginx/html/* &>>log_file
func_status_check $?

print_head "Download App Content"
curl -o /tmp/frontend.zip https://roboshop-artifacts.s3.amazonaws.com/frontend.zip &>>log_file
func_status_check $?

print_head  "Unzip the content"
cd /usr/share/nginx/html &>>log_file
unzip /tmp/frontend.zip &>>log_file
func_status_check $?

print_head "Start the Frontend service"
systemctl enable nginx &>>log_file
systemctl restart nginx &>>log_file
func_status_check $?