#!/bin/sh

module purge
module load gcc/8.2.0
module load openmpi/4.0.3
module load gromacs/2021.2


# Make the forcefield and symlink it here.
cd ../../gromacs_config || exit 1
bash makeff.sh
cd ../prep/1_pdb2gmx || exit 1
ln -s ../../gromacs_config/tip3p_ionsjc2008.ff tip3p_ionsjc2008.ff

gmx pdb2gmx \
  -f nacl_no_solvent.pdb \
  -ff tip3p_ionsjc2008 \
  -water tip3p \
  -o nacl_no_solvent_processed.gro
