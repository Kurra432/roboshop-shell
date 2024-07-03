echo -e "\e[36m >>>>>>>>>> Install Nginx <<<<<<<<<<<\e[0m"
dnf install nginx -y
echo -e "\e[36m >>>>>>>>>> Copying Roboshop Config file<<<<<<<<<<<\e[0m"
cp roboshop.conf /etc/nginx/default.d/roboshop.conf
echo -e "\e[36m >>>>>>>>>>Removing Old content<<<<<<<<<<<\e[0m"
rm -rf /usr/share/nginx/html/*
echo -e "\e[36m >>>>>>>>>> Download App Content <<<<<<<<<<<\e[0m"
curl -o /tmp/frontend.zip https://roboshop-artifacts.s3.amazonaws.com/frontend.zip
echo -e "\e[36m >>>>>>>>>> Install Nginx <<<<<<<<<<<\e[0m"
cd /usr/share/nginx/html
echo -e "\e[36m >>>>>>>>>> Unzip the content <<<<<<<<<<<\e[0m"
unzip /tmp/frontend.zip
echo -e "\e[36m >>>>>>>>>> Start the Frontend service <<<<<<<<<<<\e[0m"
systemctl enable nginx
systemctl restart nginx