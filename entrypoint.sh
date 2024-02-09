#!/bin/sh

CONTEXT=$1

# if it dosn't exist, copy /bin/sh to /$CONTEXT/bin/sh
if [ ! -f /$CONTEXT/bin/sh ]; then
    cp /bin/sh /$CONTEXT/bin/sh
fi

# Issues
# 1. running a shell in the chrrot fs won't work if no shell is installed
# 2 .busybox chroot doesn't support --userspec, so need to figure out how to su to the right user
chroot /$CONTEXT $CONTEXT/dynamic-entrypoint.sh
