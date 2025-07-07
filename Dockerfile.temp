FROM openjdk:17-jdk-slim
WORKDIR /opt/traccar

# Force rebuild: July 7
# Install system dependencies
RUN apt-get update && apt-get install -y wget unzip && rm -rf /var/lib/apt/lists/*

# Download and extract tracker-server.jar from .run installer
RUN wget -O traccar.run https://github.com/traccar/traccar/releases/download/v6.3/traccar-linux-64-6.3.run && \
    chmod +x traccar.run && \
    ./traccar.run --target /opt/traccar --noexec && \
    echo "📁 Contents of /opt/traccar after extraction:" && \
    ls -l /opt/traccar && \
    echo "🔍 Searching for tracker-server.jar:" && \
    find /opt/traccar -name "tracker-server.jar" || (echo "❌ tracker-server.jar not found!" && exit 1)

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

