#!/bin/bash

if [ -n "$SEG_DEBUG" ] ; then
    set -x
    env | sort
fi

cd $WEST_SIM_ROOT
mkdir -pv $WEST_CURRENT_SEG_DATA_REF || exit 1
cd $WEST_CURRENT_SEG_DATA_REF || exit 1


ln -sv $WEST_SIM_ROOT/{reference.pdb,chignolin.prmtop,ptraj_rmsd.in} .

case $WEST_CURRENT_SEG_INITPOINT_TYPE in
    SEG_INITPOINT_CONTINUES)
        ln -sv $WEST_PARENT_DATA_REF/seg.rst7 ./parent.rst7
        ln -sv $WEST_SIM_ROOT/md-continue.in md.in 
    ;;

    SEG_INITPOINT_NEWTRAJ)
        ln -sv $WEST_SIM_ROOT/md-genvel.in md.in
        ln -sv $WEST_SIM_ROOT/chignolin.rst7 parent.rst7
    ;;

    *)
        echo "unknown init point type $WEST_CURRENT_SEG_INITPOINT_TYPE"
        exit 2
    ;;
esac

pmemd -O  -i md.inp  -p chignolin.prmtop  -c parent.rst  -x seg.mdcrd  -r seg.rst  -o seg.out  -inf seg.info   || exit 1

cpptraj chignolin.prmtop <ptraj_rmsd.in || exit 1
gawk '{print $2}' rmsd.temp | tail -2 > $WEST_PCOORD_RETURN || exit 1

