#!/bin/bash

#Install docker

sudo yum update -y 
sudo yum install -y yum-utils device-mapper-persistent-data lvm2
sudo yum-config-manager --add-repo https://download.docker.com/linux/centos/docker-ce.repo
echo "Installing docker"
sudo yum install -y docker-ce docker-ce-cli containerd.io
sudo systemctl enable docker
sudo systemctl start docker

sudo systemctl is-active --quiet docker && echo Docker is running

#Install java

echo "Installing java"
sudo yum install -y java-1.8.0-openjdk

export JAVA_HOME=/usr/bin/java
sudo cp /etc/environment /etc/environment-bku
sudo chmod 777 /etc/environment
echo "export JAVA_HOME=/usr/bin/java" >> /etc/environment
source /etc/environment
sudo chmod 755 /etc/environment

##Install wget
which wget > /dev/null 2>&1
if [[ $? -eq 1 ]]; then
        sudo yum install -y wget
else
        echo "wget installed"
fi

sudo wget -O /etc/yum.repos.d/jenkins.repo https://pkg.jenkins.io/redhat-stable/jenkins.repo
sudo rpm --import https://pkg.jenkins.io/redhat-stable/jenkins.io.key

#Install jenkins
echo "Installing jenkins"
sudo yum install -y jenkins
sudo systemctl enable jenkins
sudo systemctl start jenkins

sudo systemctl is-active --quiet jenkins && echo Jenkins is running

#sudo grep -A 5 password /var/log/jenkins/jenkins.log
