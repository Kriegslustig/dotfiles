#!/bin/bash

trap "networksetup -switchtolocation Automatic && exit" SIGINT SIGTERM

networksetup -switchtolocation horst
ssh -N -D 3000 mail.kriegslustig.me

