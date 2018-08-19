FROM alpine:latest

LABEL maintainer="http://alejandro.lorente.info"

COPY openvpn_server.conf /etc/openvpn/server.conf
COPY openvpn_client.conf /tmp
COPY ca_conf.properties /tmp
COPY bin/openvpn_common_functions.sh /usr/bin
COPY bin/openvpn_ca_init.sh /usr/bin
COPY bin/openvpn_server_init.sh /usr/bin
COPY bin/openvpn_client_init.sh /usr/bin
COPY bin/openvpn_run.sh /usr/bin

RUN echo "http://dl-cdn.alpinelinux.org/alpine/edge/testing/" >> /etc/apk/repositories && \
    apk add --update openvpn iptables bash easy-rsa nano && \
    ln -s /usr/share/easy-rsa/easyrsa /usr/local/bin && \
    rm -rf /var/tmp/* /var/cache/apk/* /var/cache/distfiles/* && \
    ln -s /usr/share/easy-rsa/openssl-easyrsa.cnf /usr/local/bin/openssl-easyrsa.cnf && \
    ln -s /usr/share/easy-rsa/x509-types /usr/local/bin/
    # cp /tmp/ca_conf.properties /etc/easy-rsa/vars

WORKDIR /mnt

ENV SVR_NAME svr

CMD openvpn_run.sh $SVR_NAME
