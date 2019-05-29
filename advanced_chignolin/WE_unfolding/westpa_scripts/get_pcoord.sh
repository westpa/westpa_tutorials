#!/bin/bash

if [ -n "$SEG_DEBUG" ] ; then
    set -x
    env | sort
fi

cd $WEST_SIM_ROOT

cpptraj common_files/chignolin.prmtop <get_rmsd_init.in || exit 1
gawk '{print $2}' rmsd_init.dat | tail -1 > $WEST_PCOORD_RETURN || exit 1
rm  rmsd_init.dat 

if [ -n "$SEG_DEBUG" ] ; then
    head -v $WEST_PCOORD_RETURN
fi


