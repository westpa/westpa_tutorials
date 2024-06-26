#!/bin/bash

if [ -n "$SEG_DEBUG" ] ; then
  set -x
  env | sort
fi

cd $WEST_SIM_ROOT
mkdir -pv $WEST_CURRENT_SEG_DATA_REF
cd $WEST_CURRENT_SEG_DATA_REF

ln -sv $WEST_SIM_ROOT/common_files/nacl.parm7 .

if [ "$WEST_CURRENT_SEG_INITPOINT_TYPE" = "SEG_INITPOINT_CONTINUES" ]; then
  sed "s/RAND/$WEST_RAND16/g" $WEST_SIM_ROOT/common_files/md.in > md.in
  ln -sv $WEST_PARENT_DATA_REF/seg.rst ./parent.rst
elif [ "$WEST_CURRENT_SEG_INITPOINT_TYPE" = "SEG_INITPOINT_NEWTRAJ" ]; then
  sed "s/RAND/$WEST_RAND16/g" $WEST_SIM_ROOT/common_files/md.in > md.in
  ln -sv $WEST_PARENT_DATA_REF ./parent.rst
fi

# Here we distribute the GPUs based on the variable $WM_PROCESS_INDEX, which is the ID of each process given by the work manager
# By default, $CUDA_VISIBLE_DEVICES should lists all of the available GPUs on this node.
export CUDA_DEVICES=(`echo $CUDA_VISIBLE_DEVICES_ALLOCATED | tr , ' '`)
export CUDA_VISIBLE_DEVICES=${CUDA_DEVICES[$WM_PROCESS_INDEX]}

echo "RUNSEG.SH: CUDA_VISIBLE_DEVICES_ALLOCATED = " $CUDA_VISIBLE_DEVICES_ALLOCATED
echo "RUNSEG.SH: WM_PROCESS_INDEX = " $WM_PROCESS_INDEX
echo "RUNSEG.SH: CUDA_VISIBLE_DEVICES = " $CUDA_VISIBLE_DEVICES

$PMEMD -O -i md.in   -p nacl.parm7  -c parent.rst \
           -r seg.rst -x seg.nc      -o seg.log    -inf seg.nfo

TEMP=$(mktemp)
COMMAND="         parm nacl.parm7\n"
COMMAND="$COMMAND trajin $WEST_CURRENT_SEG_DATA_REF/parent.rst\n"
COMMAND="$COMMAND trajin $WEST_CURRENT_SEG_DATA_REF/seg.nc\n"
COMMAND="$COMMAND autoimage fixed :1@Na+ \n"
COMMAND="$COMMAND distance na-cl :1@Na+ :2@Cl- out $TEMP\n"
COMMAND="$COMMAND go\n"

echo -e $COMMAND | $CPPTRAJ
cat $TEMP | tail -n +2 | awk '{print $2}' > $WEST_PCOORD_RETURN

if [ ${WEST_COORD_RETURN} ]; then
  COMMAND="         parm nacl.parm7\n"
  COMMAND="$COMMAND trajin  $WEST_CURRENT_SEG_DATA_REF/parent.rst\n"
  COMMAND="$COMMAND trajin  $WEST_CURRENT_SEG_DATA_REF/seg.nc\n"
  COMMAND="$COMMAND strip :WAT \n"
  COMMAND="$COMMAND autoimage fixed :1@Na+ \n"
  COMMAND="$COMMAND trajout $WEST_CURRENT_SEG_DATA_REF/seg.pdb\n"
  COMMAND="$COMMAND go\n"
  echo -e $COMMAND | $CPPTRAJ 
  cat $WEST_CURRENT_SEG_DATA_REF/seg.pdb | grep 'ATOM' \
    | awk '{print $6, $7, $8}' > $WEST_COORD_RETURN
fi

# Clean up
rm -f $TEMP md.in seg.nfo seg.pdb
