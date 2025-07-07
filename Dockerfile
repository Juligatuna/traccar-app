FROM traccar/traccar:6.7
WORKDIR /opt/traccar
COPY conf/traccar.xml /opt/traccar/conf/traccar.xml
RUN chmod 644 /opt/traccar/conf/traccar.xml
EXPOSE 8082
CMD ["/usr/lib/jvm/java-11-openjdk-amd64/bin/java", "-Xms512m", "-Xmx768m", "-XX:MaxDirectMemorySize=256m", "-XX:+UseG1GC", "-Djava.net.preferIPv4Stack=true", "-Dtraccar.web.address=0.0.0.0", "-Dtraccar.web.port=8082", "-jar", "tracker-server.jar", "conf/traccar.xml"]
