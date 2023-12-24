script=$(realpath "$0")
script_path=$(dirname ${script})
source ${script_path}/common.sh
mysql_root_password=$1

if [ -z "${mysql_root_password}" ]; then
  echo Input MySQL Root Password Missing
  exit
fi

func_print_head "Disable mysql default version"
dnf module disable mysql -y
func_stat_check

func_print_head "Copy mysql repo file"
cp ${script_path}/mysql.repo /etc/yum.repos.d/mysql.repo
func_stat_check

func_print_head "Install mysql"
dnf install mysql-community-server -y
func_stat_check

func_print_head "start mysql"
systemctl enable mysqld
systemctl restart mysqld
func_stat_check

func_print_head "set mysql root password"
mysql_secure_installation --set-root-pass ${mysql_root_password}
func_stat_check

