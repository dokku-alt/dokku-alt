FROM ubuntu:quantal
MAINTAINER progrium "progrium@gmail.com"

RUN mkdir /build
ADD ./stack/ /build
RUN /build/prepare
RUN apt-get update && apt-get install -y libicu-dev
RUN apt-get install -y sudo
RUN apt-get install -y supervisor
