#!/bin/bash

if [ -n "$SEG_DEBUG" ] ; then
    set -x
    env | sort
fi

cd $WEST_SIM_ROOT
echo 'I am here'
cp chignolin.rst7 parent.rst7
function cleanup() {
    rm -f parent.rst7
}

trap cleanup EXIT

# Get progress coordinate
cpptraj common_files/chignolin.prmtop <ptraj_rmsd_init.in || exit 1
gawk '{print $2}' rmsd.temp | tail -1 > pcoord.dat || exit 1
cat pcoord.dat > $WEST_PCOORD_RETURN
rm mdinfo rmsd.temp eted.dat pcoord*

if [ -n "$SEG_DEBUG" ] ; then
    head -v $WEST_PCOORD_RETURN
fi

