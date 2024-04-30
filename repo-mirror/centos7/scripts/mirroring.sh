#!/bin/bash

LOCAL_REPOS="base centosplus epel extras updates"
for REPO in ${LOCAL_REPOS}; do
mkdir -p /d01/centos/7/$REPO
# reposync -g -l -d -m --repoid=$REPO --newest-only --download-metadata --download_path=/d01/centos/7/
reposync -g -l -d -m --repoid=$REPO --download-metadata --arch=x86_64 --download_path=/d01/centos/7/
createrepo /d01/centos/7/$REPO/
rpm --import /etc/pki/rpm-gpg/*
done
cp -f /etc/pki/rpm-gpg/RPM-GPG-KEY-CentOS-7 /d01/centos/7/RPM-GPG-KEY-CentOS-7