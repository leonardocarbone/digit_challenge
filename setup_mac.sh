#!/bin/bash

cd /tmp
mkdir jenkins_backup
chmod 777 jenkins_backup

if [ ! -f "jenkins.bkp.tar.gz" ]
then
   sudo curl -O https://s3.amazonaws.com/testdigit/jenkins.bkp.tar.gz
   sudo mv jenkins.bkp.tar.gz jenkins_backup/
fi   

if [ ! -f "Dockerfile" ]
then
   sudo curl -O https://s3.amazonaws.com/testdigit/Dockerfile
fi   

if [ ! -f "tasks.py" ]
then
   sudo curl -O https://s3.amazonaws.com/testdigit/tasks.py
fi   

if [ ! -f "entrypoint.py" ]
then
   sudo curl -O https://s3.amazonaws.com/testdigit/entrypoint.sh   
   sudo chmod +x entrypoint.sh
fi   

sudo docker build --rm -t jenkins-test-digit .
sudo docker run -v /tmp/jenkins_backup:/jenkins_backup -p 8080:8080 --rm --name jenkins-test-digit jenkins-test-digit 'invoke restore_run jenkins.bkp.tar.gz'
