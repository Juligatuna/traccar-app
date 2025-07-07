FROM openjdk:17-jdk-slim
WORKDIR /opt/traccar

# Install requirements
RUN apt-get update && apt-get install -y wget unzip && rm -rf /var/lib/apt/lists/*

# Download the .run installer and extract the jar
RUN wget -O traccar.run https://github.com/traccar/traccar/releases/download/v6.3/traccar-linux-64-6.3.run && \
    chmod +x traccar.run && \
    ./traccar.run --target /opt/traccar --noexec && \
    test -f /opt/traccar/tracker-server.jar || (echo "Error: tracker-server.jar not found" && exit 1)

# Prepare directories
RUN mkdir -p /opt/traccar/conf /opt/traccar/logs /opt/traccar/data && \
    chmod -R 755 /opt/traccar/logs /opt/traccar/data

# Copy config
COPY conf/traccar.xml /opt/traccar/conf/traccar.xml
RUN chmod 644 /opt/traccar/conf/traccar.xml

EXPOSE 8082

CMD ["java", "-Xms512m", "-Xmx768m", "-XX:MaxDirectMemorySize=256m", "-XX:+UseG1GC", "-Djava.net.preferIPv4Stack=true", "-Dtraccar.config=/opt/traccar/conf/traccar.xml", "-jar", "/opt/traccar/tracker-server.jar"]

