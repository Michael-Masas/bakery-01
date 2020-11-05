#!/bin/bash
echo "removing old docker"
yum -y remove docker \
                  docker-client \
                  docker-client-latest \
                  docker-common \
                  docker-latest \
                  docker-latest-logrotate \
                  docker-logrotate \
                  docker-engine \
		  docker-ce \
		  docker-ce-cli \
		  containerd.io \

echo "installing new docker"
yum install -y yum-utils
yum-config-manager \
    --add-repo \
    https://download.docker.com/linux/centos/docker-ce.repo;
yum install -y docker-ce docker-ce-cli containerd.io
sudo usermod -aG docker $USER
echo "enable docker startup"
systemctl enable docker
echo "starting docker" 
systemctl start docker 

echo "add jenkins configurations"
sudo groupadd --system jenkins
sudo useradd -s /sbin/nologin --system -g jenkins jenkins
sudo usermod -aG docker jenkins
docker pull jenkins/jenkins:lts
sudo mkdir /var/jenkins
sudo chown -R 1000:1000 /var/jenkins
sudo touch /etc/systemd/system/jenkins-docker.service
sudo echo "[Unit]
Description=Jenkins Server
Documentation=https://jenkins.io/doc/
After=docker.service
Requires=docker.service

[Service]
Type=simple
User=jenkins
Group=jenkins
TimeoutStartSec=0
Restart=on-failure
RestartSec=30s
ExecStartPre=-/usr/bin/docker kill jenkins-server
ExecStartPre=-/usr/bin/docker rm jenkins-server
ExecStartPre=/usr/bin/docker pull jenkins/jenkins:lts
ExecStart=/usr/bin/docker run \
          --name jenkins-server \
          --publish 8080:8080 \
          --publish 50000:50000 \
          --volume /var/jenkins:/var/jenkins_home \
          jenkins/jenkins:lts
SyslogIdentifier=jenkins
ExecStop=/usr/bin/docker stop jenkins-server

[Install]
WantedBy=multi-user.target" > /etc/systemd/system/jenkins-docker.service

systemctl daemon-reload
systemctl start jenkins-docker

