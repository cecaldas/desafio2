FROM registry.access.redhat.com/ubi8:8.0

RUN yum install -y --disableplugin=subscription-manager --nodocs nginx 
RUN yum clean all

ADD index.html /usr/share/nginx/html
ADD nginxconf.sed /tmp/

RUN whoami 
RUN sed -i -f /tmp/nginxconf.sed /etc/nginx/nginx.conf

RUN touch /run/nginx.pid 
RUN chgrp -R 0 /var/log/nginx /run/nginx.pid 
RUN chmod -R g+rwx /var/log/nginx /run/nginx.pid
  
EXPOSE 8080
USER 1001

CMD nginx -g "daemon off;"