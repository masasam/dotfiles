#!/bin/sh
echo "Continue install? [yes/no]"
read -r answer
if [ "$answer" != "yes" ]; then
    echo "Stoped"
    exit 1;
fi
