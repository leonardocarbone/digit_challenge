#!/bin/bash

if [[ -z "$1" ]]; then   
   service jenkins start
   tail -f /dev/null
else
   exec $1
fi
