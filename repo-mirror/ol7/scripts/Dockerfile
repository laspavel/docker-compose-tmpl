FROM oraclelinux:7.9
COPY mirroring.sh /root/mirroring.sh
RUN mkdir -p /d01 && yum install oracle-epel-release-el7 -y && yum install createrepo yum-utils -y && yum install -y https://repo.zabbix.com/zabbix/6.0/rhel/7/x86_64/zabbix-release-latest.el7.noarch.rpm && yum-config-manager --add-repo=https://download.docker.com/linux/centos/docker-ce.repo
VOLUME ["/d01"]
ENTRYPOINT ["/root/mirroring.sh"]