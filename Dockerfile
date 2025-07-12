FROM traccar/traccar:6.7

# Verify Java works immediately
RUN /usr/lib/jvm/java-11-openjdk-amd64/bin/java -version

# Setup environment
WORKDIR /opt/traccar
COPY conf/traccar.xml ./conf/
RUN chmod 644 ./conf/traccar.xml

# Health check
HEALTHCHECK --interval=30s --timeout=3s \
  CMD curl -f http://localhost:8082 || exit 1

# ENTRYPOINT solution (prevents Railway misinterpretation)
ENTRYPOINT ["/usr/lib/jvm/java-11-openjdk-amd64/bin/java"]
CMD [
    "-Xms512m",
    "-Xmx768m",
    "-Dtraccar.web.port=8082",
    "-Dtraccar.web.address=0.0.0.0",
    "-jar",
    "tracker-server.jar",
    "conf/traccar.xml"
]
