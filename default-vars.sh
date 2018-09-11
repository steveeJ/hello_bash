#!/usr/bin/env bash
set -x
# A does not exist
B="NOTEMPTY"
C=${A:-$B}
