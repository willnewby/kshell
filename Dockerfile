FROM golang:1.20-alpine
RUN apk update && apk add drill curl git openssl
RUN go install github.com/rakyll/hey@latest