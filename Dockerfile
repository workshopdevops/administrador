FROM httpd:2.4
COPY ./administrador/ /usr/local/apache2/htdocs/
#CMD ["/usr/sbin/apache2", "-D", "FOREGROUND"]
