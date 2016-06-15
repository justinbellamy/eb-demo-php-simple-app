FROM ubuntu:14.04

# Install dependencies
RUN apt-get update -y
RUN apt-get install -y \
        curl \
        git-core \
        apache2 \
        apache2-bin \
        php5 \
        libapache2-mod-php5 \
        php5-pgsql \
        php5-mcrypt \
        php5-mysql \
        php5-memcache \
        php5-memcached \
        php5-curl \
        postgresql-client \
        libpq-dev \
        php-pear \
        libmemcached-dev \
        libcurl4-openssl-dev

# Install composer
RUN curl -sS https://getcomposer.org/installer | php
RUN mv composer.phar /usr/bin/composer

# Install app
RUN rm -rf /var/www/*
ADD . /var/www
RUN  cd /var/www && /usr/bin/composer install

# Configure apache
RUN a2enmod rewrite
RUN chown -R www-data:www-data /var/www
ADD apache.conf /etc/apache2/sites-available/default
ENV APACHE_RUN_USER www-data
ENV APACHE_RUN_GROUP www-data
ENV APACHE_LOG_DIR /var/log/apache2
ENV APACHE_LOCK_DIR /var/lock/apache2
ENV APACHE_PID_FILE /var/run/apache2.pid

EXPOSE 80

CMD ["/usr/sbin/apache2ctl", "-D",  "FOREGROUND"]
