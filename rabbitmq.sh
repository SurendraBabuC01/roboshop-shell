script=$(realpath "$0")
script_path=$(dirname ${script})
source ${script_path}/common.sh

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
rabbitmqctl add_user roboshop roboshop123

func_print_head "set_permissions of app user"
rabbitmqctl set_permissions -p / roboshop ".*" ".*" ".*"
