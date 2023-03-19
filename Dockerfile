FROM --platform=$BUILDPLATFORM ubuntu:22.04
LABEL org.opencontainers.image.source=https://github.com/willnewby/kshell

ARG TARGETPLATFORM
ARG BUILDPLATFORM
ARG VERSION

RUN apt-get update && apt-get install -y \
    curl \
    git \
    jq \
    unzip \
    wget \
    openssl \
    dumb-init \
    && rm -rf /var/lib/apt/lists/*

COPY sleep-123 /sleep-123

CMD [ "/usr/bin/dumb-init", "bash", "/sleep-123" ]