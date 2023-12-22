echo -e "\e[36m>>>>>>>>>>>>>>>>>>>>>> Install nginx <<<<<<<<<<<<<<<<<<<<<<\e[0m"
dnf install nginx -y

echo -e "\e[36m>>>>>>>>>>>>>>>>>>>>>> Copy roboshop.conf file <<<<<<<<<<<<<<<<<<<<<<\e[0m"
cp /home/centos/roboshop-shell/roboshop.conf /etc/nginx/default.d/roboshop.conf

echo -e "\e[36m>>>>>>>>>>>>>>>>>>>>>> Download app content <<<<<<<<<<<<<<<<<<<<<<\e[0m"
rm -rf /usr/share/nginx/html/*
curl -o /tmp/frontend.zip https://roboshop-artifacts.s3.amazonaws.com/frontend.zip

echo -e "\e[36m>>>>>>>>>>>>>>>>>>>>>> unzip app content <<<<<<<<<<<<<<<<<<<<<<\e[0m"
cd /usr/share/nginx/html/
unzip /tmp/frontend.zip

echo -e "\e[36m>>>>>>>>>>>>>>>>>>>>>> restart Nginx <<<<<<<<<<<<<<<<<<<<<<\e[0m"
systemctl enable nginx
systemctl restart nginx