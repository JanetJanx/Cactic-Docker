#===========================
# Dockerfile based on ubuntu latest
#===========================

FROM ubuntu:18.04
LABEL project="Cacti" \
      author="networks" \
      image_name="cacti" 

RUN apt-get update && \
    apt-get upgrade -y

ENV MYSQL_DATABASE=cacti
ENV MYSQL_USER=cactiuser
ENV MYSQL_PASSWORD=cact@13
ENV TZ Africa/Kampala

RUN apt-get update && echo $TZ > /etc/timezone && DEBIAN_FRONTEND=noninteractive apt-get install -yq nginx \
    mysql-server \
    php \ 
    vim \
    openssh-server \
    php7.2-common \
    php7.2-mysql \
    php7.2-gmp \
    php7.2-curl \
    php7.2-intl \
    php7.2-mbstring \ 
    php7.2-xmlrpc \
    php7.2-gd \
    php7.2-bcmath \
    php7.2-snmp \
    php7.2-xml \
    php7.2-cli \
    php7.2-zip \
    php-net-socket \
    php7.2-gd \
    php7.2-intl \
    php-pear \
    php7.2-imap \
    php7.2-memcache \
    php7.2-pspell \ 
    php7.2-recode \
    php7.2-tidy \
    php7.2-xmlrpc \
    php7.2-gettext \ 
    php7.2-gmp \
    php7.2-json \
    spawn-fcgi \ 
    fcgiwrap \
    snmp \
    snmpd \
    snmp-mibs-downloader \ 
    rrdtool \
    cacti \
    cacti-spine 

# All scripts in docker-entrypoint-initdb.d/ are automatically
# executed during container startup
#COPY mydb.sql /docker-entrypoint-initdb.d/mydb.sql
COPY cacti /etc/nginx/sites-available/cacti
COPY debain.php /etc/cacti/debian.php

RUN apt-get update && \
    apt-get upgrade -y

#WORKDIR /usr/share/mysql
#RUN mysql -uroot -p mysql < mysql_test_data_timezone.sql

#WORKDIR /usr/share/cacti/conf_templates
#RUN mysql -uroot -p cacti < cacti.sql 


RUN service nginx restart 
RUN service mysql restart

RUN echo "date.timezone = Africa/Kampala" >> /etc/php/7.2/apache2/php.ini
RUN echo "date.timezone = Africa/Kampala" >> /etc/php/7.2/cli/php.ini
#RUN echo "date.timezone = Africa/Kampala" >> /etc/php/7.2/fpm/php.ini
#mysql -u root -p $MYSQL_PASSWORD > source mydb.sql && mysql -u root -p $MYSQL_PASSWORD cacti < cacti.sql
#path to cact.sql - /usr/share/cacti/conf_templates
# create start up script for nagios service
RUN echo "#!/bin/bash" >> /opt/start.sh
RUN echo "/etc/init.d/mysql start" >> /opt/start.sh
RUN echo "/etc/init.d/fcgiwrap start" >> /opt/start.sh
RUN echo "/etc/init.d/php7.2-fpm start" >> /opt/start.sh
RUN echo "/etc/init.d/nginx start" >> /opt/start.sh
RUN echo "/etc/init.d/snmpd start" >> /opt/start.sh
RUN echo >> /opt/start.sh
RUN chmod +x /opt/start.sh


EXPOSE 80

STOPSIGNAL SIGTERM
