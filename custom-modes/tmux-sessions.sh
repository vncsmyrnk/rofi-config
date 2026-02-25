#!/usr/bin/env bash

if [[ -n "$*" ]]; then
  tmux switch-client -t "$*"
  exit 0
fi

tmux list-sessions |
  cut -d ':' -f1
