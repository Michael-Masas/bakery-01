#!/usr/bin/env bash

which nginx &> /dev/null
if [[ $? -eq 0 ]]; then
  read -p "nginx is already installed. Would you like to uninstall it? [y/n]" user_answer
  if [[ $user_answer == "y" ]]; then
    echo "Uninstalling nginx..."
    systemctl stop nginx.service
    systemctl disable nginx.service
    userdel -r nginx
    rm -rf /etc/nginx
    rm -rf /var/log/nginx
    rm -rf /var/cache/nginx/
    rm -rf /usr/lib/systemd/system/nginx.service
    yum erase -y nginx
  elif [[ $user_answer == "n" ]]; then
    echo "Goodbye"
  else
    echo "Invalid answer was given. Exiting..."
  fi    
else
  read -p "nginx is not installed. Would you like to install it? [y/n]" user_answer
  if [[ $user_answer == "y" ]]; then
    echo "Installing nginx..."
    yum install -y epel-release nginx && echo "nginx installed successfully"
    systemctl enable nginx && echo "nginx will start on boot"
    systemctl start nginx && echo "nginx is running."
  elif [[ $user_answer == "n" ]]; then
    echo "Goodbye"
  else
    echo "Invalid answer was given. Exiting..."
  fi
fi
