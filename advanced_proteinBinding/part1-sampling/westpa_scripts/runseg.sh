#!/bin/bash

if [ -n "$SEG_DEBUG" ] ; then
  set -x
  env | sort
fi

cd $WEST_SIM_ROOT
mkdir -pv $WEST_CURRENT_SEG_DATA_REF
cd $WEST_CURRENT_SEG_DATA_REF

ln -sv $WEST_SIM_ROOT/common_files/system.top .

if [ "$WEST_CURRENT_SEG_INITPOINT_TYPE" = "SEG_INITPOINT_CONTINUES" ]; then
  sed "s/RAND/$WEST_RAND16/g" $WEST_SIM_ROOT/common_files/md.in > md.in
  ln -sv $WEST_PARENT_DATA_REF/seg.rst ./parent.rst
elif [ "$WEST_CURRENT_SEG_INITPOINT_TYPE" = "SEG_INITPOINT_NEWTRAJ" ]; then
  sed "s/RAND/$WEST_RAND16/g" $WEST_SIM_ROOT/common_files/md.in > md.in
  ln -sv $WEST_PARENT_DATA_REF ./parent.rst
fi

export CUDA_DEVICES=(`echo $CUDA_VISIBLE_DEVICES_ALLOCATED | tr , ' '`)
export CUDA_VISIBLE_DEVICES=${CUDA_DEVICES[$WM_PROCESS_INDEX]}

echo "RUNSEG.SH: CUDA_VISIBLE_DEVICES_ALLOCATED = " $CUDA_VISIBLE_DEVICES_ALLOCATED
echo "RUNSEG.SH: WM_PROCESS_INDEX = " $WM_PROCESS_INDEX
echo "RUNSEG.SH: CUDA_VISIBLE_DEVICES = " $CUDA_VISIBLE_DEVICES

$PMEMD -O -i md.in   -p system.top  -c parent.rst \
          -r seg.rst -x seg.nc      -o seg.log    -inf seg.nfo

DIST=$(mktemp)
RMSDBN=$(mktemp)
RMSDBS=$(mktemp)
NUMS=$(mktemp)
COMMAND="         parm $WEST_SIM_ROOT/common_files/system.top\n"
COMMAND="$COMMAND trajin $WEST_CURRENT_SEG_DATA_REF/seg.nc\n"
COMMAND="$COMMAND reference $WEST_SIM_ROOT/bstates/bstate.rst \n"
COMMAND="$COMMAND autoimage\n"
COMMAND="$COMMAND nativecontacts :1-109 :110-197 mindist out $DIST \n"
COMMAND="$COMMAND rms reference :1-109@CA \n"
COMMAND="$COMMAND rms reference :110-197@CA nofit out $RMSDBS \n"
COMMAND="$COMMAND rms reference :110-197@CA \n"
COMMAND="$COMMAND rms reference :1-109@CA nofit out $RMSDBN \n"
COMMAND="$COMMAND go\n"

echo -e "${COMMAND}" | $CPPTRAJ

cat $DIST
cat $RMSDBN
cat $RMSDBS
paste <(cat $RMSDBN | tail -n +2 | awk '{print $2}') <(cat $RMSDBS | tail -n +2 | awk '{print $2}') > $NUMS
paste <(cat $DIST | tail -n +2 | awk '{print $4}') <(awk {'print sqrt($1*$2)'} $NUMS) > $WEST_PCOORD_RETURN
cat $RMSDBN | tail -n +2 | awk '{print $2}' > $WEST_BN_RMSD_RETURN
cat $RMSDBS | tail -n +2 | awk '{print $2}' > $WEST_BS_RMSD_RETURN
# Clean up
rm -f $DIST $RMSDBN $RMSDBS md.in parent.rst seg.nfo seg.pdb gst.top $NUMS
