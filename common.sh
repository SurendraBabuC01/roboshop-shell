app_user=roboshop
script=$(realpath "$0")
script_path=$(dirname ${script})

func_print_head() {
   echo -e "\e[36m>>>>>>>>>>>>>>>>>>>>>> $1 <<<<<<<<<<<<<<<<<<<<<<\e[0m"
}

func_stat_check() {
  if [ $? -eq "0" ]
  then
    echo -e "\e[32mSUCEESS\e[0m"
  else
    echo -e "\e[31mFAILURE\e[0m"
    exit 1
  fi
}


func_schema_setup() {
  if [ "${schema_setup}" == "mongo" ]; then
    func_print_head "Copy mongodb repo file"
    cp ${script_path}/mongo.repo /etc/yum.repos.d/mongo.repo

    func_print_head> "Install mongodb client"
    dnf install mongodb-org-shell -y

    func_print_head "Load Schema"
    mongo --host mongodb-dev.surendrababuc01.online </app/schema/${component}.js
  fi
  if [ "${schema_setup}" == "mysql" ]; then
    func_print_head "Install mysql client"
    dnf install mysql -y

    func_print_head "Load Schema"
    mysql -h mysql-dev.surendrababuc01.online -uroot -p${mysql_root_password} < /app/schema/${component}.sql
  fi
}

func_app_prereq() {
  func_print_head "Add Application user"
  useradd ${app_user}

  func_print_head "Create app directory"
  rm -rf /app
  mkdir /app

  func_print_head "Download app content"
  curl -o /tmp/${component}.zip https://roboshop-artifacts.s3.amazonaws.com/${component}.zip
  cd /app

  func_print_head "Unzip app content"
  unzip /tmp/${component}.zip
}

func_systemd_setup() {
  func_print_head "Copy ${component} service file"
  cp ${script_path}/${component}.service /etc/systemd/system/${component}.service

  func_print_head "start ${component}"
  systemctl daemon-reload
  systemctl enable ${component}
  systemctl restart ${component}
}

func_nodejs() {
  func_print_head "Enable nodejs:18"
  dnf module disable nodejs -y
  dnf module enable nodejs:18 -y

  func_print_head "Install nodej"s
  dnf install nodejs -y

  func_app_prereq

  func_print_head "Download nodejs dependencies"
  cd /app
  npm install

  func_schema_setup

  func_systemd_setup
}

func_java() {
  func_print_head "Install maven"
  dnf install maven -y

  func_app_prereq

  func_print_head "Install maven dependencies"
  cd /app
  mvn clean package

  func_print_head "Move ${component} jar file"
  mv target/${component}-1.0.jar ${component}.jar

 func_schema_setup

 func_systemd_setup
}

func_python() {
  func_print_head "Install python"
  dnf install python36 gcc python3-devel -y

  func_app_prereq

  func_print_head "Install python dependencies"
  cd /app
  pip3.6 install -r requirements.txt

  func_systemd_setup

  func_print_head "Update Passwords in System Service file"
  sed -i -e "s|rabbitmq_appuser_password|${rabbitmq_appuser_password}|" ${script_path}/${component}.service
}

func_golang() {
  func_print_head "Install golang"
  dnf install golang -y

  func_app_prereq

  func_print_head "Install golang dependencies"
  cd /app
  go mod init dispatch
  go get
  go build

  func_systemd_setup
}