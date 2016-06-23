#!/bin/bash

echo 'start tomcat...'
mv $OPENGROK_TOMCAT_BASE/webapps/source.war $OPENGROK_TOMCAT_BASE/webapps/$WEBAPP_NAME.war
rm -rf $OPENGROK_TOMCAT_BASE/webapps/$WEBAPP_NAME
catalina.sh start

echo 'index projects...'
$OPENGROK_INSTANCE_BASE/bin/OpenGrok index

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
        $OPENGROK_INSTANCE_BASE/bin/OpenGrok index
    fi
done
