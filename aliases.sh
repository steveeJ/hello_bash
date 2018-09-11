#!/usr/bin/env bash

shopt -s expand_aliases

alias one="echo one"

# only aliases defined previous to the function will be known inside
function caller() {
  one

  # this will error out
  two
}

alias two="echo two"

caller
