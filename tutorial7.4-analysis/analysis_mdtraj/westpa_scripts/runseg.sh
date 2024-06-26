#!/bin/bash
#
# runseg.sh
#
# WESTPA runs this script for each trajectory segment. WESTPA supplies
# environment variables that are unique to each segment, such as:
#
#   WEST_CURRENT_SEG_DATA_REF: A path to where the current trajectory segment's
#       data will be stored. This will become "WEST_PARENT_DATA_REF" for any
#       child segments that spawn from this segment
#   WEST_PARENT_DATA_REF: A path to a file or directory containing data for the
#       parent segment.
#   WEST_CURRENT_SEG_INITPOINT_TYPE: Specifies whether this segment is starting
#       anew, or if this segment continues from where another segment left off.
#   WEST_RAND16: A random integer
#
# This script has the following three jobs:
#  1. Create a directory for the current trajectory segment, and set up the
#     directory for running pmemd/sander
#  2. Run the dynamics
#  3. Calculate the progress coordinates and return data to WESTPA

# If we are running in debug mode, then output a lot of extra information.
if [ -n "$SEG_DEBUG" ] ; then
  set -x
  env | sort
fi

######################## Set up for running the dynamics #######################
# Set up the directory where data for this segment will be stored.
cd $WEST_SIM_ROOT
mkdir -pv $WEST_CURRENT_SEG_DATA_REF
cd $WEST_CURRENT_SEG_DATA_REF

 # Make a symbolic link to the topology file. This is not unique to each segment.
ln -sv $WEST_SIM_ROOT/common_files/P53.MDM2.prmtop .

# Either continue an existing tractory, or start a new trajectory. In the
# latter case, we need to do a couple things differently, such as generating
# velocities.
#
# First, take care of the case that this segment is a continuation of another
# segment.  WESTPA provides the environment variable
# $WEST_CURRENT_SEG_INITPOINT_TYPE, and we check its value.
if [ "$WEST_CURRENT_SEG_INITPOINT_TYPE" = "SEG_INITPOINT_CONTINUES" ]; then
  # The weighted ensemble algorithm requires that dynamics are stochastic.
  # We'll use the "sed" command to replace the string "RAND" with a randomly
  # generated seed.
  sed "s/RAND/$WEST_RAND16/g" $WEST_SIM_ROOT/common_files/md.in > md.in
  # This trajectory segment will start off where its parent segment left off.
  # The "ln" command makes symbolic links to the parent segment's rst file.
  # This is preferable to copying the files, since it doesn't
  # require writing all the data again.
  ln -sv $WEST_PARENT_DATA_REF/seg.rst ./parent.rst

# Now take care of the case that the trajectory is starting anew.
elif [ "$WEST_CURRENT_SEG_INITPOINT_TYPE" = "SEG_INITPOINT_NEWTRAJ" ]; then
  # Again, we'll use the "sed" command to replace the string "RAND" with a
  # randomly generated seed.
  sed "s/RAND/$WEST_RAND16/g" $WEST_SIM_ROOT/common_files/md.in > md.in
  # For a new segment, we only need to make a symbolic link to the .rst file.
  ln -sv $WEST_PARENT_DATA_REF ./parent.rst
fi

############################## Run the dynamics ################################
# Propagate segment using pmemd (or sander)
pmemd -O -i md.in   -p P53.MDM2.prmtop  -c parent.rst \
          -r seg.rst -x seg.nc      -o seg.log    -inf seg.nfo

mv parent.rst parent.restrt

# Set the arguments for rmsd.py and call the script to calculate progress
# coordinate(s) for the current trajectory segment.
# Arguments:
#   ref: path to initial state coordinate file.
#   top: path to topology file.
#   mob: path to trajectory file.
#   for: we are evaluating a trajectory segment, so for = 'NCDF'
$WEST_SIM_ROOT/rmsd.py \
    --ref $WEST_SIM_ROOT/bstates/P53.MDM2.nc \
    --top $WEST_SIM_ROOT/amber_config/P53.MDM2.prmtop \
    --mob $WEST_CURRENT_SEG_DATA_REF/seg.nc \
    --for NCDF \

cat rmsd.dat > $WEST_PCOORD_RETURN

# Clean up
rm -f $TEMP md.in seg.nfo seg.pdb
