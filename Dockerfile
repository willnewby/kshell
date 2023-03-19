FROM --platform=$BUILDPLATFORM golang:1.20-alpine
LABEL org.opencontainers.image.source=https://github.com/willnewby/kshell

RUN apk update && apk add drill curl git openssl
RUN go install github.com/rakyll/hey@latest