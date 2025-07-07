FROM openjdk:17-jdk-slim
WORKDIR /
RUN apt-get update && apt-get install -y wget unzip && rm -rf /var/lib/apt/lists/*
RUN wget -O traccar.zip https://github.com/traccar/traccar/releases/download/v6.7.3/traccar-linux-64-6.7.3.zip && \
    unzip -o traccar.zip -d /opt/traccar && \
    find /opt/traccar -type f -name "tracker-server.jar" -exec mv {} /opt/traccar/tracker-server.jar \; && \
    test -f /opt/traccar/tracker-server.jar || { echo "Error: tracker-server.jar not found"; exit 1; } && \
    rm -rf traccar.zip /opt/traccar/traccar-*
RUN mkdir -p /opt/traccar/conf /opt/traccar/logs /opt/traccar/data && \
    chmod -R 755 /opt/traccar/logs /opt/traccar/data
COPY conf/traccar.xml /opt/traccar/conf/traccar.xml
RUN chmod 644 /opt/traccar/conf/traccar.xml && \
    chmod +x /opt/traccar/tracker-server.jar
EXPOSE 8082
CMD ["java", "-Xms512m", "-Xmx768m", "-XX:MaxDirectMemorySize=256m", "-XX:+UseG1GC", "-Djava.net.preferIPv4Stack=true", "-Dtraccar.web.address=0.0.0.0", "-Dtraccar.web.port=8082", "-jar", "/opt/traccar/tracker-server.jar", "conf/traccar.xml"]
