# This file defines where WEST and GROMACS can be found
# Modify to taste

export SCRATCH=$SCRATCH
export WEST_ROOT='/mnt/home/alexrd/westpa'
export GROMACS_ROOT='/opt/software/GROMACS/2018-foss-2018a'
export WEST_PYTHONPATH='/mnt/home/alexrd/WESTPA-WExplore/westpa_wexplore'
export WEST_PYTHON='/mnt/research/DicksonLab/programs/anaconda3/envs/WESTPA-WExplore/bin/python'

export PATH="$WEST_PYTHONPATH:$PWD:$ANACONDA_ROOT/bin:$WEST_ROOT/bin/:$GROMACS_ROOT/bin/:$PATH"
export LD_LIBRARY_PATH="$ANACONDA_ROOT/lib:$GROMACS_ROOT/bin:$LD_LIBRARY_PATH"

# General stuff now

export WM_ZMQ_MASTER_HEARTBEAT=100
export WM_ZMQ_WORKER_HEARTBEAT=100
export WM_ZMQ_TIMEOUT_FACTOR=100
export WEST_ZMQ_DIRECTORY=server_files
export WEST_LOG_DIRECTORY=job_logs

# Files for running the system inside of GROMACS.

export GMX=gmx
export TOP=18-crown-6-K+.top
export NDX=18-crown-6-K+.ndx
export REF=bound_state.tpr
