FROM alpine:latest
RUN apk update && apk add bash socat
ADD run.sh /usr/local/bin/run
RUN chmod +x /usr/local/bin/run
ADD *.pem ./

ENV PORT=2375
ENV SSL_CA=ca.pem
ENV SSL_CERT=cert.pem
ENV SSL_KEY=key.pem

EXPOSE 2375
ENTRYPOINT ["/usr/local/bin/run"]
