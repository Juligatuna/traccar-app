#!/bin/sh
exec /usr/lib/jvm/java-11-openjdk-amd64/bin/java \
    -Xms512m \
    -Xmx768m \
    -Dtraccar.web.port=8082 \
    -Dtraccar.web.address=0.0.0.0 \
    -jar /opt/traccar/tracker-server.jar \
    /opt/traccar/conf/traccar.xml
