FROM ubuntu/nginx:1.18-22.04_beta
    #
    #   https://hub.docker.com/r/ubuntu/nginx
    #   Long-term support by Canonical. Note, there is a 20.04 LTS version, so
    #   we are taking a bit of a gamble with 22.04

RUN apt update -y && \
    apt install -y \
        wget \
        software-properties-common && \
        rm -rf /var/lib/apt/lists/*

#   https://serverfault.com/questions/1058374/is-the-ppaondrej-php-repository-safe

RUN add-apt-repository -y ppa:ondrej/php && \
    add-apt-repository -y ppa:ondrej/nginx-mainline && \

    #   ... if you are manually stepping through, consider here :
    #   apt-cache showpkg php OR mariadb-server ETC 

    apt update -y && \
    apt install -y \
        php8.1=8.1.5-1+ubuntu22.04.1+deb.sury.org+1.1 \ 
        mariadb-server=1:10.6.7-2ubuntu1 \
        mariadb-client=1:10.6.7-2ubuntu1  

    # cleanup :

     # rm -rf /var/lib/apt/lists/*

    # INSTALL COMPOSER
    # INSTALL cake php https://book.cakephp.org/4/en/installation.html


# HARDENING

 # https://www.vultr.com/docs/installing-configuring-and-securing-php-8-1-on-ubuntu-20-04/

 # https://howtogetonline.com/how-to-harden-your-php-for-better-security.php

 # https://php.watch/articles/composer-security-hardening

 # https://computingforgeeks.com/how-to-install-mariadb-on-ubuntu-focal-fossa/
 # https://www.tecmint.com/mysql-mariadb-security-best-practices-for-linux/


#MYSQL_ROOT_PASSWORD=password
#
#MYSQL_DATABASE=my_app
#
#MYSQL_USER=my_user
#
#MYSQL_PASSWORD=password


# for future upgrades to docker-composer :
# https://www.cakedc.com/rochamarcelo/2020/07/20/a-quick-cakephp-local-environment-with-docker
