# syntax=docker/dockerfile:1.3-labs
# 
# ^ The 'syntax' declaration is programmatic, do not remove it.

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

FROM ubuntu/nginx:1.18-20.04_beta
    #
    #   https://hub.docker.com/r/ubuntu/nginx
    #   Long-term support by Canonical. Note, there is a 22.04 LTS version, 
    #   but on cloud image builders, their kernels are not compatible with
    #   MariaDB-10.6.7 so we're going with the older 20.04 for now

# Install (generalist packages, supporting installation, not development) :

RUN <<EOF
apt update -y 
apt install -y  wget \
                software-properties-common 
apt autoremove 
apt clean 
rm -rf /var/lib/apt/lists/*
EOF
    #   apt autoremove && \
    #       removes dependencies whose dependents were already removed
    #
    #   apt clean && \
    #       removes all installation files


#   Install (php) and (mariadb) :
#
#   https://serverfault.com/questions/1058374/is-the-ppaondrej-php-repository-safe

RUN <<EOF
add-apt-repository -y ppa:ondrej/php 
add-apt-repository -y ppa:ondrej/nginx-mainline 
apt update -y 
if ( apt install -y \
        php8.1-fpm=8.1.18-1+ubuntu20.04.1+deb.sury.org+1 \
        zip \
        unzip \
        php8.1-zip \
        php8.1-intl \
        php8.1-xml \
        php8.1-mbstring \
        php8.1-sqlite3 \
        php8.1-mysql \
        mariadb-server=1:10.3.38-0ubuntu0.20.04.1 \
        mariadb-client=1:10.3.38-0ubuntu0.20.04.1 \
    ); \
    then echo 'exited with status 0'; \
    else echo -e "\033[0;31m*** HINT *** \033[1;33m: php8.1-fpm version \
        frequently needs to be updated\033[0m" && exit 2; \
    fi
apt autoremove 
apt clean 
rm -rf /var/lib/apt/lists/*
EOF
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

RUN <<EOF
php -r "copy('https://getcomposer.org/installer', 'composer-setup.php');" 
php -r "if (hash_file('sha384', 'composer-setup.php') === \
    '55ce33d7678c5a611085589f1f3ddf8b3c52d662cd01d4ba75c0ee0459970c2200a51f492d557530c71c15d8dba01eae') \
    { echo 'Installer verified'; } else \
    { echo 'Installer corrupt'; unlink('composer-setup.php'); } \
    echo PHP_EOL;" 
php composer-setup.php 
php -r "unlink('composer-setup.php');" 
mv composer.phar /usr/local/bin/composer 
composer clear-cache 
rm -rf ~/.composer/cache/*
EOF

# Create (cakephp app "a_skeleton_app") :

RUN <<EOF
composer create-project --no-interaction --prefer-dist cakephp/app=4.4.2 a_skeleton_app 
composer clear-cache 
rm -rf ~/.composer/cache/* 
chmod -R u+rwX,go+rX,go-w /a_skeleton_app 
chown -R www-data:www-data /a_skeleton_app/tmp /a_skeleton_app/logs
EOF

# Matching (the created cakephp app) create a directory, 
#   which is used in the subsequently set nginx configuration :
#
#   TODO :
#       https://www.dereuromark.de/2021/05/27/nginx-setup-for-your-cakephp-apps/
#       UPGRADE DOCKERFILE TO PRODUCTION CONFIGURATION NEXT

RUN <<EOF
mkdir /run/php 
echo ' 
    server { 
     
         listen 80;  
         listen [::]:80; 
         root /a_skeleton_app/webroot; 
         index index.php; 
         access_log /var/log/nginx/access.log; 
         error_log /var/log/nginx/error.log; 
     
         location / { 
                 try_files $uri $uri/ /index.php?$args; 
         } 
     
          location ~ \.php$ { 
                 include snippets/fastcgi-php.conf; 
                 include fastcgi_params; 
                 proxy_intercept_errors on; 
                 fastcgi_pass unix:/run/php/php8.1-fpm.sock; 
                 fastcgi_param SCRIPT_FILENAME $document_root$fastcgi_script_name; 
         } 
     
    } 
' > /etc/nginx/sites-available/default 
EOF

# Matching (the created cakephp app) create MariaDB 
#   user, password, database, and permissions :

# Demonstrates the method : (mysql --execute='')

RUN <<EOF
/etc/init.d/mysql start 
mysqladmin -u root password secret 
mysql --user=root --password=secret \
    --execute='\
CREATE USER my_app@localhost IDENTIFIED BY "secret";\
CREATE DATABASE my_app;\
GRANT ALL PRIVILEGES ON my_app.* TO my_app@localhost;\
'
EOF

# TEMPORARY DEV UTLITY 01 - populate database with business ontology, EXAMPLE
# For further reference you may refer to : https://book.cakephp.org/4/en/quickstart.html

# Demonstrates the method : (mysql database_name < script.sql )

RUN <<EOF
echo " 
    USE my_app; 

    CREATE TABLE users ( 
        id INT AUTO_INCREMENT PRIMARY KEY, 
            email VARCHAR(255) NOT NULL, 
                created DATETIME, 
                modified DATETIME
    ); 

    CREATE TABLE custom_field_key_types ( /* select one, select multiple, etc. */
        id INT AUTO_INCREMENT PRIMARY KEY, 
            name VARCHAR(255) NOT NULL, 
        created DATETIME, 
        modified DATETIME
    );

    CREATE TABLE custom_field_keys (
        id INT AUTO_INCREMENT PRIMARY KEY, 
        custom_field_key_type_id INT NOT NULL,
        category_id INT NULL, 
            name VARCHAR(255) NOT NULL, 
        created DATETIME, 
        modified DATETIME
    );

    CREATE TABLE custom_field_key_options (
        id INT AUTO_INCREMENT PRIMARY KEY, 
        custom_field_key_id INT NOT NULL ,
            name VARCHAR(255) NOT NULL, 
        created DATETIME, 
        modified DATETIME
    );

    CREATE TABLE custom_field_data (
        id INT AUTO_INCREMENT PRIMARY KEY, 
        asset_id INT NOT NULL,
        custom_field_key_id INT NOT NULL, 
            custom_field_value TEXT,
        created DATETIME, 
        modified DATETIME,
            FULLTEXT (custom_field_value)
    );

    CREATE TABLE audit_logs (
        id INT AUTO_INCREMENT PRIMARY KEY, 
        user_id INT NOT NULL,
            table_name VARCHAR(255) NOT NULL, /* indexable */
            note TEXT NOT NULL, /* serialised CRUDs */
        created DATETIME, 
        modified DATETIME,
            FULLTEXT (note)
    );

    INSERT INTO custom_field_key_types ( id, name, created, modified ) VALUES
        (1, 'select : max one, min one : e.g. radio button, with default selected', NOW(), NOW()),
        (2, 'select : no max, no min : e.g. multiple select, with no default selection', NOW(), NOW())
        ;

    INSERT INTO custom_field_keys ( id, custom_field_key_type_id, category_id, name, created, modified ) VALUES
        (1,1,3,'geometry', NOW(), NOW())
        ;

    INSERT INTO custom_field_key_options ( id, custom_field_key_id, name, created, modified ) VALUES
        (1,1,'circle', NOW(), NOW()),
        (2,1,'square', NOW(), NOW()),
        (3,1,'triangle', NOW(), NOW())
        ;

    INSERT INTO custom_field_data ( id, asset_id, custom_field_key_id,
    custom_field_value, created, modified ) VALUES
        (1, 2, 1, 'this value doesn\'t match any of the options in the database,\
        but guess what, it won\'t be deleted just because someone changed any of\
        the existing options; it could be further improved by simply storing the\
        custom_field_key_option_id, but that\'s going to require more encoding\
        ... either an extra column in custom_field_key_data or an encoding in\
        custom_field_key_data.custom_field_value', NOW(), NOW())
        ;

