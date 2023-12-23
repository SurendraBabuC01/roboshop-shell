realpath = $(realpath $0)
script_path=$(dirname realpath)
source ${script_path}/common.sh

echo $script_path
exit

func_nodejs

echo -e "\e[36m>>>>>>>>>>>>>>>>>>>>>> Copy mongodb repo file <<<<<<<<<<<<<<<<<<<<<<\e[0m"
cp ${script_path}/mongo.repo /etc/yum.repos.d/mongo.repo

echo -e "\e[36m>>>>>>>>>>>>>>>>>>>>>> Install mongodb client <<<<<<<<<<<<<<<<<<<<<<\e[0m"
dnf install mongodb-org-shell -y

echo -e "\e[36m>>>>>>>>>>>>>>>>>>>>>> Load Schema <<<<<<<<<<<<<<<<<<<<<<\e[0m"
mongo --host mongodb-dev.surendrababuc01.online </app/schema/catalogue.js