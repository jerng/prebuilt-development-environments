FROM debian:latest 
  # 7.7 testing 

MAINTAINER Yang Jerng HWA
ENV PATH /usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/

RUN apt-get update && \
    apt-get install -y openjdk-7-jdk

RUN apt-get install -y wget unzip && \
    wget http://dlc.sun.com.edgesuite.net/glassfish/4.1/release/glassfish-4.1.zip &&\
    unzip glassfish-4.1.zip -d /usr/local/ &&\
    rm glassfish-4.1.zip

# Based on instructions from: https://glassfish.java.net/download.html
#
#  Testing:
#  $ glassfish4/bin/asadmin start-domain
#  $ wget -O - localhost:4848
