FROM alpine:3.17.1

RUN apk add --no-cache \
    bash       \
    curl       \
    ipvsadm    \
    iproute2   \
    keepalived 
RUN mkdir /etc/keepalived
# COPY ./keepalived.conf /etc/keepalived/keepalived.conf
LABEL org.label-schema.schema-version="1.0"
LABEL org.label-schema.name="keppalived In Swarm"
LABEL maintainer="JSM <juliosejas98@gmail.com>"


COPY ./goLeader /etc/keepalived/goLeader
COPY ./keepalived.conf /etc/keepalived/keepalived.conf
COPY ./notify.sh /etc/keepalived/notify.sh
COPY ./prepare.sh /
RUN chmod +x /etc/keepalived/notify.sh
RUN chmod +x /prepare.sh
RUN chmod +x /etc/keepalived/goLeader

ENTRYPOINT ["/prepare.sh"]


