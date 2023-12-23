app_user=roboshop

func_print_head() {
   echo -e "\e[36m>>>>>>>>>>>>>>>>>>>>>> $1 <<<<<<<<<<<<<<<<<<<<<<\e[0m"
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
  curl -o /tmp/catalogue.zip https://roboshop-artifacts.s3.amazonaws.com/catalogue.zip
  cd /app

  func_print_head "Unzip app content"
  unzip /tmp/catalogue.zip

  func_print_head "Download nodejs dependencie"s
  cd /app
  npm install

  func_print_head "Copy catalogue service file"
  cp ${script_path}/catalogue.service /etc/systemd/system/catalogue.service

  func_print_head "Start Catalogue"
  systemctl daemon-reload
  systemctl enable catalogue
  systemctl restart catalogue

}