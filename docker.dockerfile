FROM ubuntu:latest

# Instale apache, PHP e programas complementares.
RUN apt-get update && apt-get -y upgrade && DEBIAN_FRONTEND=noninteractive apt-get -y install \
    apache2 php7.0 php7.0-mysql libapache2-mod-php7.0 curl lynx-cur

# Ative mods do apache.
RUN a2enmod php7.0
RUN a2enmod rewrite

# Atualize o arquivo PHP.ini
RUN sed -i "s/short_open_tag = Off/short_open_tag = On/" /etc/php/7.0/apache2/php.ini
RUN sed -i "s/error_reporting = .*$/error_reporting = E_ERROR | E_WARNING | E_PARSE/" /etc/php/7.0/apache2/php.ini

# Configure manualmente as variáveis ​​de ambiente apache
ENV APACHE_RUN_USER www-data
ENV APACHE_RUN_GROUP www-data
ENV APACHE_LOG_DIR /var/log/apache2
ENV APACHE_LOCK_DIR /var/lock/apache2
ENV APACHE_PID_FILE /var/run/apache2.pid

# Exponha o apache.
EXPOSE 8080

# Copie este repositório no lugar.
ADD www /var/www/site

# Atualize o site apache padrão com a configuração que criamos.
ADD apache-config.conf /etc/apache2/sites-enabled/000-default.conf

# Por padrão, inicie o apache em primeiro plano, substitua por / bin / bash para interative.
CMD /usr/sbin/apache2ctl -D FOREGROUND