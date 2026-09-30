#!/bin/bash
#SBATCH --job-name=CPU
#SBATCH --output=slurm.out
#SBATCH --nodes=2
#SBATCH --ntasks-per-node=48
#SBATCH --cluster=mpi
#SBATCH --partition=mpi
#SBATCH --time=24:00:00

# Setup Environment
set -x
cd $SLURM_SUBMIT_DIR
source env.sh || exit 1

env | sort

cd $WEST_SIM_ROOT
SERVER_INFO=$WEST_SIM_ROOT/west_dask_info-$SLURM_JOBID.json

# start scheduler
dask scheduler --scheduler-file $SERVER_INFO &

echo 'started scheduler'

# start workers
for node in $(scontrol show hostname $SLURM_NODELIST); do
    ssh -o StrictHostKeyChecking=no $node $PWD/node_dask.sh $SLURM_SUBMIT_DIR $SLURM_JOBID $node $SERVER_INFO $SLURM_NTASKS_PER_NODE &
done

echo 'started workers'

if [ ! -f west.h5 ]; then
    ./init.sh
fi


# Run WESTPA
w_run --work-manager=dask --dask-scheduler-file $SERVER_INFO --dask-shutdown-on-exit --dask-n-retries 3 &> west-$SLURM_JOBID.log

echo "Shutting down.  Hopefully this was on purpose?"
