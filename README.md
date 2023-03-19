# kshell

## Concept
A lightweight troubleshooting image to run in K8s via a command like:

```bash
/usr/local/bin/kubectl run -it --rm --image=ghcr.io/willnewby/kshell:latest --restart=Never sh
```

Add to your ~/.zprofile or ~/.bash_profile like so:

```bash
alias kshell='/usr/local/bin/kubectl run -it --rm --image=ghcr.io/willnewby/kshell:latest --restart=Never sh'
```

## Building
`task` to build + push a new image. Uses https://taskfile.dev
