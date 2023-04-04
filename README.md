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
`task` to build + push a new image. Uses https://taskfile.dev
