FROM tomcat:8.0
MAINTAINER kobtea

RUN apt-get update && \
    apt-get install -y exuberant-ctags git inotify-tools
RUN mkdir -p /var/opengrok/src /var/opengrok/data
RUN wget -O - https://github.com/OpenGrok/OpenGrok/files/213268/opengrok-0.12.1.5.tar.gz | tar xvzf - --directory=/var/opengrok --strip-components=1

ENV OPENGROK_TOMCAT_BASE /usr/local/tomcat
ENV OPENGROK_INSTANCE_BASE /var/opengrok
ENV SRC_ROOT $OPENGROK_INSTANCE_BASE/src
ENV SKIN='-L default'
ENV WEBAPP_NAME source

RUN /var/opengrok/bin/OpenGrok update
RUN /var/opengrok/bin/OpenGrok deploy

ADD run.sh /usr/local/bin/run
CMD ["/usr/local/bin/run"]

EXPOSE 8080
