FROM ubuntu:24.04
LABEL org.opencontainers.image.source=https://github.com/willnewby/kshell

ARG TARGETPLATFORM
ARG TARGETARCH
ARG BUILDPLATFORM
ARG VERSION

ARG NODE_VERSION=24.21.0
ARG PI_VERSION=0.99.1
ARG KUBECTL_VERSION=1.37.1
ARG HELM_VERSION=4.3.0
ARG GH_VERSION=2.101.0
ARG UV_VERSION=0.12.21

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
    tmux \
    sudo \
    less \
    bash-completion \
    xz-utils \
    && rm -rf /var/lib/apt/lists/*

# Node + pi: official tarballs only exist for amd64/arm64 (no armv7 build)
RUN set -eux; \
    case "$TARGETARCH" in \
      amd64) NODE_ARCH=x64 ;; \
      arm64) NODE_ARCH=arm64 ;; \
      *) NODE_ARCH=skip ;; \
    esac; \
    if [ "$NODE_ARCH" != "skip" ]; then \
      curl -fsSL "https://nodejs.org/dist/v${NODE_VERSION}/node-v${NODE_VERSION}-linux-${NODE_ARCH}.tar.xz" \
        | tar -xJ --strip-components=1 -C /usr/local; \
      npm config set prefix /usr/local; \
      npm install -g "@earendil-works/pi-coding-agent@${PI_VERSION}"; \
      npm cache clean --force; \
    fi

RUN curl -fsSL "https://dl.k8s.io/release/v${KUBECTL_VERSION}/bin/linux/${TARGETARCH}/kubectl" \
      -o /usr/local/bin/kubectl \
    && chmod +x /usr/local/bin/kubectl

RUN curl -fsSL "https://get.helm.sh/helm-v${HELM_VERSION}-linux-${TARGETARCH}.tar.gz" \
      | tar -xz -C /tmp \
    && mv "/tmp/linux-${TARGETARCH}/helm" /usr/local/bin/helm \
    && rm -rf "/tmp/linux-${TARGETARCH}"

# gh: per-arch deb (there is no armv7 asset; armv6 runs on arm/v7, package arch armhf)
RUN set -eux; \
    case "$TARGETARCH" in \
      amd64) GH_ARCH=amd64 ;; \
      arm64) GH_ARCH=arm64 ;; \
      arm)   GH_ARCH=armv6 ;; \
    esac; \
    curl -fsSL -o /tmp/gh.deb \
      "https://github.com/cli/cli/releases/download/v${GH_VERSION}/gh_${GH_VERSION}_linux_${GH_ARCH}.deb"; \
    apt-get update && apt-get install -y /tmp/gh.deb; \
    rm -f /tmp/gh.deb && rm -rf /var/lib/apt/lists/*

# dev user (uid/gid 1000), passwordless sudo. Ubuntu 24.04 already ships an
# `ubuntu` user at uid/gid 1000, so rename it in place to preserve the id.
RUN set -eux; \
    groupmod -n dev ubuntu; \
    usermod -l dev -d /home/dev -m ubuntu; \
    usermod -s /bin/bash dev; \
    echo 'dev ALL=(ALL) NOPASSWD:ALL' > /etc/sudoers.d/dev; \
    chmod 440 /etc/sudoers.d/dev; \
    mkdir -p /home/dev/workspace; \
    chown -R dev:dev /home/dev

# uv: the published container image has no linux/arm/v7 variant, so install the
# per-arch release tarball (the image stage would fail the armv7 leg).
RUN set -eux; \
    case "$TARGETARCH" in \
      amd64) UV_ARCH=x86_64-unknown-linux-gnu ;; \
      arm64) UV_ARCH=aarch64-unknown-linux-gnu ;; \
      arm)   UV_ARCH=armv7-unknown-linux-gnueabihf ;; \
    esac; \
    curl -fsSL "https://github.com/astral-sh/uv/releases/download/${UV_VERSION}/uv-${UV_ARCH}.tar.gz" \
      | tar -xz -C /tmp; \
    mv "/tmp/uv-${UV_ARCH}/uv" "/tmp/uv-${UV_ARCH}/uvx" /usr/local/bin/; \
    rm -rf "/tmp/uv-${UV_ARCH}"

COPY sleep-123 /sleep-123
COPY healthz.sh /usr/bin/healthz.sh
RUN chmod +x /usr/bin/healthz.sh

ENTRYPOINT ["/usr/bin/dumb-init", "--"]
CMD ["bash", "/sleep-123"]
