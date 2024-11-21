#!/bin/bash

# Set up simulation environment
source env.sh

# Clean up from previous/ failed runs
rm -rf traj_segs seg_logs istates west.h5
mkdir   seg_logs traj_segs istates

# Set bstate
BSTATES="--bstate initial,1.0"

# Run w_init
w_init $BSTATES --work-manager=serial "$@"
