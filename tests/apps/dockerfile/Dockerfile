FROM ubuntu:trusty
MAINTAINER Kamil Trzciński <ayufan@ayufan.eu>

RUN apt-get update
RUN apt-get install -y nginx

ADD / /app

EXPOSE 80
CMD ["nginx", "-c", "/app/nginx.conf"]
