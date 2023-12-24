app_user=roboshop
script=$(realpath "$0")
script_path=$(dirname ${script})

func_print_head() {
   echo -e "\e[36m>>>>>>>>>>>>>>>>>>>>>> $1 <<<<<<<<<<<<<<<<<<<<<<\e[0m"
}


func_schema_setup() {
  if [ "${schema_setup}" == "mongo" ]; then
    func_print_head "Copy mongodb repo file"
    cp ${script_path}/mongo.repo /etc/yum.repos.d/mongo.repo

    func_print_head> "Install mongodb client"
    dnf install mongodb-org-shell -y

    func_print_head "Load Schema"
    mongo --host mongodb-dev.surendrababuc01.online </app/schema/catalogue.js
  fi
  if [ "${schema_setup}" == "mysql" ]; then
    func_print_head "Install mysql client"
    dnf install mysql -y

    func_print_head "Load Schema"
    mysql -h mysql-dev.surendrababuc01.online -uroot -pRoboShop@1 < /app/schema/${component}.sql
  fi
}

func_nodejs() {
  func_print_head "Enable nodejs:18"
  dnf module disable nodejs -y
  dnf module enable nodejs:18 -y

  func_print_head "Install nodej"s
  dnf install nodejs -y

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

  func_print_head "Download nodejs dependencies"
  cd /app
  npm install

  func_print_head "Copy ${component} service file"
  cp ${script_path}/${component}.service /etc/systemd/system/${component}.service

  func_print_head "Start ${component}"
  systemctl daemon-reload
  systemctl enable ${component}e
  systemctl restart ${component}
  
  func_schema_setup
}

func_java() {
  func_print_head "Install maven"
  dnf install maven -y

  func_print_head "Add app user"
  useradd ${app_user}

  func_print_head "create app directory"
  rm -rf /app
  mkdir /app

  func_print_head "Download app content"
  curl -L -o /tmp/${component}.zip https://roboshop-artifacts.s3.amazonaws.com/${component}.zip

  func_print_head "unzip app content"
  cd /app
  unzip /tmp/${component}.zip

  func_print_head "Install maven dependencies"
  cd /app
  mvn clean package

  func_print_head "Move ${component} jar file"
  mv target/${component}-1.0.jar ${component}.jar

  func_print_head "copy ${component} service file"
  cp ${script_path}/${component}.service /etc/systemd/system/${component}.service

 func_schema_setup

  func_print_head "start ${component}"
  systemctl daemon-reload
  systemctl enable ${component}
  systemctl restart ${component}
}

func_python() {
  func_print_head "Install python"
  dnf install python36 gcc python3-devel -y

  func_print_head "Add app user"
  useradd ${app_user}

  func_print_head "create app directory"
  mkdir /app

  func_print_head "Download app content"
  curl -L -o /tmp/${component}.zip https://roboshop-artifacts.s3.amazonaws.com/${component}.zip

  func_print_head "unzip app content"
  cd /app
  unzip /tmp/${component}.zip

  func_print_head "Install python dependencies"
  cd /app
  pip3.6 install -r requirements.txt

  func_print_head "copy ${component} service file"
  cp ${script_path}/${component}.service /etc/systemd/system/${component}.service

  func_print_head "start ${component}"
  systemctl daemon-reload
  systemctl enable ${component}
  systemctl restart ${component}
}

func_golang() {
  func_print_head "Install golang"
  dnf install golang -y

  func_print_head "Add app user"
  useradd app_user

  func_print_head "create app directory"
  mkdir /app

  func_print_head "Download app content"
  curl -L -o /tmp/${component}.zip https://roboshop-artifacts.s3.amazonaws.com/${component}.zip

  func_print_head "unzip app content"
  cd /app
  unzip /tmp/${component}.zip

  func_print_head "Install golang dependencies"
  cd /app
  go mod init dispatch
  go get
  go build

  func_print_head "copy ${component} service file"
  cp ${script_path}/${component}.service /etc/systemd/system/${component}.service

  func_print_head "start ${component}"
  systemctl daemon-reload
  systemctl enable ${component}
  systemctl restart ${component}
}