" > /a_skeleton_app/tmp/initialise-development.sql 

/etc/init.d/mysql start 
mysql --user=my_app --password=secret my_app < /a_skeleton_app/tmp/initialise-development.sql
EOF

# TEMPORARY DEV UTLITY 02 - generate some basic code, 
# with the PHP MVC development framework, and adjust it, EXAMPLE
#
# For further reference you may watch : https://www.youtube.com/watch?v=xDItuOkLgIg&t=159s

RUN <<EOF
/etc/init.d/mysql start 
/a_skeleton_app/bin/cake bake all Users 
/a_skeleton_app/bin/cake bake all CustomFieldKeyTypes
/a_skeleton_app/bin/cake bake all CustomFieldKeys
/a_skeleton_app/bin/cake bake all CustomFieldKeyOptions
/a_skeleton_app/bin/cake bake all CustomFieldData
/a_skeleton_app/bin/cake bake all AuditLogs
EOF

# TEMPORARY DEV UTLITY 03 - create a landing page for the UI / user-interfaces;
# adjust the default [ (layout) and (homepage) ] with a link to the landing page

RUN <<EOF
echo " 
    <h1>Links to Example Code generated via the Dockerfile :</h1> 
    <i> 
            Here are some [ UI / user-interfaces ] for [ CRUD / create-read-update-delete operations ] on our development [ DB / database ] 
    </i> 
    <hr> 
    <ul> 
            <li><?php echo \$this->Html->link( 'Users', 
                ['controller' => 'Users', 'action' => 'index', '_full' => true], ['class' => 'button'] 
            );?></li> 
            <li><?php echo \$this->Html->link( 'CustomFieldKeyTypes', 
                ['controller' => 'CustomFieldKeyTypes', 'action' => 'index', '_full' => true], ['class' => 'button'] 
            );?></li> 
            <li><?php echo \$this->Html->link( 'CustomFieldKeys', 
                ['controller' => 'CustomFieldKeys', 'action' => 'index', '_full' => true], ['class' => 'button'] 
            );?></li> 
            <li><?php echo \$this->Html->link( 'CustomFieldKeyOptions', 
                ['controller' => 'CustomFieldKeyOptions', 'action' => 'index', '_full' => true], ['class' => 'button'] 
            );?></li> 
            <li><?php echo \$this->Html->link( 'CustomFieldData', 
                ['controller' => 'CustomFieldData', 'action' => 'index', '_full' => true], ['class' => 'button'] 
            );?></li> 
            <li><?php echo \$this->Html->link( 'AuditLogs', 
                ['controller' => 'AuditLogs', 'action' => 'index', '_full' => true], ['class' => 'button'] 
            );?></li> 
    </ul> 
