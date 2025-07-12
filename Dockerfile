FROM traccar/traccar:6.7
WORKDIR /opt/traccar
COPY --chmod=644 conf/traccar.xml /opt/traccar/conf/
HEALTHCHECK --interval=30s --timeout=3s CMD java -version || exit 1
ENTRYPOINT ["/bin/sh", "-c"]
CMD ["exec java -Xms512m -Xmx768m -jar tracker-server.jar conf/traccar.xml"]
