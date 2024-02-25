echo -e "\e[36m>>>>>>>>>>>>>>>Install Nginx<<<<<<<<<\e[0m"
yum install nginx
echo -e "\e[36m>>>>>>>>>>>>>>>Copying roboshop conf file <<<<<<<<<\e[0m"
cp roboshop.conf /etc/nginx/default.d/roboshop.conf
echo -e "\e[36m>>>>>>>>>>>>>>> Remove Old content<<<<<<<<<\e[0m"
rm -rf /usr/share/nginx/html/*
echo -e "\e[36m>>>>>>>>>>>>>>> Download the Frontend content<<<<<<<<<\e[0m"
curl -o /tmp/frontend.zip https://roboshop-artifacts.s3.amazonaws.com/frontend.zip
echo -e "\e[36m>>>>>>>>>>>>>>> Extract the Frontend content<<<<<<<<<\e[0m"
cd /usr/share/nginx/html
unzip /tmp/frontend.zip
echo -e "\e[36m>>>>>>>>>>>>>>>  Start the Frontend Service<<<<<<<<<\e[0m"
systemctl enable nginx
systemctl restart nginx

