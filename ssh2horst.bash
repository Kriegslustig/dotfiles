#!/bin/bash

ssh -N -D 6666 mail.kriegslustig.me &
ssh_pid=$!

sleep 2

networksetup -switchtolocation horst

trap "networksetup -switchtolocation Automatic && kill ${ssh_pid} && exit" SIGINT SIGTERM

wait ${ssh_pid}

