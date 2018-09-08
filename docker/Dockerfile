FROM alpine:latest
LABEL AUTHOR Andre Lammel <andre.lammel@theneglectedmachine.systems>

RUN echo "@testing http://uk.alpinelinux.org/alpine/edge/testing" >> /etc/apk/repositories
RUN apk add hugo
RUN apk add make
RUN apk add awscli@testing

