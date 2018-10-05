FROM golang:1.11-alpine
RUN apk update && apk add drill curl git
RUN go get -u github.com/rakyll/hey
