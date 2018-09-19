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
    apk add --update openvpn iptables bash easy-rsa && \
    ln -s /usr/share/easy-rsa/easyrsa /usr/local/bin && \
    rm -rf /var/tmp/* /var/cache/apk/* /var/cache/distfiles/* && \
    ln -s /usr/share/easy-rsa/openssl-easyrsa.cnf /usr/local/bin/openssl-easyrsa.cnf && \
    ln -s /usr/share/easy-rsa/x509-types /usr/local/bin/


ENV SVR_NAME svr

# Add the notifications dependencies and code
COPY pi_notifications/rabbit_producer_basic.py /usr/bin
COPY pi_notifications/log_watchdog.sh /usr/bin
RUN apk add --update python3 && \
    pip3 install pika && \
    rm -rf /var/tmp/* /var/cache/apk/* /var/cache/distfiles/*

ENV RABBIT_HOSTNAME not_configured

WORKDIR /mnt

CMD if [ "$RABBIT_HOSTNAME" = "not_configured" ]; then \
        openvpn_run.sh $SVR_NAME ;\
    else \
        openvpn_run.sh $SVR_NAME | log_watchdog.sh "TLS Error" "rabbit_producer_basic.py --host $RABBIT_HOSTNAME --exchange openvpn_notifications --message \"Security ERROR: \$line\"" ;\
    fi
