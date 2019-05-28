#!/bin/bash
#SBATCH --job-name=p53
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=12
#SBATCH --output=job_logs/slurm.out
#SBATCH --error=job_logs/slurm.err
#SBATCH --time=72:00:00
#SBATCH --cluster=smp
#
# run.sh
#
# Run the weighted ensemble simulation. Make sure you ran init.sh first!
#

module purge
module load intel/2017.3.196 amber/18
module unload python
export WEST_PYTHON=($which python2.7)
source env.sh

rm -f west.log
$WEST_ROOT/bin/w_run --work-manager processes "$@" &> west.log
${SLURM_JOB_ID}
