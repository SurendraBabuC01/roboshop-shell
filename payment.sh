echo -e "\e[36m>>>>>>>>>>>>>>>>>>>>>> Install python <<<<<<<<<<<<<<<<<<<<<<\e[0m"
dnf install python36 gcc python3-devel -y

echo -e "\e[36m>>>>>>>>>>>>>>>>>>>>>> Add app user <<<<<<<<<<<<<<<<<<<<<<\e[0m"
useradd roboshop

echo -e "\e[36m>>>>>>>>>>>>>>>>>>>>>> create app directory <<<<<<<<<<<<<<<<<<<<<<\e[0m"
mkdir /app

echo -e "\e[36m>>>>>>>>>>>>>>>>>>>>>> Download app content <<<<<<<<<<<<<<<<<<<<<<\e[0m"
curl -L -o /tmp/payment.zip https://roboshop-artifacts.s3.amazonaws.com/payment.zip

echo -e "\e[36m>>>>>>>>>>>>>>>>>>>>>> unzip app content <<<<<<<<<<<<<<<<<<<<<<\e[0m"
cd /app
unzip /tmp/payment.zip

echo -e "\e[36m>>>>>>>>>>>>>>>>>>>>>> Install python dependencies <<<<<<<<<<<<<<<<<<<<<<\e[0m"
cd /app
pip3.6 install -r requirements.txt

echo -e "\e[36m>>>>>>>>>>>>>>>>>>>>>> copy payment service file <<<<<<<<<<<<<<<<<<<<<<\e[0m"
cp /home/centos/roboshop-shell/payment.service /etc/systemd/system/payment.service

echo -e "\e[36m>>>>>>>>>>>>>>>>>>>>>> start payment <<<<<<<<<<<<<<<<<<<<<<\e[0m"
systemctl daemon-reload
systemctl enable payment
systemctl restart payment