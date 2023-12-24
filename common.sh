app_user=roboshop
script=$(realpath "$0")
script_path=$(dirname ${script})
log_file="/tmp/roboshop.log"
#rm -f ${log_file}

func_print_head() {
   echo -e "\e[36m>>>>>>>>>>>>>>>>>>>>>> $1 <<<<<<<<<<<<<<<<<<<<<<\e[0m"
   echo -e "\e[36m>>>>>>>>>>>>>>>>>>>>>> $1 <<<<<<<<<<<<<<<<<<<<<<\e[0m" &>>${log_file}
}

func_stat_check() {
  if [ $1 -eq 0 ]
  then
    echo -e "\e[32mSUCCESS\e[0m"
  else
    echo -e "\e[31mFAILURE\e[0m"
    echo -e "\e[31mPlease refer /tmp/roboshop.log file for more information\e[0m"
    exit 1
  fi
}

func_schema_setup() {
  if [ "${schema_setup}" == "mongo" ]; then
    func_print_head "Copy mongodb repo file"
    cp ${script_path}/mongo.repo /etc/yum.repos.d/mongo.repo &>>${log_file}
    func_stat_check

    func_print_head> "Install mongodb client"
    dnf install mongodb-org-shell -y &>>${log_file}
    func_stat_check

    func_print_head "Load Schema"
    mongo --host mongodb-dev.surendrababuc01.online </app/schema/${component}.js &>>${log_file}
    func_stat_check $?
  fi
  if [ "${schema_setup}" == "mysql" ]; then
    func_print_head "Install mysql client"
    dnf install mysql -y &>>${log_file}
    func_stat_check $?

    func_print_head "Load Schema"
    mysql -h mysql-dev.surendrababuc01.online -uroot -p${mysql_root_password} < /app/schema/${component}.sql &>>${log_file}
    func_stat_check $?
  fi
}

func_app_prereq() {
  func_print_head "Add Application user"
  id ${app_user} &>>${log_file}
  if [ $? -ne "0" ] &>>${log_file}
  then
    useradd ${app_user} &>>${log_file}
  fi
  func_stat_check $?

  func_print_head "Create app directory"
  rm -rf /app &>>${log_file}
  mkdir /app &>>${log_file}
  func_stat_check $?

  func_print_head "Download app content"
  curl -o /tmp/${component}.zip https://roboshop-artifacts.s3.amazonaws.com/${component}.zip &>>${log_file}
  func_stat_check $?

  func_print_head "Unzip app content"
  cd /app &>>${log_file}
  unzip /tmp/${component}.zip &>>${log_file}
  func_stat_check $?
}

func_systemd_setup() {
  func_print_head "Copy ${component} service file"
  cp ${script_path}/${component}.service /etc/systemd/system/${component}.service &>>${log_file}
  func_stat_check $?

  func_print_head "start ${component}"
  systemctl daemon-reload &>>${log_file}
  systemctl enable ${component} &>>${log_file}
  systemctl restart ${component} &>>${log_file}
  func_stat_check $?
}

func_nodejs() {
  func_print_head "Enable nodejs:18"
  dnf module disable nodejs -y &>>${log_file}
  dnf module enable nodejs:18 -y &>>${log_file}
  func_stat_check $?

  func_print_head "Install nodejs"
  dnf install nodejs -y &>>${log_file}
  func_stat_check $?

  func_app_prereq

  func_print_head "Download nodejs dependencies"
  cd /app &>>${log_file}
  npm install &>>${log_file}
  func_stat_check $?

  func_schema_setup

  func_systemd_setup
}

func_java() {
  func_print_head "Install maven"
  dnf install maven -y &>>${log_file}
  func_stat_check $?

  func_app_prereq

  func_print_head "Install maven dependencies"
  cd /app &>>${log_file}
  mvn clean package &>>${log_file}
  func_stat_check $?

  func_print_head "Move ${component} jar file"
  mv target/${component}-1.0.jar ${component}.jar &>>${log_file}
  func_stat_check $?

 func_schema_setup

 func_systemd_setup
}

func_python() {
  func_print_head "Install python"
  dnf install python36 gcc python3-devel -y &>>${log_file}
  func_stat_check $?

  func_app_prereq

  func_print_head "Install python dependencies"
  cd /app &>>${log_file}
  pip3.6 install -r requirements.txt &>>${log_file}
  func_stat_check $?

  func_print_head "Update Passwords in System Service file"
  sed -i -e "s|rabbitmq_appuser_password|${rabbitmq_appuser_password}|" ${script_path}/${component}.service &>>${log_file}
  func_stat_check $?

  func_systemd_setup
}

func_golang() {
  func_print_head "Install golang"
  dnf install golang -y &>>${log_file}
  func_stat_check $?

  func_app_prereq

  func_print_head "Install golang dependencies"
  cd /app &>>${log_file}
  go mod init dispatch &>>${log_file}
  go get &>>${log_file}
  go build &>>${log_file}
  func_stat_check $?

  func_systemd_setup
}