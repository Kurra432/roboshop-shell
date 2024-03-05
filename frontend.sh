script=$(realpath "$0")
script_path=$(dirname "$script")
source ${script_path}/common.sh
print_head "Install Nginx<<<<<<<<<"
yum install nginx &>>$log_file
status_check_func $?

print_head "Copying roboshop conf file"
cp roboshop.conf /etc/nginx/default.d/roboshop.conf &>>$log_file
status_check_func $?
print_head " Remove Old content"
rm -rf /usr/share/nginx/html/* &>>$log_file
status_check_func $?
print_head "Download the Frontend content"
curl -o /tmp/frontend.zip https://roboshop-artifacts.s3.amazonaws.com/frontend.zip &>>$log_file
status_check_func $?
print_head " Extract the Frontend content"
cd /usr/share/nginx/html
unzip /tmp/frontend.zip &>>$log_file
status_check_func $?

print_head " Start the Frontend Service"
systemctl enable nginx &>>$log_file
systemctl restart nginx &>>$log_file
status_check_func $?