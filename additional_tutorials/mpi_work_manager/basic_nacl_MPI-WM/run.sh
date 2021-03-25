#!/bin/bash
#SBATCH --nodes=4
#SBATCH --ntasks-per-node=20
#SBATCH --cluster=mpi
#SBATCH --partition=ib
#SBATCH --time=24:00:00
#SBATCH --job-name=nacl

# Make sure environment is set
source env.sh

# These variable are specific to Pitt CRC HPC cluster
export OMPI_MCA_pml=ob1
export OMPI_MCA_btl="self,tcp"
export OMPI_MCA_opal_warn_on_missing_libcuda=0

which mpirun
echo $SLURM_NTASKS

# Clean up
rm -f west.log

mpirun -n $SLURM_NTASKS \
          w_run --work-manager=mpi "$@"  &> west.log
