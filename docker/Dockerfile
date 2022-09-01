FROM alpine:3

RUN apk add --no-cache bash openssh postgresql-client

RUN addgroup -S app

RUN adduser -S -D -h /home/app app app

RUN chown -R app:app /home/app

ADD start.sh /home/app/start.sh
RUN chmod +x /home/app/start.sh
RUN chown app:app /home/app/start.sh

USER app
WORKDIR /home/app

CMD bash -x /home/app/start.sh

