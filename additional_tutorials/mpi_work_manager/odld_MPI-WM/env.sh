#!/bin/bash

# Set up environment for dynamics
module purge
module load westpa/2.0

# Set WESTPA-related variables
export WEST_SIM_ROOT="$PWD"
export SIM_NAME=$(basename $WEST_SIM_ROOT)

