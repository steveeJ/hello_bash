#!/usr/bin/env bash

set -x

export hello="hello"
export x=""

echo ${x}
echo ${hello:+x}
echo ${x}
