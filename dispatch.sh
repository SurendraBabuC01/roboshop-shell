echo -e "\e[36m>>>>>>>>>>>>>>>>>>>>>> Install golang <<<<<<<<<<<<<<<<<<<<<<\e[0m"
dnf install golang -y

echo -e "\e[36m>>>>>>>>>>>>>>>>>>>>>> Add app user <<<<<<<<<<<<<<<<<<<<<<\e[0m"
useradd roboshop

echo -e "\e[36m>>>>>>>>>>>>>>>>>>>>>> create app directory <<<<<<<<<<<<<<<<<<<<<<\e[0m"
mkdir /app

echo -e "\e[36m>>>>>>>>>>>>>>>>>>>>>> Download app content <<<<<<<<<<<<<<<<<<<<<<\e[0m"
curl -L -o /tmp/dispatch.zip https://roboshop-artifacts.s3.amazonaws.com/dispatch.zip

echo -e "\e[36m>>>>>>>>>>>>>>>>>>>>>> unzip app content <<<<<<<<<<<<<<<<<<<<<<\e[0m"
cd /app
unzip /tmp/dispatch.zip

echo -e "\e[36m>>>>>>>>>>>>>>>>>>>>>> Install golang dependencies <<<<<<<<<<<<<<<<<<<<<<\e[0m"
cd /app
go mod init dispatch
go get
go build

echo -e "\e[36m>>>>>>>>>>>>>>>>>>>>>> copy dispatch service file <<<<<<<<<<<<<<<<<<<<<<\e[0m"
cp /home/centos/roboshop-shell/dispatch.service /etc/systemd/system/dispatch.service

echo -e "\e[36m>>>>>>>>>>>>>>>>>>>>>> start dispatch <<<<<<<<<<<<<<<<<<<<<<\e[0m"
systemctl daemon-reload
systemctl enable dispatch
systemctl restart dispatch