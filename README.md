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
