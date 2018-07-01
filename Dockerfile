FROM node:alpine

COPY . /usr/src/hello-jenkins
WORKDIR /usr/src/hello-jenkins

RUN npm install

CMD ["npm", "start"]

EXPOSE 3000