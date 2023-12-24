script=$(realpath "$0")
script_path=$(dirname ${script})
source ${script_path}/common.sh

func_print_head "Disable mysql default version"
dnf module disable mysql -y

func_print_head "Copy mysql repo file"
cp ${script_path}/mysql.repo /etc/yum.repos.d/mysql.repo

func_print_head "Install mysql"
dnf install mysql-community-server -y

func_print_head "start mysql"
systemctl enable mysqld
systemctl restart mysqld

func_print_head "set mysql root password" +
mysql_secure_installation --set-root-pass RoboShop@1

