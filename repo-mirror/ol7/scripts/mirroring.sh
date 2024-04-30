#!/bin/bash
yum repoinfo

LOCAL_REPOS="ol7_latest ol7_UEKR5 ol7_UEKR6 ol7_developer_EPEL zabbix zabbix-non-supported zabbix-agent2-plugins docker-ce-stable"
for REPO in ${LOCAL_REPOS}; do
  mkdir -p /d01/ol/7/$REPO
  reposync --gpgcheck --plugins --repoid=$REPO --download_path=/d01/ol/7 --downloadcomps --download-metadata 
  if [ "$REPO" == "ol7_latest" ] || [ "$REPO" == "ol7_developer_EPEL" ]; then
    createrepo --verbose /d01/ol/7/$REPO -g /d01/ol/7/$REPO/comps.xml 
  else
    createrepo --verbose /d01/ol/7/$REPO
  fi
  yum list-sec
  mv /var/cache/yum/x86_64/7Server/$REPO/gen/updateinfo.xml /d01/ol/7/$REPO/repodata/updateinfo.xml
  modifyrepo /d01/ol/7/$REPO/repodata/updateinfo.xml /d01/ol/7/$REPO/repodata
  rpm --import /etc/pki/rpm-gpg/*
done
cp -f /etc/pki/rpm-gpg/RPM-GPG-KEY-oracle /d01/ol/7/RPM-GPG-KEY-oracle-ol7
