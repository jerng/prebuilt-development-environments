FROM ubuntu:latest 
  # 14.04.1 tested

#FROM phusion/baseimage:latest 
  # 0.9.15 testing

MAINTAINER Yang Jerng HWA
ENV PATH /usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/

RUN apt-get update && apt-get install -y wget
RUN wget -O - http://dl.hhvm.com/conf/hhvm.gpg.key | apt-key add - && \
    echo deb http://dl.hhvm.com/ubuntu trusty main | tee /etc/apt/sources.list.d/hhvm.list && \
    apt-get update && \
    apt-get install -y hhvm
RUN apt-get install -y nginx libgmp-dev && \
    /usr/share/hhvm/install_fastcgi.sh && \
    /etc/init.d/hhvm restart && \
    /etc/init.d/nginx restart


# copy/paste hhvm installation success message:
#********************************************************************
#* HHVM is installed.
#* 
#* Running PHP web scripts with HHVM is done by having your webserver talk to HHVM
#* over FastCGI. Install nginx or Apache, and then:
#* $ sudo /usr/share/hhvm/install_fastcgi.sh
#* $ sudo /etc/init.d/hhvm restart
#* (if using nginx)  $ sudo /etc/init.d/nginx restart
#* (if using apache) $ sudo /etc/init.d/apache restart
#* 
#* Detailed FastCGI directions are online at:
#* https://github.com/facebook/hhvm/wiki/FastCGI
#* 
#* If you're using HHVM to run web scripts, you probably want it to start at boot:
#* $ sudo update-rc.d hhvm defaults
#* 
#* Running command-line scripts with HHVM requires no special setup:
#* $ hhvm whatever.php
#* 
#* You can use HHVM for /usr/bin/php even if you have php-cli installed:
#* $ sudo /usr/bin/update-alternatives --install /usr/bin/php php /usr/bin/hhvm 60
#********************************************************************
