# Modify to taste

# Load Modules
#KFW module purge
#KFW module load intel/2017.3.196 amber/18
#KFW 
#KFW module unload python
#KFW module load cuda/8.0.44
#KFW #module load intel-mpi
#KFW export CUDA_HOME=/opt/packages/cuda/8.0
#KFW export LD_LIBRARY_PATH=/opt/packages/cuda/8.0/lib64:$LD_LIBRARY_PATH

module purge
module load intel/2017.3.196
module load amber/18-2019_01
module rm python/intel-3.6

# This is our local scratch, where we'll store files during the dynamics.
export NODELOC=$LOCAL
export USE_LOCAL_SCRATCH=1

# Inform WEST where to find Python and our other scripts where to find WEST
# KFW export WEST_PYTHON=$(which python2.7)
# KFW if [[ -z "$WEST_ROOT" ]]; then
# KFW     echo "Must set environ variable WEST_ROOT"
# KFW     exit
# KFW fi

. ~/.bashrc
conda activate westpa

# Explicitly name our simulation root directory
if [[ -z "$WEST_SIM_ROOT" ]]; then
    # The way we're calling this, it's $SLURM_SUBMIT_DIR, which is fine.
    export WEST_SIM_ROOT="$PWD"
fi

# Set simulation name
export SIM_NAME=$(basename $WEST_SIM_ROOT)
echo "simulation $SIM_NAME root is $WEST_SIM_ROOT"

# Export environment variables for the ZMQ work manager.
export WM_ZMQ_MASTER_HEARTBEAT=100
export WM_ZMQ_WORKER_HEARTBEAT=100
export WM_ZMQ_TIMEOUT_FACTOR=300
export BASH=$SWROOT/bin/bash
export PERL=$SWROOT/usr/bin/perl
export ZSH=$SWROOT/bin/zsh
export IFCONFIG=$SWROOT/bin/ifconfig
export CUT=$SWROOT/usr/bin/cut
export TR=$SWROOT/usr/bin/tr
export LN=$SWROOT/bin/ln
export CP=$SWROOT/bin/cp
export RM=$SWROOT/bin/rm
export SED=$SWROOT/bin/sed
export CAT=$SWROOT/bin/cat
export HEAD=$SWROOT/bin/head
export TAR=$SWROOT/bin/tar
export AWK=$SWROOT/usr/bin/awk
export PASTE=$SWROOT/usr/bin/paste
export GREP=$SWROOT/bin/grep
export SORT=$SWROOT/usr/bin/sort
export UNIQ=$SWROOT/usr/bin/uniq
export HEAD=$SWROOT/usr/bin/head
export MKDIR=$SWROOT/bin/mkdir
export ECHO=$SWROOT/bin/echo
export DATE=$SWROOT/bin/date
export SANDER=$AMBERHOME/bin/sander
#KFW export PMEMD=$AMBERHOME/bin/pmemd.cuda
export PMEMD="$AMBERHOME/bin/pmemd.cuda -AllowSmallBox"
export CPPTRAJ=$AMBERHOME/bin/cpptraj