" > /a_skeleton_app/templates/Pages/dev_landing.php 

sed -i "s\
/top-nav-links\">\
/top-nav-links\"><?= \$this->Html->link('[Demo Landing Page]','pages\/dev-landing') ?>\
/" /a_skeleton_app/templates/layout/default.php 
    
sed -i "s\
/container text-center\">\
/container text-center\">\
\n<h2>Go to the :\
    <?= \$this->Html->link('[Demo Landing Page]','pages\/dev-landing') ?>\
<\/h2>\
\n<hr>\
/" /a_skeleton_app/templates/Pages/home.php

EOF

ENTRYPOINT  nginx && \
            /etc/init.d/mysql start && \
            echo -e "\n\ 
***** \n\ 
***** \033[1;33mHELLO !! If you remap the container's port 80 to the host's port 8080, \n\033[0m\
*****  \033[1;33m then you can browse this : http://localhost:8080 \n\033[0m\
***** \n\
" && \
            php-fpm8.1 -F 
                # foreground, to prevent docker from terminating the container 

EXPOSE 80/tcp

# TODO

    # 2022-05-04 AWS CodeBuild -> ECR -> Fargate gets this error on the CakePHP hello world page
        # probably need to ssh in and poke around to see if sqlite3 is working, pdo-sqlite, etc.
        #
        #   DebugKit is not able to connect to the database. The datasource configuration "debug_kit" was not found.

    # for future upgrades to docker-composer :
    # https://www.cakedc.com/rochamarcelo/2020/07/20/a-quick-cakephp-local-environment-with-docker

    # HARDENING
 
        # https://serverfault.com/questions/888653/correct-web-user-for-php-fpm-under-nginx
        
        # https://www.vultr.com/docs/installing-configuring-and-securing-php-8-1-on-ubuntu-20-04/
        
        # https://howtogetonline.com/how-to-harden-your-php-for-better-security.php
        
        # https://php.watch/articles/composer-security-hardening
        
        # https://computingforgeeks.com/how-to-install-mariadb-on-ubuntu-focal-fossa/
        # https://www.tecmint.com/mysql-mariadb-security-best-practices-for-linux/

