#!/bin/bash

. ./scripts/spinner.sh

# your real command here, instead of sleep
sleep 2 &
spinner $! "Short task"
if [ $? -eq 0 ]; then
  echo success
else
  echo failed
  exit 0
fi

sleep 7 &
spinner $! "Long task"
if [ $? -eq 0 ]; then
  echo success
else
  echo failed
  exit 0
fi