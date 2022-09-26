#!/bin/bash

# Set up simulation environment
source env.sh

# Clean up from previous/ failed runs
rm -rf traj_segs seg_logs istates west.h5 
mkdir   seg_logs traj_segs istates

# Make sure the CHARMM force field is in the right spot:
if [ ! -d common_files/toppar ]; then
  echo "CHARMM force field not found! Download the CHARMM36 force field, untar "
  echo "it, and place the 'toppar' directory in namd_config."
  exit 1
fi

# Process the CHARMM force field file to be compatibile with NAMD
cat common_files/toppar/toppar_water_ions.str \
  | grep -v -e "^set" \
  | grep -v -e "^if" \
  | grep -v -e "^WRNLEV"\
  | grep -v -e "^BOMLEV"\
  | grep -v -e "^SOD\s\s\s\sO"\
  > common_files/toppar/toppar_water_ions_for_namd.str

# Define the arguments for the basis states (used for generating initial 
# states; in this case we only have one), and target states (used for
# knowing when to recycle trajectories). In this example, we recycle
# trajectories as they reach the bound state; we focus on sampling  
# the binding process (and not the unbinding process).

BSTATE_ARGS="--bstate-file bstates/bstates.txt"
TSTATE_ARGS="--tstate bound,1.0"

# Initialize the simulation, creating the main WESTPA data file (west.h5)
# The "$@" lets us take any arguments that were passed to init.sh at the
# command line and pass them along to w_init.
w_init \
  $BSTATE_ARGS $TSTATE_ARGS \
  --segs-per-state 5 \
  --work-manager=threads "$@"
