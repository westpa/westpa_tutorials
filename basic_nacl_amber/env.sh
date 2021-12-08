#!/bin/bash

# Set up environment for dynamics
source $AMBERHOME/amber.sh

# Define some WESTPA variables
export WEST_PYTHON=$(which python)
export WEST_SIM_ROOT="$PWD"
export SIM_NAME=$(basename $WEST_SIM_ROOT)

# Set runtime commands (this is said to be easier on the filesystem)
export PMEMD=$(which pmemd)
export SANDER=$(which sander)
export CPPTRAJ=$(which cpptraj)
