script=$(realpath "$0")
script_path=$(dirname ${script})
source ${script_path}/common.sh
rabbitmq_appuser_password=$1

if [ -z "$rabbitmq_appuser_password" ]
 then
  echo Input Rabbitmq Appuser Password Missing
  exit 1
fi

func_print_head "Download erlang repo"
curl -s https://packagecloud.io/install/repositories/rabbitmq/erlang/script.rpm.sh | bash &>>${log_file}
func_stat_check $?

func_print_head "Download rabbitmq repo file"
curl -s https://packagecloud.io/install/repositories/rabbitmq/rabbitmq-server/script.rpm.sh | bash &>>${log_file}
func_stat_check $?

func_print_head "Install rabbitmq"
dnf install rabbitmq-server -y &>>${log_file}
func_stat_check $?

func_print_head "start rabbitmq"
systemctl enable rabbitmq-server &>>${log_file}
systemctl restart rabbitmq-server &>>${log_file}
func_stat_check $?

func_print_head "add app user"
rabbitmqctl list_users | grep -i ${app_user} &>>${log_file}
if [ $? -ne 0 ]; then
  rabbitmqctl add_user roboshop ${rabbitmq_appuser_password} &>>${log_file}
fi
func_stat_check $?

func_print_head "set_permissions of app user"
rabbitmqctl set_permissions -p / roboshop ".*" ".*" ".*" &>>${log_file}
func_stat_check $?
