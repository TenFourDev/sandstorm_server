FROM gameservermanagers/steamcmd:latest

ENV SERVER_DIR=/home/steam/server

WORKDIR ${SERVER_DIR}

EXPOSE 27103
EXPOSE 27132

COPY install_and_start.sh /install_and_start.sh
RUN chmod +x /install_and_start.sh

ENTRYPOINT ["/install_and_start.sh"]