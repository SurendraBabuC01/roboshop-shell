echo -e "/e[36m>>>>>>>>>>>>>>>>>>>>>> Install Redis repo file <<<<<<<<<<<<<<<<<<<<<</e[0m"
dnf install https://rpms.remirepo.net/enterprise/remi-release-8.rpm -y

echo -e "/e[36m>>>>>>>>>>>>>>>>>>>>>> Enable redis 6.2 <<<<<<<<<<<<<<<<<<<<<</e[0m"
dnf module enable redis:remi-6.2 -y

echo -e "/e[36m>>>>>>>>>>>>>>>>>>>>>> Install redis <<<<<<<<<<<<<<<<<<<<<</e[0m"
dnf install redis -y

echo -e "/e[36m>>>>>>>>>>>>>>>>>>>>>> Update listen address from 127.0.0.1 to 0.0.0.0 <<<<<<<<<<<<<<<<<<<<<</e[0m"
sed -i -e 's|127.0.0.1|0.0.0.0|g' /etc/mongo.repo

echo -e "/e[36m>>>>>>>>>>>>>>>>>>>>>> start redis <<<<<<<<<<<<<<<<<<<<<</e[0m"
systemctl enable redis
systemctl start redis