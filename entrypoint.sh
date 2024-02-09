#!/bin/sh

CONTEXT=$1

# if it dosn't exist, copy /bin/sh to /$CONTEXT/bin/sh
if [ ! -f /$CONTEXT/bin/sh ]; then
    cp /bin/sh /$CONTEXT/bin/sh
fi
chroot /$CONTEXT $CONTEXT/dynamic-entrypoint.sh
