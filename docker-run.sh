docker run -it --name mag2 -v /data/docker/varwwwhtml:/usr/html -v ./config/etc-nginx/nginx.conf:/etc/nginx/nginx.conf -v ./config/etc-nginx/server.conf:/etc/nginx/server.conf -p 801:80 alpine-php
