#!/bin/bash

source env.sh

rm -f west.log

# for multi-processes using CPUs
# w_run "$@" --n-workers=10 --work-manager=processes &>> west.log
# for single GPU
w_run "$@" --n-workers=1 --work-manager=serial &>> west.log
