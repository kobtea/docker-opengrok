FROM universalctags/ctags-docker AS ctags

FROM tomcat:9.0-alpine
COPY --from=ctags /usr/local/bin/uctags /usr/local/bin/ctags
RUN apk --update --no-cache add jansson yaml libxml2 git inotify-tools python3
RUN mkdir -p /var/opengrok/src /var/opengrok/data /var/opengrok/etc
SHELL ["/bin/bash", "-o", "pipefail", "-c"]
RUN wget -O - https://github.com/OpenGrok/OpenGrok/releases/download/1.2.6/opengrok-1.2.6.tar.gz | tar xvzf - --directory=/var/opengrok --strip-components=1
RUN python3 -m pip install /var/opengrok/tools/opengrok-tools.tar.gz

ENV OPENGROK_TOMCAT_BASE /usr/local/tomcat
ENV OPENGROK_INSTANCE_BASE /var/opengrok
ENV SRC_ROOT $OPENGROK_INSTANCE_BASE/src
ENV DATA_ROOT $OPENGROK_INSTANCE_BASE/data
ENV WEBAPP_NAME source

RUN opengrok-indexer -a /var/opengrok/lib/opengrok.jar -- -s /var/opengrok/src -d /var/opengrok/data -W /var/opengrok/etc/configuration.xml

COPY run.sh /usr/local/bin/run
CMD ["/usr/local/bin/run"]

EXPOSE 8080
