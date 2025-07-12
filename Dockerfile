FROM traccar/traccar:6.7

# Mandatory declarations
EXPOSE 8082
ENV PORT=8082

WORKDIR /opt/traccar
COPY conf/traccar.xml ./conf/
RUN chmod 644 ./conf/traccar.xml

CMD java \
    -Xms512m \
    -Xmx768m \
    -Dtraccar.web.port=$PORT \
    -Dtraccar.web.address=0.0.0.0 \
    -jar tracker-server.jar \
    conf/traccar.xml
