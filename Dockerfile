FROM tomcat:9.0
MAINTAINER kobtea

RUN apt-get update && \
    apt-get install -y git inotify-tools autoconf pkg-config make gcc python3 python3-pip
RUN git clone --depth 1 https://github.com/universal-ctags/ctags.git /tmp/ctags
WORKDIR /tmp/ctags
RUN bash autogen.sh && \
    bash configure && \
    make && \
    make install

RUN mkdir -p /var/opengrok/src /var/opengrok/data /var/opengrok/etc
RUN wget -O - https://github.com/OpenGrok/OpenGrok/releases/download/1.1/opengrok-1.1.tar.gz | tar xvzf - --directory=/var/opengrok --strip-components=1
RUN python3 -m pip install /var/opengrok/tools/opengrok-tools.tar.gz

ENV OPENGROK_TOMCAT_BASE /usr/local/tomcat
ENV OPENGROK_INSTANCE_BASE /var/opengrok
ENV SRC_ROOT $OPENGROK_INSTANCE_BASE/src
ENV DATA_ROOT $OPENGROK_INSTANCE_BASE/data
ENV WEBAPP_NAME source

RUN opengrok-indexer -a /var/opengrok/lib/opengrok.jar -- -s /var/opengrok/src -d /var/opengrok/data -W /var/opengrok/etc/configuration.xml

ADD run.sh /usr/local/bin/run
CMD ["/usr/local/bin/run"]

EXPOSE 8080
