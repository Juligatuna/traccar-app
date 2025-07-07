FROM openjdk:17-jdk-slim
WORKDIR /opt/traccar

# Install system dependencies
RUN apt-get update && apt-get install -y wget unzip && rm -rf /var/lib/apt/lists/*

# Download and extract tracker-server.jar from Traccar .zip installer (v6.7.3)
RUN wget -O traccar.zip https://github.com/traccar/traccar/releases/download/v6.7.3/traccar-linux-64-6.7.3.zip && \
    unzip traccar.zip -d /opt && \
    mv /opt/traccar-*/tracker-server.jar /opt/traccar/tracker-server.jar && \
    test -f /opt/traccar/tracker-server.jar || (echo "❌ tracker-server.jar not found!" && exit 1)

# Create runtime directories and set permissions
RUN mkdir -p /opt/traccar/conf /opt/traccar/logs /opt/traccar/data && \
    chmod -R 755 /opt/traccar/logs /opt/traccar/data

# Add configuration file
COPY conf/traccar.xml /opt/traccar/conf/traccar.xml
RUN chmod 644 /opt/traccar/conf/traccar.xml

# Expose Traccar web interface port
EXPOSE 8082

# Start Traccar server
CMD ["java", "-Xms512m", "-Xmx768m", "-XX:MaxDirectMemorySize=256m", "-XX:+UseG1GC", "-Djava.net.preferIPv4Stack=true", "-Dtraccar.config=/opt/traccar/conf/traccar.xml", "-jar", "/opt/traccar/tracker-server.jar"]

