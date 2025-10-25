FROM --platform=$BUILDPLATFORM ubuntu:24.04
LABEL org.opencontainers.image.source=https://github.com/willnewby/kshell

ARG TARGETPLATFORM
ARG BUILDPLATFORM
ARG VERSION

RUN apt-get update && apt-get install -y \
    curl \
    dumb-init \
    dnsutils \
    emacs \
    git \
    jq \
    openssl \
    unzip \
    wget \
    iputils-ping \
    hey \
    net-tools \
    && rm -rf /var/lib/apt/lists/*

COPY sleep-123 /sleep-123
COPY healthz.sh /usr/bin/healthz.sh
RUN chmod +x /usr/bin/healthz.sh

ENTRYPOINT ["/usr/bin/dumb-init", "--"]
CMD ["bash", "/sleep-123"]
