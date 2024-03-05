script=$(realpath "$0")
script_path=$(dirname "$script")
rabbitmq_user_password=$1
source ${script_path}/common.sh


if [ -z "$rabbitmq_user_password" ]; then

   echo Rabbitmq User Password  missing
exit
   fi

component=payment

python_func