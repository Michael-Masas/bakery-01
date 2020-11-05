#!/usr/bin/bash
$1=rpm -q
$2=bool
if [[ $1 && $2  ]]
then
    echo "$1 installed"
    sudo  yum -y autoremove
else
        sudo yum -y install nginx
        sudo service nginx start
        sudo systemctl enable nginx
fi
