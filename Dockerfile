FROM traccar/traccar:6.7

# Copy config and startup script
WORKDIR /opt/traccar
COPY conf/traccar.xml ./conf/
COPY start.sh ./
RUN chmod 644 ./conf/traccar.xml && \
    chmod +x ./start.sh

# Health check
HEALTHCHECK --interval=30s --timeout=3s \
  CMD curl -f http://localhost:8082 || exit 1

# Use shell script as entrypoint
ENTRYPOINT ["/bin/sh", "./start.sh"]
