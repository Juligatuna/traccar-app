FROM eclipse-temurin:11-jre

# Install dependencies
RUN apt-get update && \
    apt-get install -y wget unzip gettext && \
    rm -rf /var/lib/apt/lists/*

# Download and install Traccar
WORKDIR /opt/traccar
RUN wget -q https://github.com/traccar/traccar/releases/download/v6.0/traccar-other-6.0.zip && \
    unzip traccar-other-6.0.zip && \
    rm traccar-other-6.0.zip && \
    find . -mindepth 1 -maxdepth 1 -type d -exec mv {}/* . \; && \
    wget -q -P lib/ https://repo1.maven.org/maven2/mysql/mysql-connector-java/8.0.28/mysql-connector-java-8.0.28.jar

# Copy configuration
COPY conf/traccar.xml /opt/traccar/conf/
COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

EXPOSE 8082
ENTRYPOINT ["/entrypoint.sh"]
