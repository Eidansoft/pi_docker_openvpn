FROM openvpnserver:latest

LABEL maintainer="http://alejandro.lorente.info"

COPY pi_notifications/rabbit_producer_basic.py /usr/bin
COPY pi_notifications/log_watchdog.sh /usr/bin

RUN apk add --update python3 && \
    pip3 install pika && \
    ln -s /usr/bin/python3 /usr/bin/python && \
    rm -rf /var/tmp/* /var/cache/apk/* /var/cache/distfiles/*

ENV RABBIT_HOSTNAME rabbit
ENV RABBIT_USER guest
ENV RABBIT_PW guest
ENV RABBIT_EXCHANGE openvpn_notifications

WORKDIR /mnt

CMD openvpn_run.sh $SVR_NAME | \
    log_watchdog.sh "TLS Error" \
    "rabbit_producer_basic.py --host $RABBIT_HOSTNAME --exchange $RABBIT_EXCHANGE --user $RABBIT_USER --pw $RABBIT_PW --message \"OpenVPN Security ERROR: \$line\"" | \
    log_watchdog.sh "Peer Connection Initiated" \
    "rabbit_producer_basic.py --host $RABBIT_HOSTNAME --exchange $RABBIT_EXCHANGE --user $RABBIT_USER --pw $RABBIT_PW --message \"OpenVPN New connection: \$line\""