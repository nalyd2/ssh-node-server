FROM node:buster-slim

#RUN mkdir -p /home/node/app/node_modules && chown -R node:node /home/node/app



#WORKDIR /home/node/app
WORKDIR /app


COPY package*.json ./
#ssh
RUN apt-get update && apt-get install -y supervisor && apt-get install -y openssh-server && echo "root:Docker!" | chpasswd 
RUN apt-get install nano
RUN mkdir -p /var/log/supervisor /run/sshd

COPY sshd_config /etc/ssh/
ADD supervisord.conf /etc/supervisord.conf
COPY docker-entrypoint.sh /usr/local/bin/

RUN chmod -R +x /usr/local/bin

#USER node

RUN npm install

COPY . .

EXPOSE 8080
EXPOSE 2222


ENTRYPOINT ["docker-entrypoint.sh"]
CMD ["supervisord", "--nodaemon", "--configuration", "/etc/supervisord.conf"]
#CMD [ "node", "app.js", "supervisord", "--nodaemon", "--configuration", "/etc/supervisord.conf"]