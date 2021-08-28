# 'Version: 20210828.06'

FROM alpine:latest

RUN apk update && apk --no-cache add apache2 && rm -rf /var/cache/apk/*
COPY files/index.html /var/www/localhost/htdocs/
CMD  [ "/usr/sbin/httpd", "-D", "FOREGROUND"]
EXPOSE 80/tcp
