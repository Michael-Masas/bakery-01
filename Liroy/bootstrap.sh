#!/usr/bin/env bash

echo "Updating system"
yum -y update
yum -y install epel-release yum-utils
yum-config-manager \
    --add-repo \
    https://download.docker.com/linux/centos/docker-ce.repo

echo "Installing Docker"
yum -y install docker docker-ce docker-ce-cli containerd.io
which docker
if [[ $? -eq 0 ]]; then
  echo "Docker installation succeeded"
else
  echo "Docker installation failed"
fi

echo "Installing java..."
yum -y install java-1.8.0-openjdk.x86_64
echo "Adding environment variables"
cp /etc/profile /etc/profile_backup 
echo 'export JAVA_HOME=/usr/lib/jvm/jre-1.8.0-openjdk' | sudo tee -a /etc/profile
echo 'export JRE_HOME=/usr/lib/jvm/jre' | sudo tee -a /etc/profile
source /etc/profile
echo "Installing jenkins"
cd ~
which wget
if [[ $? -eq 1 ]]; then
  echo "Installing wget..."
  yum -y install wget
fi
wget -O /etc/yum.repos.d/jenkins.repo https://pkg.jenkins.io/redhat-stable/jenkins.repo
rpm --import https://pkg.jenkins.io/redhat-stable/jenkins.io.key
yum -y install jenkins && echo "Jenkins Installation succeeded"

echo "Goodbye"

