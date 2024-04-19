#!/bin/sh
module purge
module load gcc/8.2.0
module load openmpi/4.0.3
module load gromacs/2021.2
gmx grompp \
  -f minimize.mdp \
  -c ../2_solvate/nacl_solvated.gro \
  -p ../1_pdb2gmx/topol.top \
  -o 3_min.tpr

gmx mdrun \
  -deffnm 3_min\
  -mp ../1_pdb2gmx/topol.top\
  -nt 1\
  -v 

