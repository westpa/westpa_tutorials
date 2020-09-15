#!/bin/bash

if [ -n "$SEG_DEBUG" ] ; then
  set -x
  env | sort
fi

cd $WEST_SIM_ROOT

DIST=$(mktemp)
RMSDBN=$(mktemp)
RMSDBS=$(mktemp)
NUMS=$(mktemp)
COMMAND="         parm $WEST_SIM_ROOT/common_files/system.top\n"
COMMAND="$COMMAND trajin $WEST_STRUCT_DATA_REF \n"
COMMAND="$COMMAND reference $WEST_SIM_ROOT/bstates/bstate.rst \n"
COMMAND="$COMMAND nativecontacts :1-109 :110-197 mindist out $DIST \n"
COMMAND="$COMMAND rms reference :1-119@CA \n"
COMMAND="$COMMAND rms reference :110-197@CA nofit out $RMSDBS \n"
COMMAND="$COMMAND rms reference :110-197@CA \n"
COMMAND="$COMMAND rms reference :1-109@CA nofit out $RMSDBN \n"
COMMAND="$COMMAND go\n"

echo -e "${COMMAND}" | $CPPTRAJ

paste <(cat $RMSDBN | tail -n +2 | awk '{print $2}') <(cat $RMSDBS | tail -n +2 | awk '{print $2}') > $NUMS
SQRT=$(cat $NUMS | awk {'print sqrt($1*$2)'})
paste <(cat $DIST | tail -n +2 | awk '{print $4}') <(echo $SQRT) > $WEST_PCOORD_RETURN

rm $DIST $RMSDBN $RMSDBS $NUMS

if [ -n "$SEG_DEBUG" ] ; then
  head -v $WEST_PCOORD_RETURN
fi
