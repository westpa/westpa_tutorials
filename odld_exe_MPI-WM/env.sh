#!/bin/bash

# Set up environment for dynamics
module purge
module load gcc/8.2.0
module load openmpi/4.0.3

# Set WESTPA-related variables
export WEST_SIM_ROOT="$PWD"
export SIM_NAME=$(basename $WEST_SIM_ROOT)

