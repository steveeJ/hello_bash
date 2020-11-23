#!/usr/bin/env bash

set -xeo pipefail

function handler() {
  echo handler called
  sleep 10
  echo handler called
}

trap handler EXIT

sleep 1000
