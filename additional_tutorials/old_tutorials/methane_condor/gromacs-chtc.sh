#!/bin/bash

export PATH=.":"$PATH
TOP=methane.top
NDX=methane.ndx
WEST_PCOORD_RETURN=pcoordinate.txt
WEST_COORD_RETURN=coordinate.txt

# Propagate segment
mdrun -s seg.tpr -o seg.trr -x seg.xtc -c seg.gro \
      -e seg.edr -g seg.log -nt 1 \
      || exit 1

# Get progress coordinate
echo "7 8" | g_dist -f seg.xtc -s seg.tpr -n $NDX -xvg none || exit 1
awk '{print $2*10;}' < dist.xvg > $WEST_PCOORD_RETURN || exit 1

# Get coordinates
if [ -n "$WEST_COORD_RETURN" ] ; then
    echo 7 | g_traj -f seg.xtc -s seg.tpr -n $NDX -ox coord1.xvg -nopbc -fp -xvg none || exit 1
    echo 8 | g_traj -f seg.xtc -s seg.tpr -n $NDX -ox coord2.xvg -nopbc -fp -xvg none || exit 1
    paste <(awk '{$1=""; print;}' < coord1.xvg) <(awk '{$1=""; print;}' < coord2.xvg) > $WEST_COORD_RETURN
    cp $WEST_COORD_RETURN coords.dat
fi

# Clean up
rm -f *.xvg *.itp *.mdp *.ndx *.top state.cpt

