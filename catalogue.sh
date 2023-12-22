echo -e "/e[36m>>>>>>>>>>>>>>>>>>>>>> Enable nodejs:18 <<<<<<<<<<<<<<<<<<<<<</e[0m"
dnf module disable nodejs -y
dnf module enable nodejs:18 -y

echo -e "/e[36m>>>>>>>>>>>>>>>>>>>>>> Install nodejs <<<<<<<<<<<<<<<<<<<<<</e[0m"
dnf install nodejs -y

echo -e "/e[36m>>>>>>>>>>>>>>>>>>>>>> Add Application user <<<<<<<<<<<<<<<<<<<<<</e[0m"
useradd roboshop

echo -e "/e[36m>>>>>>>>>>>>>>>>>>>>>> Create app directory <<<<<<<<<<<<<<<<<<<<<</e[0m"
rm -rf /app
mkdir /app

echo -e "/e[36m>>>>>>>>>>>>>>>>>>>>>> Download app content <<<<<<<<<<<<<<<<<<<<<</e[0m"
curl -o /tmp/catalogue.zip https://roboshop-artifacts.s3.amazonaws.com/catalogue.zip
cd /app

echo -e "/e[36m>>>>>>>>>>>>>>>>>>>>>> Unzip app content <<<<<<<<<<<<<<<<<<<<<</e[0m"
unzip /tmp/catalogue.zip

echo -e "/e[36m>>>>>>>>>>>>>>>>>>>>>> Download nodejs dependencies <<<<<<<<<<<<<<<<<<<<<</e[0m"
cd /app
npm install

echo -e "/e[36m>>>>>>>>>>>>>>>>>>>>>> Copy catalogue service file <<<<<<<<<<<<<<<<<<<<<</e[0m"
cp /home/centos/roboshop-shellcatalogue.service /etc/systemd/system/catalogue.service

echo -e "/e[36m>>>>>>>>>>>>>>>>>>>>>> Start Catalogue <<<<<<<<<<<<<<<<<<<<<</e[0m"
systemctl daemon-reload
systemctl enable catalogue
systemctl start catalogue

echo -e "/e[36m>>>>>>>>>>>>>>>>>>>>>> Copy mongodb repo file <<<<<<<<<<<<<<<<<<<<<</e[0m"
cp mongo.repo /etc/yum.repos.d/mongo.repo

echo -e "/e[36m>>>>>>>>>>>>>>>>>>>>>> Install mongodb client <<<<<<<<<<<<<<<<<<<<<</e[0m"
dnf install mongodb-org-shell -y

echo -e "/e[36m>>>>>>>>>>>>>>>>>>>>>> Load Schema <<<<<<<<<<<<<<<<<<<<<</e[0m"
mongo --host mongodb-dev.surendrababuc01.online </app/schema/catalogue.js