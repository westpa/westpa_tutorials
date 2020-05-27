#!/bin/bash

# Set up environment for dynamics
#KFW source /home/atb43/apps/amber18/amber.sh
module purge
module load intel/2017.3.196
module load amber/18-2019_01
module rm python/intel-3.6

# Set up environment for westpa
#KFW source /home/atb43/apps/westpa/westpa.sh
#KFW export WEST_PYTHON=$(which python2.7)
. ~/.bashrc
conda activate westpa
export WEST_SIM_ROOT="$PWD"
export SIM_NAME=$(basename $WEST_SIM_ROOT)

# Set runtime commands (this is said to be easier on the filesystem)
#KFW export PMEMD=$(which pmemd)
export PMEMD=$(which pmemd.MPI) 
export CPPTRAJ=$(which cpptraj)

# Specify the number of cores for each Amber process and redefine PMEMD
export NCORES=2
export PMEMD="mpirun -n $NCORES $PMEMD"
