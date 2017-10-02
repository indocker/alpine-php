FROM indocker/alpine
LABEL maintainer "wid" architecture="AMD64/x86_64"

ENV TERM="xterm" \
    DB_HOST="mysql" \
    DB_NAME="mag2" \
    DB_USER="magento"\
    DB_PASS="m4g3nt01"

RUN echo '172.17.0.2 mysql' >> /etc/hosts

RUN apk update && \
    apk add bash less vim nginx ca-certificates git tzdata zip \
    libmcrypt-dev zlib-dev gmp-dev \
    freetype-dev libjpeg-turbo-dev libpng-dev \
    php7-fpm php7-json php7-zlib php7-xml php7-pdo php7-phar php7-openssl \
    php7-pdo_mysql php7-mysqli php7-session php7-soap \
    php7-gd php7-iconv php7-mcrypt php7-gmp php7-zip \
    php7-curl php7-opcache php7-ctype php7-apcu \
    php7-intl php7-bcmath php7-dom php7-mbstring php7-xmlreader mysql-client curl && apk add -u musl && \
    rm -rf /var/cache/apk/*

RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/bin --filename=composer

RUN sed -i 's/;cgi.fix_pathinfo=1/cgi.fix_pathinfo=0/g' /etc/php7/php.ini && \
    sed -i 's/expose_php = On/expose_php = Off/g' /etc/php7/php.ini && \
    sed -i "s/nginx:x:100:101:nginx:\/var\/lib\/nginx:\/sbin\/nologin/nginx:x:100:101:nginx:\/usr:\/bin\/bash/g" /etc/passwd && \
    sed -i "s/nginx:x:100:101:nginx:\/var\/lib\/nginx:\/sbin\/nologin/nginx:x:100:101:nginx:\/usr:\/bin\/bash/g" /etc/passwd- && \
    ln -s /sbin/php-fpm7 /sbin/php-fpm

ADD config/nginx.conf /etc/nginx/
ADD config/php-fpm.conf /etc/php7/
ADD run.sh /
RUN chmod +x /run.sh

EXPOSE 80
VOLUME ["/usr"]

CMD ["/run.sh"]