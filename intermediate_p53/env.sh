#!/bin/bash

# Set up environment for westpa
export WEST_PYTHON=$(which python2.7)
source /ihome/lchong/atb43/apps/westpa/18.02.23/westpa.sh
export WEST_SIM_ROOT="$PWD"
export SIM_NAME=$(basename $WEST_SIM_ROOT)
