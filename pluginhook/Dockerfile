FROM ubuntu:13.10

MAINTAINER Kamil Trzciński <ayufan@ayufan.eu>

RUN apt-get update
RUN apt-get install -y curl gcc make g++ build-essential ca-certificates mercurial

RUN curl https://go.googlecode.com/files/go1.2.1.linux-amd64.tar.gz | tar -C / -xz

ENV PATH $PATH:/go/bin:/gocode/bin
ENV GOPATH /gocode
ENV GOROOT /go

ADD . /gocode
WORKDIR /gocode

RUN go get code.google.com/p/go.crypto/ssh/terminal
RUN go build -o pluginhook
RUN GOOS=linux go build -o pluginhook.linux
