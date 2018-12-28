#!/bin/bash

echo 'start tomcat...'
opengrok-deploy $OPENGROK_INSTANCE_BASE/lib/source.war $OPENGROK_TOMCAT_BASE/webapps/$WEBAPP_NAME.war
rm -rf $OPENGROK_TOMCAT_BASE/webapps/$WEBAPP_NAME
catalina.sh start

echo 'index projects...'
opengrok-indexer -a $OPENGROK_INSTANCE_BASE/lib/opengrok.jar -- -c /usr/local/bin/ctags -s $SRC_ROOT -d $DATA_ROOT -H -P -S -G -W $OPENGROK_INSTANCE_BASE/etc/configuration.xml -U http://localhost:8080/$WEBAPP_NAME

echo 'watch project updates...'
TIMEOUT=10
inotifywait -e attrib,create,modify,delete -mr $SRC_ROOT | while true; do
    capture=""
    while read -t $TIMEOUT line; do
        capture="$capture$line\n"
    done
    if [ -n "$capture" ]; then
        date
        echo -e $capture
        opengrok-indexer -a $OPENGROK_INSTANCE_BASE/lib/opengrok.jar -- -c /usr/local/bin/ctags -s $SRC_ROOT -d $DATA_ROOT -H -P -S -G -W $OPENGROK_INSTANCE_BASE/etc/configuration.xml -U http://localhost:8080/$WEBAPP_NAME
    fi
done
