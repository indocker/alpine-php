FROM dockerindo/alpine
LABEL maintainer "wid" architecture="AMD64/x86_64"

RUN echo '172.17.0.2 mysql' >> /etc/hosts

ADD https://php.codecasts.rocks/php-alpine.rsa.pub /etc/apk/keys/php-alpine.rsa.pub
RUN echo "@php http://php.codecasts.rocks/v3.6/php-7.0" >> /etc/apk/repositories
RUN apk update && \
    apk add bash less vim nginx ca-certificates git tzdata zip
RUN apk add php7@php php7-fpm@php php7-json@php php7-zlib@php php7-xml@php php7-pdo@php php7-openssl@php \
    php7-pdo_mysql@php php7-mysqli@php php7-session@php php7-soap@php php7-mysqlnd@php \
    php7-gd@php php7-iconv@php php7-mcrypt@php php7-zip@php php7-common@php \
    php7-curl@php php7-opcache@php php7-phar@php \ 
    php7-intl@php php7-bcmath@php php7-dom@php php7-mbstring@php php7-xmlreader@php mysql-client curl && apk add -u musl && \
    ln -s /usr/bin/php7 /usr/bin/php && rm -rf /var/cache/apk/*

RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/bin --filename=composer

RUN sed -i 's/;cgi.fix_pathinfo=1/cgi.fix_pathinfo=0/g' /etc/php7/php.ini && \
    sed -i 's/expose_php = On/expose_php = Off/g' /etc/php7/php.ini && \
    sed -i "s/nginx:x:100:101:nginx:\/var\/lib\/nginx:\/sbin\/nologin/nginx:x:100:101:nginx:\/usr:\/bin\/bash/g" /etc/passwd && \
    sed -i "s/nginx:x:100:101:nginx:\/var\/lib\/nginx:\/sbin\/nologin/nginx:x:100:101:nginx:\/usr:\/bin\/bash/g" /etc/passwd- && \
    ln -s /sbin/php-fpm7 /sbin/php-fpm

ADD config/nginx.conf /etc/nginx/
ADD config/server.conf /etc/nginx/
ADD config/php-fpm.conf /etc/php7/
ADD run.sh /
RUN chmod +x /run.sh

EXPOSE 80

CMD ["/run.sh"]
