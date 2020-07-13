#!/bin/bash

source env.sh

rm -f west.log
w_run "$@"  &> west.log
