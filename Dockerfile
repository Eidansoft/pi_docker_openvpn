FROM debian

LABEL maintainer="http://alejandro.lorente.info"

ENV EASY_RSA_VERSION 3.0.4
ENV USER_NAME alex

# RUN groupadd -g 999 $USER_NAME && \
    # useradd -r -u 999 -g $USER_NAME $USER_NAME

RUN apt-get update && \
    apt-get install -y openssl openvpn nano

WORKDIR /mnt

# RUN chmod ugo+w /etc/openvpn/
# RUN chown $USER_NAME:$USER_NAME /mnt

COPY EasyRSA-${EASY_RSA_VERSION}.tgz /opt
COPY openvpn_server.conf /etc/openvpn/server.conf
COPY openvpn_client.conf /opt
COPY ca_conf.properties /opt
COPY bin/openvpn_common_functions.sh /usr/bin
COPY bin/openvpn_ca_init.sh /usr/bin
COPY bin/openvpn_server_init.sh /usr/bin
COPY bin/openvpn_client_init.sh /usr/bin
COPY bin/openvpn_run.sh /usr/bin

RUN tar xvf /opt/EasyRSA-${EASY_RSA_VERSION}.tgz --directory /opt && \
    cp /opt/ca_conf.properties /opt/EasyRSA-${EASY_RSA_VERSION}/vars && \
    ln -s /opt/EasyRSA-${EASY_RSA_VERSION} /opt/EasyRSA && \
    chmod ugo+w /opt/EasyRSA/vars

ENV PATH="/opt/EasyRSA-3.0.4:${PATH}"

EXPOSE 11911/udp

# USER $USER_NAME

#CMD startX.sh
