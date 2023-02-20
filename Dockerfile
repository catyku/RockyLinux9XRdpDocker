# https://github.com/danchitnis/container-xrdp

FROM rockylinux:9.1

RUN yum -y update

RUN yum -y install epel-release
#RUN yum -y reinstall glibc-locale-source glibc-langpack-en glib-langpack-zh glibc-common kde-l10n-Chinese

RUN yum -y groupinstall Fonts

#RUN localedef -c -f UTF-8 -i zh_TW zh_TW.utf8

#ENV TZ="Asia/Taipei"
#ENV LANG=zh_TW.UTF8
#ENV LANGUAGE=zh_TW

RUN yum -y groupinstall xfce base-x

RUN bash -c 'echo PREFERRED=/usr/bin/xfce4-session > /etc/sysconfig/desktop'

RUN yum install -y xrdp xorgxrdp firefox git

RUN yum -y install sudo nload passwd nano gedit

RUN yum -y  install ibus ibus-libpinyin  ibus-table-chinese-cangjie 

#RUN timedatectl set-timezone Asia/Taipei
#RUN localectl set-locale LANG=zh_TW.utf8


COPY ./build/xrdp.ini /etc/xrdp/

COPY ./build/centos8-sesman.ini /etc/xrdp/
RUN mv /etc/xrdp/centos8-sesman.ini /etc/xrdp/sesman.ini

COPY ./build/startwm-xfce.sh /etc/xrdp/
RUN mv /etc/xrdp/startwm-xfce.sh /etc/xrdp/startwm.sh

RUN chmod a+x /etc/xrdp/startwm.sh

COPY ./build/xsessionrc /

COPY ./build/run.sh /
RUN chmod +x /run.sh

EXPOSE 3389

ENTRYPOINT ["/run.sh"]
