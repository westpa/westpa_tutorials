#!/bin/bash
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=12
#SBATCH --cluster=smp
#SBATCH --partition=high-mem
#SBATCH --time=24:00:00
#SBATCH --job-name=nacl

# Make sure environment is set
source env.sh

# Clean up
rm -f west.log

# Run w_run
w_run --work-manager processes "$@" &> west.log
##w_run --debug --work-manager processes "$@" &> west.log
