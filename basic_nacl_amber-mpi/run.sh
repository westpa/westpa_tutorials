#!/bin/bash
#!/bin/bash
#SBATCH --job-name=nacl
#SBATCH --output=slurm.out
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=12
#SBATCH --cluster=smp
#SBATCH --partition=high-mem
#SBATCH --time=5:00:00

# Make sure environment is set
source env.sh

# Clean up
rm -f west.log

# Run w_run
$WEST_ROOT/bin/w_run --work-manager processes "$@" &> west.log
