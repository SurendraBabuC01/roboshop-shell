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
curl -o /tmp/cart.zip https://roboshop-artifacts.s3.amazonaws.com/cart.zip

echo -e "\e[36m>>>>>>>>>>>>>>>>>>>>>> unzip app content <<<<<<<<<<<<<<<<<<<<<<\e[0m"
cd /app
unzip /tmp/cart.zip

echo -e "\e[36m>>>>>>>>>>>>>>>>>>>>>> Install nodejs dependencies <<<<<<<<<<<<<<<<<<<<<<\e[0m"
cd /app
npm install

echo -e "\e[36m>>>>>>>>>>>>>>>>>>>>>> copy cart service file <<<<<<<<<<<<<<<<<<<<<<\e[0m"
cp /home/centos/roboshop-shell/cart.service /etc/systemd/system/cart.service

echo -e "\e[36m>>>>>>>>>>>>>>>>>>>>>> start cart <<<<<<<<<<<<<<<<<<<<<<\e[0m"
systemctl daemon-reload
systemctl enable cart
systemctl start cart