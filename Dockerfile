# 'Version: 20210828.01'

FROM alpine:latest

RUN apk --no-cache update
RUN apk --no-cache add apache2
COPY files/index.html /var/www/localhost/htdocs/
CMD  [ "/usr/sbin/httpd", "-D", "FOREGROUND"]
EXPOSE 80/tcp
