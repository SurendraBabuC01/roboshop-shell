echo -e "\e[36m>>>>>>>>>>>>>>>>>>>>>> Enable nodejs:18 <<<<<<<<<<<<<<<<<<<<<<\e[0m"
dnf module disable nodejs -y
dnf module enable nodejs:18 -y

echo -e "\e[36m>>>>>>>>>>>>>>>>>>>>>> Install nodejs <<<<<<<<<<<<<<<<<<<<<<\e[0m"
dnf install nodejs -y

echo -e "\e[36m>>>>>>>>>>>>>>>>>>>>>> Add app user <<<<<<<<<<<<<<<<<<<<<<\e[0m"
useradd roboshop

echo -e "\e[36m>>>>>>>>>>>>>>>>>>>>>> create app directory <<<<<<<<<<<<<<<<<<<<<<\e[0m"
rm -rf /app
mkdir /app

echo -e "\e[36m>>>>>>>>>>>>>>>>>>>>>> Download app content <<<<<<<<<<<<<<<<<<<<<<\e[0m"
curl -o /tmp/user.zip https://roboshop-artifacts.s3.amazonaws.com/user.zip

echo -e "\e[36m>>>>>>>>>>>>>>>>>>>>>> unzip app content <<<<<<<<<<<<<<<<<<<<<<\e[0m"
cd /app
unzip /tmp/user.zip

echo -e "\e[36m>>>>>>>>>>>>>>>>>>>>>> Install nodejs dependencies <<<<<<<<<<<<<<<<<<<<<<\e[0m"
cd /app
npm install

echo -e "\e[36m>>>>>>>>>>>>>>>>>>>>>> copy user service file <<<<<<<<<<<<<<<<<<<<<<\e[0m"
cp /home/centos/roboshop-shell/user.service /etc/systemd/system/user.service

echo -e "\e[36m>>>>>>>>>>>>>>>>>>>>>> start user <<<<<<<<<<<<<<<<<<<<<<\e[0m"
systemctl daemon-reload
systemctl enable user
systemctl start user

echo -e "\e[36m>>>>>>>>>>>>>>>>>>>>>> copy mongodb repo file <<<<<<<<<<<<<<<<<<<<<<\e[0m"
cp /home/centos/roboshop-shell/mongo.repo /etc/yum.repos.d/mongo.repo

echo -e "\e[36m>>>>>>>>>>>>>>>>>>>>>>Install mongodb client <<<<<<<<<<<<<<<<<<<<<<\e[0m"
dnf install mongodb-org-shell -y

echo -e "\e[36m>>>>>>>>>>>>>>>>>>>>>> Load Schema <<<<<<<<<<<<<<<<<<<<<<\e[0m"
mongo --host mongodb-dev.surendrababuc01.online </app/schema/user.js