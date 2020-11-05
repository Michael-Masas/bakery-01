#!/usr/bin/bash
pkg="ncdu"
if rpm -q $pkg
then
    echo "$pkg installed"
else
    echo "Do u want to install $pkg?"
fi
