FROM debian

LABEL maintainer="http://alejandro.lorente.info"

ENV EASY_RSA_VERSION 3.0.4
ENV USER_NAME alex

RUN groupadd -g 999 $USER_NAME && \
    useradd -r -u 999 -g $USER_NAME $USER_NAME

RUN apt-get update && \
    apt-get install -y openssl openvpn nano

WORKDIR /mnt

RUN chmod ugo+w /etc/openvpn/
RUN chown $USER_NAME:$USER_NAME /mnt

COPY EasyRSA-${EASY_RSA_VERSION}.tgz /opt
COPY ca_conf.properties /opt
COPY common_functions.sh /usr/bin
COPY create_new_ca.sh /usr/bin
COPY create_vpn_svr_authentication.sh /usr/bin
COPY create_new_openvpn_client.sh /usr/bin

RUN tar xvf /opt/EasyRSA-${EASY_RSA_VERSION}.tgz --directory /opt && \
    cp /opt/ca_conf.properties /opt/EasyRSA-${EASY_RSA_VERSION}/vars && \
    ln -s /opt/EasyRSA-${EASY_RSA_VERSION} /opt/EasyRSA && \
    chmod ugo+w /opt/EasyRSA/vars

ENV PATH="/opt/EasyRSA-3.0.4:${PATH}"

USER $USER_NAME


#RUN apt-get update

#    apt-get install -y python3 python3-pip && \
#    pip3 install robotframework docutils robotframework-seleniumlibrary

#CMD startX.sh && robot --outputdir robot_logs $ROBOT_FILE
