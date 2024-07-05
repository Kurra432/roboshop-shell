echo -e "\e[36m>>>>>>>>>> Configuring Erlang  repos>>>>>>>>>>\e[0m "
curl -s https://packagecloud.io/install/repositories/rabbitmq/erlang/script.rpm.sh | bash
curl -s https://packagecloud.io/install/repositories/rabbitmq/rabbitmq-server/script.rpm.sh | bash
echo -e "\e[36m>>>>>>>>>>Install Rabbitmq>>>>>>>>>>\e[0m "
dnf install rabbitmq-server -y
echo -e "\e[36m>>>>>>>>>>Start rabbitmq server>>>>>>>>>>\e[0m "
systemctl enable rabbitmq-server
systemctl restart rabbitmq-server
echo -e "\e[36m>>>>>>>>>> Add application user in Rabbitmq>>>>>>>>>>\e[0m "
rabbitmqctl add_user roboshop roboshop123
rabbitmqctl set_permissions -p / roboshop ".*" ".*" ".*"