#!/usr/bin/env bash

# put your script here for Android/Termux only

if uname -a | grep android &> /dev/null; then
  export ANDROID=true
else
  export ANDROID=false
fi

if ! $ANDROID; then return; fi
