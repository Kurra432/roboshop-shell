script=$(realpath "$0")
script_path=$(dirname "$script")
source ${script_path}/common.sh
rabbitmq_app_password=$1

if [ -z "$rabbitmq_app_password" ]; then
  echo Input Missing
  exit
  fi

component=payment

func_python