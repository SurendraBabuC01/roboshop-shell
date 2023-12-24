script=$(realpath "$0")
script_path=$(dirname ${script})
source ${script_path}/common.sh
rabbitmq_app_password=$1

if [ -z "$rabbitmq_appuser_password" ]; then
  echo Input Rabbitmq Appuser Password Missing
  exit 1
fi

component=payment

func_python