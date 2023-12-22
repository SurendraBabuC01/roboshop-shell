echo -e "\e[36m>>>>>>>>>>>>>>>>>>>>>> Download erlang repo <<<<<<<<<<<<<<<<<<<<<<\e[0m"
curl -s https://packagecloud.io/install/repositories/rabbitmq/erlang/script.rpm.sh | bash

echo -e "\e[36m>>>>>>>>>>>>>>>>>>>>>> Download rabbitmq repo file <<<<<<<<<<<<<<<<<<<<<<\e[0m"
curl -s https://packagecloud.io/install/repositories/rabbitmq/rabbitmq-server/script.rpm.sh | bash

echo -e "\e[36m>>>>>>>>>>>>>>>>>>>>>> Install rabbitmq <<<<<<<<<<<<<<<<<<<<<<\e[0m"
dnf install rabbitmq-server -y

echo -e "\e[36m>>>>>>>>>>>>>>>>>>>>>> start rabbitmq <<<<<<<<<<<<<<<<<<<<<<\e[0m"
systemctl enable rabbitmq-server
systemctl restart rabbitmq-server

echo -e "\e[36m>>>>>>>>>>>>>>>>>>>>>> add app user <<<<<<<<<<<<<<<<<<<<<<\e[0m"
rabbitmqctl add_user roboshop roboshop123

echo -e "\e[36m>>>>>>>>>>>>>>>>>>>>>> set_permissions of app user <<<<<<<<<<<<<<<<<<<<<<\e[0m"
rabbitmqctl set_permissions -p / roboshop ".*" ".*" ".*"
