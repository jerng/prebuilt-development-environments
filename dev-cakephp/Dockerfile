# try : 
#
#           docker build --name dev-cakephp . 
#           docker run -d --name dev-cakephp -p 8080:80 -e \
#               TZ=Asia/Kuala_Lumpur or TZ=UTC \
#               dev-cakephp
# 
#   Access your Nginx server at http://localhost:8080.
#
#   2022-05-03 : poor success, so not included : 
#       If you develop frequently, consider package caching proxies such as 
#       (apt-cacher-ng) and (velocita-proxy)
#
#       Possibly less complex, with higher probability of success :
#       or (apt-mirror) and (https://github.com/Webysther/packagist-mirror)

FROM ubuntu/nginx:1.18-22.04_beta
    #
    #   https://hub.docker.com/r/ubuntu/nginx
    #   Long-term support by Canonical. Note, there is a 20.04 LTS version, so
    #   we are taking a bit of a gamble with 22.04

# Install (generalist packages, supporting installation, not development) :

RUN apt update -y && \
    apt install -y \
        wget \
        software-properties-common && \
    apt autoremove && \
    apt clean && \
    rm -rf /var/lib/apt/lists/*

    #   apt autoremove && \
    #       removes dependencies whose dependents were already removed
    #
    #   apt clean && \
    #       removes all installation files


#   Install (php) and (mariadb) :
#
#   https://serverfault.com/questions/1058374/is-the-ppaondrej-php-repository-safe

RUN add-apt-repository -y ppa:ondrej/php && \
    add-apt-repository -y ppa:ondrej/nginx-mainline && \
    apt update -y && \
    apt install -y \
        php8.1-fpm=8.1.5-1+ubuntu22.04.1+deb.sury.org+1.1 \ 
        zip \
        unzip \
        php-zip \
        php-intl \ 
        php-xml \ 
        php-mbstring \ 
        php-sqlite3 \ 
        php-mysql \ 
        mariadb-server=1:10.6.7-2ubuntu1 \
        mariadb-client=1:10.6.7-2ubuntu1 && \
    apt autoremove && \
    apt clean && \
    rm -rf /var/lib/apt/lists/*

    #   You can use (apt-cache showpkg PACKAGENAME) to see detailed versions;
    #
    #        php8.1-fpm=8.1.5-1+ubuntu22.04.1+deb.sury.org+1.1 \ 
    #            # nginx uses this; if you install
    #            #   php8.1=8.1.5-1+ubuntu22.04.1+deb.sury.org+1.1
    #            #   it installs (apache2) as well
    #        zip \
    #        unzip \
    #        php-zip \
    #            # composer may benefit from this
    #        php-intl \ 
    #        php-xml \ 
    #        php-mbstring \ 
    #            # cakephp needs this
    #        php-sqlite3 \ 
    #            # cakephp's debug_kit needs this
    #        php-mysql \ 
    #            # nginx needs this
    #        mariadb-server=1:10.6.7-2ubuntu1 \
    #        mariadb-client=1:10.6.7-2ubuntu1 && \

# Install (composer) :

RUN php -r "copy('https://getcomposer.org/installer', \
        'composer-setup.php');" && \
    php -r "if (hash_file('sha384', 'composer-setup.php') === \
        '55ce33d7678c5a611085589f1f3ddf8b3c52d662cd01d4ba75c0ee0459970c2200a51f492d557530c71c15d8dba01eae') \
        { echo 'Installer verified'; } else \
        { echo 'Installer corrupt'; unlink('composer-setup.php'); } \
        echo PHP_EOL;" && \
    php composer-setup.php && \
    php -r "unlink('composer-setup.php');" && \
    mv composer.phar /usr/local/bin/composer && \
    composer clear-cache && \
    rm -rf ~/.composer/cache/*

# Create (cakephp app "a_skeleton_app") :

RUN composer create-project --no-interaction --prefer-dist \
        cakephp/app=4.3.2 a_skeleton_app && \
    composer clear-cache && \
    rm -rf ~/.composer/cache/* && \
    chmod -R u+rwX,go+rX,go-w /a_skeleton_app && \
    chown -R www-data:www-data /a_skeleton_app/tmp /a_skeleton_app/logs

# Matching (the created cakephp app) create a directory, 
#   which is used in the subsequently set nginx configuration :

#   TODO :
#       https://www.dereuromark.de/2021/05/27/nginx-setup-for-your-cakephp-apps/
#       UPGRADE DOCKERFILE TO PRODUCTION CONFIGURATION NEXT

RUN mkdir /run/php && \
    echo ' \n\
        server { \n\
         \n\
             listen 80;  \n\
             listen [::]:80; \n\
             root /a_skeleton_app/webroot; \n\
             index index.php; \n\
             access_log /var/log/nginx/access.log; \n\
             error_log /var/log/nginx/error.log; \n\
         \n\
             location / { \n\
                     try_files $uri $uri/ /index.php?$args; \n\
             } \n\
         \n\
              location ~ \.php$ { \n\
                     include snippets/fastcgi-php.conf; \n\
                     include fastcgi_params; \n\
                     proxy_intercept_errors on; \n\
                     fastcgi_pass unix:/run/php/php8.1-fpm.sock; \n\
                     fastcgi_param SCRIPT_FILENAME $document_root$fastcgi_script_name; \n\
             } \n\
         \n\
        } \n\
        ' > /etc/nginx/sites-available/default 

# Matching (the created cakephp app) create MariaDB 
#   user, password, database, and permissions :

RUN /etc/init.d/mariadb start && \
    mysqladmin -u root password secret && \
    mysql --user=root --password=secret \
        --execute='\
CREATE USER my_app@localhost IDENTIFIED BY "secret";\
CREATE DATABASE my_app;\
GRANT ALL PRIVILEGES ON my_app.* TO my_app@localhost;\
'

ENTRYPOINT  nginx && \
            /etc/init.d/mariadb start && \
            php-fpm8.1 -F 
                # foreground, to preven docker from terminating the container 

# HARDENING
 
    # https://serverfault.com/questions/888653/correct-web-user-for-php-fpm-under-nginx
    
    # https://www.vultr.com/docs/installing-configuring-and-securing-php-8-1-on-ubuntu-20-04/
    
    # https://howtogetonline.com/how-to-harden-your-php-for-better-security.php
    
    # https://php.watch/articles/composer-security-hardening
    
    # https://computingforgeeks.com/how-to-install-mariadb-on-ubuntu-focal-fossa/
    # https://www.tecmint.com/mysql-mariadb-security-best-practices-for-linux/

# TODO

    # for future upgrades to docker-composer :
    # https://www.cakedc.com/rochamarcelo/2020/07/20/a-quick-cakephp-local-environment-with-docker
