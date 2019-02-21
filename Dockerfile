FROM node as builder
RUN npm install -g bower gulp grunt
RUN npm install -g grunt-cli bower yo generator-karma generator-angular
RUN apt update
RUN apt install -y ruby-compass
RUN apt install -y nginx

COPY app  app
COPY app/scripts/docker.app.config.js app/scripts/app.config.js
COPY bower.json bower.json
COPY  Gruntfile.js Gruntfile.js
COPY package.json package.json

RUN bower --allow-root install
RUN npm install
# CMD grunt serve
RUN grunt build

FROM nginx


RUN mkdir -p /usr/share/nginx/html/
COPY --from=builder dist/  /usr/share/nginx/html/
#cat  /etc/nginx/sites-enabled/default


COPY default /etc/nginx/sites-enabled/default

CMD ["nginx", "-g", "daemon off;"]
