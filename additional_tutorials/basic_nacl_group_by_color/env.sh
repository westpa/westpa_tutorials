#!/bin/bash

# Set up environment for westpa
# Actviate a conda environment containing westpa, openmm and mdtraj;
# you may need to create this first (see install instructions)

#. ~/.bashrc
#conda deactivate
#conda activate westpa-py3.7_MPI-WM

. ~/.bashrc
conda activate WESTPA-2.0-BINLESS.1
##conda activate WESTPA-WExplore-BINLESS
#
export WEST_SIM_ROOT="$PWD"
export SIM_NAME=$(basename $WEST_SIM_ROOT)
