DESAFIO 2

O projeto layers-size é uma aplicação web que exibe uma página no Browser.
O repositório de código fonte está na seguinte URL:
https://dev.azure.com/vibedesenvolvimento/Red%20Hat/_git/ex288-dockerfile-layers
Para o projeto, o service account ex288sa foi criado.
A imagem gerada não deve ter mais que 290 MB.

A aplicação deve estar disponível na seguinte URL:
http://layers-size-web-app.apps.ocp.desenv.com/index.html 
Deve exibir a seguinte mensagem: "Hello, world from nginx v3-v4-v5!"


COMO RESOLVER A QUESTÃO:

Projeto no openshift já existe

necessário customizar o Dockerfile para cortar instruções desnecessárias e dimuir o número de camadas.

Necessário clonar o projeto e construir a imagem para ver o tamanho que gera. exemplo:

podman build -t nginx-ex288:1.0 .
depois fazer "podman images" para ver o tamanho.

Necessário aninhar os comandos "RUN" e "ADD" de modo que o tamanho da imagem diminua, gerando novas imagens 
localmente com o podman build, até que o tamanho atenda a questão. 
depois disso, você pode comitar suas alterações e gerar um build.

service account já existe (ex288sa)

Associar o service account ao projeto:
oc adm policy add-scc-to-user SCC -z ex288sa
oc set serviceaccount deployment/[DEPLOYMENT NAME] ex288sa
Iniciar um build a partir do commit.

Testar sua aplicação.



Um outro exemplo para praticar:

oc new-app --name gitlab --image quay.io/redhattraining/gitlab-ce:8.4.3-ce.0

oc create sa gitlab-sa

 oc adm policy add-scc-to-user anyuid -z gitlab-sa

 #DOCKERFILE

FROM registry.access.redhat.com/ubi8/ubi:8.0 1

MAINTAINER Red Hat Training <training@redhat.com>

# DocumentRoot for Apache
ENV DOCROOT=/var/www/html 2

RUN   yum install -y --no-docs --disableplugin=subscription-manager httpd && \ 3
      yum clean all --disableplugin=subscription-manager -y && \
      echo "Hello from the httpd-parent container!" > ${DOCROOT}/index.html

# Allows child images to inject their own content into DocumentRoot
ONBUILD COPY src/ ${DOCROOT}/ 4

EXPOSE 80

# This stuff is needed to ensure a clean start
RUN rm -rf /run/httpd && mkdir /run/httpd

# Run as the root user
USER 1001

# Launch httpd
CMD /usr/sbin/httpd -DFOREGROUND