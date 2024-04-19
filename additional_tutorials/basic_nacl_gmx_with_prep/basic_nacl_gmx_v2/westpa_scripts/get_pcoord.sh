#!/bin/bash
#
# get_pcoord.sh
#
# This script is run when calculating initial progress coordinates for new 
# initial states (istates).  This script is NOT run for calculating the progress
# coordinates of most trajectory segments; that is instead the job of runseg.sh.

# If we are debugging, output a lot of extra information.
if [ -n "$SEG_DEBUG" ] ; then
  set -x
  env | sort
fi

# Make sure we are in the correct directory
cd $WEST_SIM_ROOT


# Calculate the distance between Na+ and Cl-
python3 $WEST_SIM_ROOT/bstates/pcoord.py $WEST_SIM_ROOT/bstates/bstate.trr $WEST_SIM_ROOT/bstates/bstate.gro

cat  $WEST_SIM_ROOT/bstates/pcoord.txt | awk '{print $1;}' > $WEST_PCOORD_RETURN
rm   $WEST_SIM_ROOT/pcoord.txt

cp $WEST_SIM_ROOT/common_files/nacl.top $WEST_TRAJECTORY_RETURN
cp $WEST_SIM_ROOT/bstates/bstate.gro $WEST_TRAJECTORY_RETURN
cp $WEST_SIM_ROOT/bstates/bstate.edr $WEST_TRAJECTORY_RETURN
cp $WEST_SIM_ROOT/bstates/bstate.trr $WEST_TRAJECTORY_RETURN

cp $WEST_SIM_ROOT/common_files/nacl.top $WEST_RESTART_RETURN
cp $WEST_SIM_ROOT/bstates/bstate.gro $WEST_RESTART_RETURN/parent.gro
cp $WEST_SIM_ROOT/bstates/bstate.edr $WEST_RESTART_RETURN/parent.edr
cp $WEST_SIM_ROOT/bstates/bstate.trr $WEST_RESTART_RETURN/parent.trr


if [ -n "$SEG_DEBUG" ] ; then
  head -v $WEST_PCOORD_RETURN
fi
