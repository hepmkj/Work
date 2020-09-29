ARG PROJECT_ID=iaas-gcr-reg-prd-ad3d
ARG GCR=us.gcr.io
FROM ${GCR}/${PROJECT_ID}/usdn:v2

USER root
COPY ${SUPERVISOR_CONF} /etc/supervisor/

WORKDIR /app

RUN rm -f /app/address-standardization-service.jar
ADD ${JAR_FILE} /app/address-standardization-service.jar
RUN chmod 777 /app

RUN chown root:root /usr/bin/sudo && chmod 4755 /usr/bin/sudo

EXPOSE 8080
CMD ["/usr/bin/supervisord", "-c", "/etc/supervisor/supervisord.conf"]
USER ${USER}

