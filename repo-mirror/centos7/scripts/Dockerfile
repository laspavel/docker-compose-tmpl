FROM centos:7.9.2009
COPY mirroring.sh /root/mirroring.sh
RUN mkdir -p /d01 && yum install epel-release -y && yum install createrepo yum-utils -y
VOLUME ["/d01"]
ENTRYPOINT ["/root/mirroring.sh"]