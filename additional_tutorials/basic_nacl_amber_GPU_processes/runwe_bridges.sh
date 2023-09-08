#!/bin/bash
#SBATCH --job-name=GPU
#SBATCH --output=slurm.out
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=4
#SBATCH --cluster=GPU
#SBATCH --partition=gtx1080
#SBATCH --gres=gpu:4
#SBATCH --time=24:00:00

#set -x
#cd $SLURM_SUBMIT_DIR
source env.sh || exit 1

env | sort

cd $WEST_SIM_ROOT

# The number of workers here should match the number of GPU you request above.
w_run --work-manager=processes --n-workers=4 "$@" &> west-$SLURM_JOBID.log
