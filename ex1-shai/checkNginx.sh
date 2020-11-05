#!/bin/bash

which nginx > /dev/null 2>&1
if [[ $? -eq 1 ]]; then	
    echo "Nginx is not currently installed on Linux, Begins installation."
    sudo yum install -y nginx
    sudo useradd --no-create-home nginx
    sudo systemctl enable nginx
    sudo systemctl start nginx
    sudo systemctl is-active --quiet nginx && echo Nginx is running
else
    echo "Nginx already installed"
    echo "Did you interested in uninstall it? select the option that you prefer[Y/N]"
    read answer
    if [[ $answer = "Y" ]]; then
        echo "Start remove nginx."
        sudo systemctl stop nginx
        sudo systemctl disable nginx
        sudo userdel -r nginx
        
        sudo rm -rf /etc/nginx
        sudo rm -rf /var/log/nginx
        sudo rm -rf /var/cache/nginx/
        sudo rm -rf /usr/lib/systemd/system/nginx.servic

        sudo yum remove -y nginx
    elif [[ $answer = "N" ]]; then
        echo "nginx has not been deleted"
    else
        echo "User chose invalid character...."
    fi
fi
