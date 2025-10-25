#!/usr/bin/dumb-init  /bin/bash
sleep 5
ping -c4 1.1.1.1
exit $?
