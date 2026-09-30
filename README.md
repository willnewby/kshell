# kshell

## Concept
A lightweight troubleshooting image to run in K8s via a command like:

```bash
kubectl run -it --attach --rm  atlas --restart=Never --image=ghcr.io/willnewby/kshell:latest -- bash
```

Add to your ~/.zprofile or ~/.bash_profile like so:

```bash
alias kshell="kubectl run -it --attach --rm  atlas --restart=Never --image=ghcr.io/willnewby/kshell:latest -- bash"
```

## Building
Built and released using GitHub Actions, only commits on `main` branch. 

## Dev tooling
The image also doubles as a self-contained Kubernetes development environment.
On top of the troubleshooting tools it ships:

- **Node.js** `v24.21.0` and **pi** (`@earendil-works/pi-coding-agent`) `0.99.1`
- **kubectl** `v1.37.1`, **helm** `v4.3.0`, **gh** `v2.101.0`
- `tmux`, `sudo`, `less`, `bash-completion`

A non-root `dev` user (uid/gid `1000`, `HOME=/home/dev`, passwordless sudo) is
available for long-lived workloads. The default image user stays `root`, so the
original ephemeral `kubectl run ... -- bash` usage is unchanged.

Because Node.js publishes no armv7 binary for v24, the Node + pi layer is
skipped on `linux/arm/v7` builds (kubectl/helm/gh are still installed); amd64
and arm64 get the full toolset.

