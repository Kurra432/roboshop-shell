echo -e "\e[36m>>>>>>>>>>>>>>> Configure YUM Repos from the script provided by vendor. <<<<<<<<<\e[0m"
curl -s https://packagecloud.io/install/repositories/rabbitmq/erlang/script.rpm.sh | bash
echo -e "\e[36m>>>>>>>>>>>>>>> Configure YUM Repos for RabbitMQ <<<<<<<<<\e[0m"
curl -s https://packagecloud.io/install/repositories/rabbitmq/rabbitmq-server/script.rpm.sh | bash
echo -e "\e[36m>>>>>>>>>>>>>>> Install RabbitMQ <<<<<<<<<\e[0m"
dnf install rabbitmq-server -y
echo -e "\e[36m>>>>>>>>>>>>>>> Adding app user and passwd forRabbitMQ Service<<<<<<<<<\e[0m"
rabbitmqctl add_user roboshop roboshop123
echo -e "\e[36m>>>>>>>>>>>>>>> Start RabbitMQ Service<<<<<<<<<\e[0m"
systemctl enable rabbitmq-server
systemctl restart rabbitmq-server