script=$(realpath "$0")
script_path=$(dirname ${script})
source ${script_path}/common.sh

func_print_head "Install nginx"
dnf install nginx -y &>>${log_file}
func_stat_check $?

func_print_head "Copy roboshop conf file"
cp ${script_path}/roboshop.conf /etc/nginx/default.d/roboshop.conf &>>${log_file}
func_stat_check $?

func_print_head "Download app content"
rm -rf /usr/share/nginx/html/* &>>${log_file}
curl -o /tmp/frontend.zip https://roboshop-artifacts.s3.amazonaws.com/frontend.zip &>>${log_file}
func_stat_check $?

func_print_head "unzip app content"
cd /usr/share/nginx/html/ &>>${log_file}
unzip /tmp/frontend.zip &>>${log_file}
func_stat_check $?

func_print_head "restart nginx"
systemctl enable nginx &>>${log_file}
systemctl restart nginx &>>${log_file}
func_stat_check $?