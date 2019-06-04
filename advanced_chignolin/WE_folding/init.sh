#!/bin/bash

source env.sh

rm -rf traj_segs seg_logs  west.h5 
mkdir seg_logs traj_segs 

BSTATE_ARGS="--bstate start,1,common_files/chignolin_unf.rst"
TSTATE_ARGS="--tstate folded,0.49"

$WEST_ROOT/bin/w_init $BSTATE_ARGS $TSTATE_ARGS --segs-per-state 4 "$@"
 
