#!/bin/bash
module purge
module load gcc/8.2.0
module load openmpi/4.0.3
module load gromacs/2021.2

ln -s ../1_pdb2gmx/posre.itp .

gmx grompp \
  -f 4_eq1.mdp \
  -c ../3_min/3_min.gro\
  -r ../3_min/3_min.gro\
  -p ../1_pdb2gmx/topol.top\
  -o 4_eq1.tpr

gmx mdrun \
  -s 4_eq1.tpr \
  -deffnm 4_eq1 \
  -mp ../1_pdb2gmx/topol.top\
  -v
