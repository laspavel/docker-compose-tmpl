#!/bin/bash

yum install oracle-epel-release-el7 -y
yum install nginx -y
systemctl start nginx
systemctl enable nginx
systemctl status nginx
firewall-cmd --zone=public --permanent --add-service=http
firewall-cmd --reload
yum install createrepo  yum-utils -y

