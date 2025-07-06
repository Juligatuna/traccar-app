FROM openjdk:17-slim-bullseye
WORKDIR /opt/traccar
RUN apt-get update && apt-get install -y wget unzip && \
    apt-get clean && rm -rf /var/lib/apt/lists/*
RUN wget -O traccar.zip https://github.com/traccar/traccar/releases/download/v6.3/traccar-linux-64-6.3.zip && \
    unzip -o traccar.zip && \
    rm traccar.zip
RUN mkdir -p /opt/traccar/conf /opt/traccar/logs /opt/traccar/data && \
    chmod -R 755 /opt/traccar/logs /opt/traccar/data
COPY conf/traccar.xml /opt/traccar/conf/traccar.xml
RUN chmod 644 /opt/traccar/conf/traccar.xml && \
    chmod +x /opt/traccar/tracker-server.jar || echo "Failed to chmod tracker-server.jar"
EXPOSE 8082
ENTRYPOINT ["sh", "-c", "echo 'Starting Traccar' && java $JAVA_OPTS -jar /opt/traccar/tracker-server.jar /opt/traccar/conf/traccar.xml 2>&1 | tee -a /opt/traccar/logs/traccar_start.log"]
