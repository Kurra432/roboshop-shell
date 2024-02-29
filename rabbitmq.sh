script=$(realpath "$0")
script_path=$(dirname "$script")
source ${script_path}/common.sh
rabbitmq_user_password=$1

if [ -z "$rabbitmq_user_password" ]; then

   echo Rabbitmq User Password  missing
exit
   fi

echo -e "\e[36m>>>>>>>>>>>>>>> Configure YUM Repos from the script provided by vendor. <<<<<<<<<\e[0m"
curl -s https://packagecloud.io/install/repositories/rabbitmq/erlang/script.rpm.sh | bash
echo -e "\e[36m>>>>>>>>>>>>>>> Configure YUM Repos for RabbitMQ <<<<<<<<<\e[0m"
curl -s https://packagecloud.io/install/repositories/rabbitmq/rabbitmq-server/script.rpm.sh | bash
echo -e "\e[36m>>>>>>>>>>>>>>> Install RabbitMQ <<<<<<<<<\e[0m"
dnf install rabbitmq-server -y
echo -e "\e[36m>>>>>>>>>>>>>>> Adding app user and passwd forRabbitMQ Service<<<<<<<<<\e[0m"
rabbitmqctl add_user roboshop ${rabbitmq_user_password}
echo -e "\e[36m>>>>>>>>>>>>>>> Start RabbitMQ Service<<<<<<<<<\e[0m"
systemctl enable rabbitmq-server
systemctl restart rabbitmq-server