FROM node:18-alpine

RUN apk add --no-cache bash openssh postgresql-client

RUN mkdir /app

ADD start.sh /home/node/start.sh
RUN chmod +x /home/node/start.sh
RUN chown node:node /home/node/start.sh

CMD /home/node/start.sh

