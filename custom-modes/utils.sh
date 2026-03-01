#!/usr/bin/env bash

if [[ -n "$*" ]]; then
  case "$*" in
  "Generate random 20 chars string")
    util random generate -l 20 | tr -d '\n' | wl-copy
    ;;
  esac
  exit 0
fi

echo -e "Generate random 20 chars string"
