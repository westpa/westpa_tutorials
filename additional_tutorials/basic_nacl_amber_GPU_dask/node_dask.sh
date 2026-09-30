#!/bin/bash -l

set -x

cd $1; shift
source env.sh
export WEST_JOBID=$1; shift
export SLURM_NODENAME=$1; shift
export WEST_DASK_SERVER_FILE=$1; shift
export CUDA_VISIBLE_DEVICES_ALLOCATED=$1; shift
# export LOCAL=/local/$WEST_JOBID
echo "starting WEST client processes on: "; hostname
echo "current directory is $PWD"
echo "environment is: "
env | sort

echo "CUDA_VISIBLE_DEVICES_ALLOCATED = " $CUDA_VISIBLE_DEVICES_ALLOCATED
export CUDA_DEVICES=(`echo $CUDA_VISIBLE_DEVICES_ALLOCATED | tr , ' '`)
echo "CUDA_DEVICES = " ${CUDA_DEVICES[@]}

for cid in ${CUDA_DEVICES[@]}; do
    # Change $cid if you want to expose multiple gpus to a single worker
    # Change nworkers if you want to expose the same GPU to multiple workers 
    echo "cid = " $cid
    CUDA_VISIBLE_DEVICES=$cid dask worker --scheduler-file $WEST_DASK_SERVER_FILE --nworkers 1 "$@" &>> west-dask-$SLURM_NODENAME-node.log &
done

wait

echo "Shutting down.  Hopefully this was on purpose?"
