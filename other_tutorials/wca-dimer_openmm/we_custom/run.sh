#!/bin/bash

source env.sh

rm -f west.log
$WEST_ROOT/bin/w_run "$@" --n-workers=1 --work-manager=serial &>> west.log
