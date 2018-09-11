#!/usr/bin/env bash

error() {
    local parent_lineno="$1"
    local message="$2"
    local code="${3:-1}"

    echo Error on line ${parent_lineno}: ${message}
    echo Trying to cleanup...

    [[ ${BARRIER_C} -eq 1 ]] && echo Cleaning C.. && exit "${code}"
    [[ ${BARRIER_B} -eq 1 ]] && echo Cleaning B.. 
    [[ ${BARRIER_A} -eq 1 ]] && echo Cleaning A..

    exit "${code}"
}

trap 'error ${LINENO}' ERR

[[ $1 -eq 1 ]]
echo A reached
export BARRIER_A=1

[[ $2 -eq 1 ]]
echo B reached
export BARRIER_B=1

[[ $3 -eq 1 ]] 
echo C reached 
export BARRIER_C=1

[[ $4 -eq 1 ]]
echo D reached 
