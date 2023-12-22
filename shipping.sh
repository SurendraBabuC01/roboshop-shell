echo -e "\e[36m>>>>>>>>>>>>>>>>>>>>>> Install maven <<<<<<<<<<<<<<<<<<<<<<\e[0m"
dnf install maven -y

echo -e "\e[36m>>>>>>>>>>>>>>>>>>>>>> Add app user <<<<<<<<<<<<<<<<<<<<<<\e[0m"
useradd roboshop

echo -e "\e[36m>>>>>>>>>>>>>>>>>>>>>> create app directory <<<<<<<<<<<<<<<<<<<<<<\e[0m"
rm -rf /app
mkdir /app

echo -e "\e[36m>>>>>>>>>>>>>>>>>>>>>> Download app content <<<<<<<<<<<<<<<<<<<<<<\e[0m"
curl -L -o /tmp/shipping.zip https://roboshop-artifacts.s3.amazonaws.com/shipping.zip

echo -e "\e[36m>>>>>>>>>>>>>>>>>>>>>> unzip app content <<<<<<<<<<<<<<<<<<<<<<\e[0m"
cd /app
unzip /tmp/shipping.zip

echo -e "\e[36m>>>>>>>>>>>>>>>>>>>>>> Install maven dependencies <<<<<<<<<<<<<<<<<<<<<<\e[0m"
cd /app
mvn clean package

echo -e "\e[36m>>>>>>>>>>>>>>>>>>>>>> Move shipping.jar file <<<<<<<<<<<<<<<<<<<<<<\e[0m"
mv target/shipping-1.0.jar shipping.jar

echo -e "\e[36m>>>>>>>>>>>>>>>>>>>>>> copy shipping service file <<<<<<<<<<<<<<<<<<<<<<\e[0m"
cp /home/centos/roboshop-shell/shipping.service /etc/systemd/system/shipping.service

echo -e "\e[36m>>>>>>>>>>>>>>>>>>>>>> start shipping <<<<<<<<<<<<<<<<<<<<<<\e[0m"
systemctl daemon-reload
systemctl enable shipping
systemctl restart shipping

echo -e "\e[36m>>>>>>>>>>>>>>>>>>>>>> Install mysql client <<<<<<<<<<<<<<<<<<<<<<\e[0m"
dnf install mysql -y

echo -e "\e[36m>>>>>>>>>>>>>>>>>>>>>> Load Schema <<<<<<<<<<<<<<<<<<<<<<\e[0m"
mysql -h mysql-dev.surendrababuc01.online -uroot -pRoboShop@1 < /app/schema/shipping.sql

echo -e "\e[36m>>>>>>>>>>>>>>>>>>>>>> Restart shipping <<<<<<<<<<<<<<<<<<<<<<\e[0m"
systemctl restart shipping

