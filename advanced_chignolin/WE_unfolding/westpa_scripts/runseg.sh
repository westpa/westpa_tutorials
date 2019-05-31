#!/bin/bash

if [ -n "$SEG_DEBUG" ] ; then
    set -x
    env | sort
fi

cd $WEST_SIM_ROOT
mkdir -pv $WEST_CURRENT_SEG_DATA_REF || exit 1
cd $WEST_CURRENT_SEG_DATA_REF || exit 1


ln -sv $WEST_SIM_ROOT/common_files/{chignolin.pdb,chignolin.prmtop} .

if [ "$WEST_CURRENT_SEG_INITPOINT_TYPE" = "SEG_INITPOINT_CONTINUES" ]; then
  sed "s/RAND/$WEST_RAND16/g" $WEST_SIM_ROOT/common_files/md.in > md.in
  ln -sv $WEST_PARENT_DATA_REF/seg.rst ./parent.rst
elif [ "$WEST_CURRENT_SEG_INITPOINT_TYPE" = "SEG_INITPOINT_NEWTRAJ" ]; then
  sed "s/RAND/$WEST_RAND16/g" $WEST_SIM_ROOT/common_files/md.in > md.in
  ln -sv $WEST_SIM_ROOT/common_files/chignolin.rst parent.rst
fi


pmemd -O  -i md.inp  -p chignolin.prmtop  -c parent.rst  -x seg.mdcrd  -r seg.rst  -o seg.out  -inf seg.info   || exit 1

cpptraj chignolin.prmtop < $WEST_SIM_ROOT/get_rmsd.in || exit 1
awk '{print $2}' rmsd.dat | tail -2 > $WEST_PCOORD_RETURN || exit 1


