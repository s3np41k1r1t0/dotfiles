FROM alpine:latest

RUN apk add python3
RUN mkdir /home/test

RUN addgroup -S appgroup && adduser -S test -G appgroup


RUN chown test /home/test
COPY . /home/test/config

USER test
WORKDIR /home/test/config

RUN python3 install.py install linux
