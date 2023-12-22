echo -e "/e[36m>>>>>>>>>>>>>>>>>>>>>> Copy mongo repo file <<<<<<<<<<<<<<<<<<<<<</e[0m"
cp mongo.repo /etc/yum.repos.d/mongo.repo

echo -e "/e[36m>>>>>>>>>>>>>>>>>>>>>> Install mongodb <<<<<<<<<<<<<<<<<<<<<</e[0m"
dnf install mongodb-org -y

echo -e "/e[36m>>>>>>>>>>>>>>>>>>>>>> Update listen address from 127.0.0.1 to 0.0.0.0 <<<<<<<<<<<<<<<<<<<<<</e[0m"
sed -i -e 's|127.0.0.0|0.0.0.0.0|g' /etc/mongo.conf

echo -e "/e[36m>>>>>>>>>>>>>>>>>>>>>> Start mongodb <<<<<<<<<<<<<<<<<<<<<</e[0m"
systemctl enable mongod
systemctl start mongod

