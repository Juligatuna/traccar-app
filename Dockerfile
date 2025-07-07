FROM openjdk:17-jdk-slim
WORKDIR /opt/traccar

# Install system dependencies
RUN apt-get update && apt-get install -y wget unzip && rm -rf /var/lib/apt/lists/*

# Download Traccar .run installer and extract tracker-server.jar
RUN wget -O traccar.run https://github.com/traccar/traccar/releases/download/v6.3/traccar-linux-64-6.3.run && \
    chmod +x traccar.run && \
    ./traccar.run --target /opt/traccar --noexec && \
    mv /opt/traccar/traccar-*/tracker-server.jar /opt/traccar/tracker-server.jar && \
    test -f /opt/traccar/tracker-server.jar || (echo "Error: tracker-server.jar not found" && exit 1)

# Set up runtime directories and permissions
RUN mkdir -p /opt/traccar/conf /opt/traccar/logs /opt/traccar/data && \
    chmod -R 755 /opt/traccar/logs /opt/traccar/data

# Copy configuration file into the image
COPY conf/traccar.xml /opt/traccar/conf/traccar.xml
RUN chmod 644 /opt/traccar/conf/traccar.xml

# Expose Traccar's web port
EXPOSE 8082

# Start the Traccar server
CMD ["java", "-Xms512m", "-Xmx768m", "-XX:MaxDirectMemorySize=256m", "-XX:+UseG1GC", "-Djava.net.preferIPv4Stack=true", "-Dtraccar.config=/opt/traccar/conf/traccar.xml", "-jar", "/opt/traccar/tracker-server.jar"]

