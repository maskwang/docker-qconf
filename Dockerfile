FROM phusion/baseimage:0.9.19

MAINTAINER Mask Wang, mask.wang.cn@gmail.com

# Ensure UTF-8
RUN locale-gen en_US.UTF-8
ENV LANG       en_US.UTF-8
ENV LC_ALL     en_US.UTF-8

ENV HOME /root

# enable ssh
RUN rm -f /etc/service/sshd/down
RUN /etc/my_init.d/00_regen_ssh_host_keys.sh

# Enabling the insecure key permanently
RUN /usr/sbin/enable_insecure_key

CMD ["/sbin/my_init"]

# Replace APT Source
ADD build/sources.list /tmp/sources.list
RUN mv /tmp/sources.list /etc/apt/sources.list

# Nginx-PHP Installation
RUN apt-get update
RUN DEBIAN_FRONTEND="noninteractive" apt-get install -y vim curl wget build-essential python-software-properties\
 cmake telnet nmap

RUN wget https://github.com/Qihoo360/QConf/archive/1.2.0.tar.gz && \
	tar zxvf  QConf-1.2.0.tar.gz && \
	cd QConf-1.2.0 && \
	mkdir build && cd build && \
	cmake .. && make && make install && \
	cd /usr/local/qconf/./bin/ && bash agent-cmd.sh start
