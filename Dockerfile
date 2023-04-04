FROM --platform=$BUILDPLATFORM ubuntu:22.04
LABEL org.opencontainers.image.source=https://github.com/willnewby/kshell

ARG TARGETPLATFORM
ARG BUILDPLATFORM
ARG VERSION

RUN apt-get update && apt-get install -y \
    curl \
    dumb-init \
    dnsutils \
    git \
    jq \
    openssl \
    unzip \
    wget \
    && rm -rf /var/lib/apt/lists/*

COPY sleep-123 /sleep-123

#ENTRYPOINT ["/usr/bin/dumb-init", "--"]
CMD ["bash", "/sleep-123"]