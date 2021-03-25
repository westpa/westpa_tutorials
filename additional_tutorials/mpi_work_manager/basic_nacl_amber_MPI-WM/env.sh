#!/bin/bash

# Set up environment for dynamics
module purge
module load westpa/2.0
module load amber/18_AMD_gcc-8.2.0

# Set up environment for westpa
export WEST_SIM_ROOT="$PWD"
export SIM_NAME=$(basename $WEST_SIM_ROOT)

# Set runtime commands (this is said to be easier on the filesystem)
export PMEMD=$(which pmemd)
export CPPTRAJ=$(which cpptraj)

