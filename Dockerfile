FROM traccar/traccar:6.7
WORKDIR /opt/traccar
COPY conf/traccar.xml /opt/traccar/conf/
RUN chmod 644 /opt/traccar/conf/traccar.xml
EXPOSE 8082
ENTRYPOINT ["java"]
CMD ["-Xms512m", "-Xmx768m", "-jar", "tracker-server.jar", "conf/traccar.xml"]
