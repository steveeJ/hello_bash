#!/usr/bin/env bash

set -e
exec &> >(tee -ai /dev/null)

function destroy() {
  echo "m4g1k"
  touch destroyed
}
trap destroy EXIT
exec 5>&1
OUTPUT=$(echo Sleeping...; sleep 1000 | tee -i >(cat - >&5))
