#!/bin/bash
#SBATCH --job-name=nacl
#SBATCH --output=slurm.out
#SBATCH --nodes=8
#SBATCH --ntasks-per-node=28
#SBATCH --cluster=mpi
#SBATCH --partition=opa
#SBATCH --time=12:00:00

# Make sure environment is set
source env.sh

export OMPI_MCA_pml=ob1
export OMPI_MCA_btl="self,tcp"
export OMPI_MCA_opal_warn_on_missing_libcuda=0

which mpirun
echo $SLURM_NTASKS
echo $WEST_ROOT
echo $WEST_PYTHON
echo $WEST_BIN

# Clean up
rm -f west.log

# Run w_run
mpirun -n $SLURM_NTASKS \
          w_run --work-manager=mpi "$@" &> west.log
