source common.sh
echo -e "\e[36m>>>>>>>>>>>>>>>>>>> Install Python 3.6 <<<<<<<<<<<<<\e[0m"
dnf install python36 gcc python3-devel -y
echo -e "\e[36m>>>>>>>>>>>>>>>>>>> Add Application User<<<<<<<<<<<<<\e[0m"
useradd ${app_user}
echo -e "\e[36m>>>>>>>>>>>>>>>>>>> Creating App Directory<<<<<<<<<<<<<\e[0m"
rm -f /app
mkdir /app
echo -e "\e[36m>>>>>>>>>>>>>>>>>>> Downloading App Content<<<<<<<<<<<<<\e[0m"
curl -L -o /tmp/payment.zip https://roboshop-artifacts.s3.amazonaws.com/payment.zip
echo -e "\e[36m>>>>>>>>>>>>>>>>>>> Changing to App Directory<<<<<<<<<<<<<\e[0m"
cd /app
echo -e "\e[36m>>>>>>>>>>>>>>>>>>> Extract the Content<<<<<<<<<<<<<\e[0m"
unzip /tmp/payment.zip
echo -e "\e[36m>>>>>>>>>>>>>>>>>>> Download the Dependices<<<<<<<<<<<<<\e[0m"
pip3.6 install -r requirements.txt
echo -e "\e[36m>>>>>>>>>>>>>>>>>>> Setup the SystemD service file<<<<<<<<<<<<<\e[0m"
cp /home/centos/roboshop-shell/payment.service /etc/systemd/system/payment.service
echo -e "\e[36m>>>>>>>>>>>>>>>>>>> Load the Schema<<<<<<<<<<<<<\e[0m"
systemctl daemon-reload
echo -e "\e[36m>>>>>>>>>>>>>>>>>>>Start the Payment Service<<<<<<<<<<<<<\e[0m"
systemctl enable payment
systemctl restart payment