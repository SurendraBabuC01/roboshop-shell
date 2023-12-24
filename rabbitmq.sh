script=$(realpath "$0")
script_path=$(dirname ${script})
source ${script_path}/common.sh
rabbitmq_app_password=$1

if [ -z "$rabbitmq_appuser_password" ]; then
  echo Input Roboshop Appuser Password Missing
  exit 1
fi

func_print_head "Download erlang repo"
curl -s https://packagecloud.io/install/repositories/rabbitmq/erlang/script.rpm.sh | bash

func_print_head "Download rabbitmq repo file"
curl -s https://packagecloud.io/install/repositories/rabbitmq/rabbitmq-server/script.rpm.sh | bash

func_print_head "Install rabbitmq"
dnf install rabbitmq-server -y

func_print_head "start rabbitmq"
systemctl enable rabbitmq-server
systemctl restart rabbitmq-server

func_print_head "add app user"
rabbitmqctl add_user roboshop ${rabbitmq_app_password}

func_print_head "set_permissions of app user"
rabbitmqctl set_permissions -p / roboshop ".*" ".*" ".*"
