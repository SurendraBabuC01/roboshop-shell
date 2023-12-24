script=$(realpath "$0")
script_path=$(dirname ${script})
source ${script_path}/common.sh

func_print_head "Copy mongo repo file"
cp ${script_path}/mongo.repo /etc/yum.repos.d/mongo.repo &>>${log_file}
func_stat_check $?

func_print_head "Install mongodb"
dnf install mongodb-org -y &>>${log_file}
func_stat_check $?

func_print_head "Update listen address from 127.0.0.1 to 0.0.0.0"
sed -i -e 's|127.0.0.1|0.0.0.0|' /etc/mongod.conf &>>${log_file}
func_stat_check $?

func_print_head "Start mongodb"
systemctl enable mongod &>>${log_file}
systemctl restart mongod &>>${log_file}
func_stat_check $?

