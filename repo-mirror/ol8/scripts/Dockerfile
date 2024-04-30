FROM oraclelinux:8.9
COPY mirroring.sh /root/mirroring.sh
COPY ngtech-squid.repo /etc//yum.repos.d/ngtech-squid.repo
RUN mkdir -p /d01 && yum install epel-release -y && yum install -y dnf-utils && dnf install -y https://repo.zabbix.com/zabbix/6.0/rhel/8/x86_64/zabbix-release-latest.el8.noarch.rpm && dnf config-manager --add-repo=https://download.docker.com/linux/centos/docker-ce.repo && dnf repoinfo
VOLUME ["/d01"]
ENTRYPOINT ["/root/mirroring.sh"]