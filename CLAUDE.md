# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

kshell is a lightweight troubleshooting container image designed to run in Kubernetes clusters. It provides a pre-configured Ubuntu-based environment with common networking and debugging tools.

## Building and Publishing

The project uses [Taskfile](https://taskfile.dev) for build automation.

**Build and push the image:**
```bash
task
```
or explicitly:
```bash
task build-push
```

This builds multi-architecture images (linux/amd64, linux/arm/v7, linux/arm64/v8) and pushes them to `ghcr.io/willnewby/kshell` with two tags:
- `latest`
- `{DATE}-{GITSHA}` (e.g., `202501151430-a1b2c3d`)

The DATE format is `%Y%m%d%H%M` derived from the git commit timestamp.

**Requirements:**
- Docker with buildx support
- Authenticated to GitHub Container Registry (ghcr.io)

## Usage

The image is designed to be launched as an ephemeral troubleshooting pod:

```bash
kubectl run -it --attach --rm atlas --restart=Never --image=ghcr.io/willnewby/kshell:latest -- bash
```

Users typically alias this command as `kshell` in their shell profile.

## Image Architecture

**Base Image:** Ubuntu 22.04 with multi-platform support

**Installed Tools:**
- Networking: curl, wget, dnsutils, iputils-ping, net-tools, hey (HTTP load generator)
- Development: git, emacs
- Utilities: jq, openssl, unzip, dumb-init

**Entrypoint:** Uses dumb-init as PID 1 for proper signal handling

**Default Behavior:** The container runs `/sleep-123`, a simple bash script that prints status messages every 120 seconds, keeping the pod alive for troubleshooting.

## Key Files

- `Dockerfile`: Multi-architecture Ubuntu image definition
- `Taskfile.yaml`: Build and publish automation
- `sleep-123`: Bash script that keeps the container running with periodic logging
