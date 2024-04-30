#!/bin/bash

LOCAL_REPOS="ol8_baseos_latest ol8_appstream ol8_UEKR7 ol8_developer_EPEL ol8_developer_EPEL_modular docker-ce-stable"
LOCAL_REPOS_FULL="squid zabbix zabbix-non-supported zabbix-agent2-plugins"
for REPO in ${LOCAL_REPOS}; do
mkdir -p /d01/ol/8/$REPO
reposync --download-metadata --security --bugfix --arch=x86_64 --refresh --repoid=$REPO -p /d01/ol/8
reposync --download-metadata --security --bugfix --arch=noarch --refresh --repoid=$REPO -p /d01/ol/8
# rm -f $(repomanage --old --space --keep 5 /d01/ol/8/$REPO)
rpm --import /etc/pki/rpm-gpg/*
done
for REPO in ${LOCAL_REPOS_FULL}; do
mkdir -p /d01/ol/8/$REPO
reposync --download-metadata --security --bugfix --refresh --arch=x86_64 --repoid=$REPO -p /d01/ol/8
reposync --download-metadata --security --bugfix --refresh --arch=noarch --repoid=$REPO -p /d01/ol/8
rpm --import /etc/pki/rpm-gpg/*
done
cp -f /etc/pki/rpm-gpg/RPM-GPG-KEY-oracle /d01/ol/8/RPM-GPG-KEY-oracle-ol8
