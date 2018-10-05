# kshell

## Concept
A lightweight troubleshooting image to run in K8s via a command like:
`alias kshell='/usr/local/bin/kubectl run -it --rm --image=willnewby/kshell:latest --restart=Never bash'`

## Building
`make` to build + push a new image.
