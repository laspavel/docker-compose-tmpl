#!/bin/bash

yum install -y dnf-utils
yum install epel-release -y
yum install nginx -y
systemctl start nginx
systemctl enable nginx
systemctl status nginx
firewall-cmd --zone=public --permanent --add-service=http
firewall-cmd --reload
