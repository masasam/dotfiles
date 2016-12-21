#!/bin/sh
echo "Is it OK to continue install? [yes/no]"
read -r answer
if [ "$answer" != "yes" ]; then
    echo "Stoped"
    exit 1;
fi
