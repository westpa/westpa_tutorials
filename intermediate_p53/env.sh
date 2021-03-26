#!/bin/bash

# Set up environment for dynamics
# need to install ammbertools first  

# Set up environment for westpa
export WEST_PYTHON=$(which python)
export WEST_SIM_ROOT="$PWD"
export SIM_NAME=$(basename $WEST_SIM_ROOT)

# Set runtime commands (this is said to be easier on the filesystem)
export SANDER=$(which sander)
export CPPTRAJ=$(which cpptraj)
