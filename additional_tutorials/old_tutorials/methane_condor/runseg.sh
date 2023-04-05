#!/bin/bash

if [ -n "$SEG_DEBUG" ] ; then
    set -x
    env | sort
fi

cd $WEST_SIM_ROOT

mkdir -pv $WEST_CURRENT_SEG_DATA_REF || exit 1
cd $WEST_CURRENT_SEG_DATA_REF || exit 1

TOP=methane.top
NDX=methane.ndx

# Set up the run
ln -sv $WEST_SIM_ROOT/{$TOP,$NDX,*.mdp,*.itp} .
ln -sv $WEST_SIM_ROOT/gromacs-chtc.sh
ln -sv $WEST_SIM_ROOT/gromacs-chtc.sub

# if [ "$WEST_PARENT_SEG_ID" -lt "0" ]; then
#     # this is a start/restart
#     ln -sv $WEST_PARENT_SEG_DATA_REF/unbound.gro .
#     grompp -f md-genvel.mdp -c unbound.gro -p $TOP -o seg.tpr -n $NDX || exit 1
# else
#     ln -sv $WEST_PARENT_SEG_DATA_REF/seg.gro ./parent.gro
#     ln -sv $WEST_PARENT_SEG_DATA_REF/seg.trr ./parent.trr
#     grompp -f md-continue.mdp -c parent.gro -t parent.trr -p $TOP -o seg.tpr -n $NDX || exit 1
# fi

case $WEST_CURRENT_SEG_INITPOINT_TYPE in
    SEG_INITPOINT_CONTINUES)
        # A continuation from a prior segment
        ln -sv $WEST_PARENT_DATA_REF/seg.gro ./parent.gro
        ln -sv $WEST_PARENT_DATA_REF/seg.trr ./parent.trr
        grompp -f md-continue.mdp -c parent.gro -t parent.trr -p $TOP -o seg.tpr -n $NDX || exit 1
    ;;

    SEG_INITPOINT_NEWTRAJ)
        # Initiation of a new trajectory; $WEST_PARENT_DATA_REF contains the reference to the
        # appropriate basis state or generated initial state
        ln -sv $WEST_PARENT_DATA_REF ./initial.gro
        grompp -f md-genvel.mdp -c initial.gro -p $TOP -o seg.tpr -n $NDX || exit 1
    ;;

    *)
        echo "unknown init point type $WEST_CURRENT_SEG_INITPOINT_TYPE"
        exit 2
    ;;
esac

# Save variables to file

echo $TOP > WESTPA_VARAIBLES.txt
echo $NDX >> WESTPA_VARAIBLES.txt
echo $WEST_PCOORD_RETURN >> WESTPA_VARAIBLES.txt
echo $WEST_COORD_RETURN >> WESTPA_VARAIBLES.txt

# Submit job into Condor pool

condor_submit gromacs-chtc.sub >& condor_sumbit.eo

# Extract job id from condor_sumbit.eo
tail -1 condor_submit.eo | awk '{print $6}' | sed s/\\.//g

# Query Condor job log for successful termination

while :
do
  if grep -lq "Normal termination (return value 0)" gromacs-chtc*log; then
        break
  fi
  sleep 60
done

# Copy data back to WESTPA_VARAIBLES
cp pcoordinate.txt $WEST_PCOORD_RETURN
cp  coordinate.txt $WEST_COORD_RETURN




