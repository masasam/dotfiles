#!/bin/sh
echo -n “Is it OK to continue install? [yes/no]”
read answer
if [ "$answer" != "yes" ]; then
    echo "Stoped"
    exit 1;
fi
