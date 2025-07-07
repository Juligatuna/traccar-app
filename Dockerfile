FROM openjdk:17-jdk-slim
WORKDIR /
RUN apt-get update && apt-get install -y wget unzip && rm -rf /var/lib/apt/lists/*
RUN wget -O traccar.zip https://github.com/traccar/traccar/releases/download/v6.7.3/traccar-linux-64-6.7.3.zip && \
    unzip -o traccar.zip -d /opt/traccar && \
    echo "Listing ZIP contents:" && \
    find /opt/traccar -type f && \
    mv /opt/traccar/traccar.run /opt/traccar/traccar.run && \
    chmod +x /opt/traccar/traccar.run
RUN mkdir -p /opt/traccar/conf /opt/traccar/logs /opt/traccar/data && \
    chmod -R 755 /opt/traccar/logs /opt/traccar/data
COPY conf/traccar.xml /opt/traccar/conf/traccar.xml
RUN chmod 644 /opt/traccar/conf/traccar.xml
EXPOSE 8082
CMD ["sh", "-c", "/opt/traccar/traccar.run conf/traccar.xml"]
