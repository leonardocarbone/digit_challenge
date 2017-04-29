FROM centos:7
MAINTAINER Leonardo Z Carbone <leonardoz.carbone@gmail.com>

WORKDIR /tmp

USER root

# Prepare for Systemd and install libs
RUN (cd /lib/systemd/system/sysinit.target.wants/; for i in *; do [ $i == \
    systemd-tmpfiles-setup.service ] || rm -f $i; done); \
    rm -f /lib/systemd/system/multi-user.target.wants/*;\
    rm -f /etc/systemd/system/*.wants/*;\
    rm -f /lib/systemd/system/local-fs.target.wants/*; \
    rm -f /lib/systemd/system/sockets.target.wants/*udev*; \
    rm -f /lib/systemd/system/sockets.target.wants/*initctl*; \
    rm -f /lib/systemd/system/basic.target.wants/*;\
    rm -f /lib/systemd/system/anaconda.target.wants/*;\
    yum -y update; \
    yum -y install sudo; \
    yum -y install which; \
    yum -y install wget; \
    yum -y install telnet; \
    yum -y install initscripts; \
    yum -y install libtool-ltdl; \
    curl "https://bootstrap.pypa.io/get-pip.py" -o "get-pip.py"; \
    python get-pip.py; \
    pip install invoke==0.12.2; \
    pip install jenkinsapi;

RUN wget --no-cookies --no-check-certificate --header "Cookie: gpw_e24=http%3A%2F%2Fwww.oracle.com%2F; oraclelicense=accept-securebackup-cookie" "http://download.oracle.com/otn-pub/java/jdk/8u60-b27/jdk-8u60-linux-x64.rpm"; \
    rpm -Uhv jdk-8u60-linux-x64.rpm;

RUN wget https://pkg.jenkins.io/redhat/jenkins-2.9-1.1.noarch.rpm; \
    rpm -Uhv jenkins-2.9-1.1.noarch.rpm; \
    echo 'jenkins ALL=(ALL) NOPASSWD: ALL' >> /etc/sudoers; 

RUN  sudo mkdir /jenkins_backup; \
     sudo chown -R jenkins /jenkins_backup;

EXPOSE 8080

ADD entrypoint.sh tasks.py /

VOLUME [ "/sys/fs/cgroup" ]

ENTRYPOINT ["/entrypoint.sh"]