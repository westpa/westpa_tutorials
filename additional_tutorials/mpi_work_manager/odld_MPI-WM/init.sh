#!/bin/bash

# Set up simulation environment
source env.sh

# Clean up from previous/ failed runs
rm -f west.h5

# Set bstate
BSTATES="--bstate initial,1.0"

# Run w_init
w_init $BSTATES --work-manager=serial "$@"
