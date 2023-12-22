echo -e "/e[36m>>>>>>>>>>>>>>>>>>>>>> Disable mysql default version <<<<<<<<<<<<<<<<<<<<<</e[0m"
dnf module disable mysql -y

echo -e "/e[36m>>>>>>>>>>>>>>>>>>>>>> Copy mysql repo file <<<<<<<<<<<<<<<<<<<<<</e[0m"
cp mysql.repo /etc/yum.repos.d/mysql.repo

echo -e "/e[36m>>>>>>>>>>>>>>>>>>>>>> Install mysql <<<<<<<<<<<<<<<<<<<<<</e[0m"
dnf install mysql-community-server -y

echo -e "/e[36m>>>>>>>>>>>>>>>>>>>>>> start mysql <<<<<<<<<<<<<<<<<<<<<</e[0m"
systemctl enable mysqld
systemctl start mysqld

echo -e "/e[36m>>>>>>>>>>>>>>>>>>>>>> set mysql root password <<<<<<<<<<<<<<<<<<<<<</e[0m"
mysql_secure_installation --set-root-pass RoboShop@1

