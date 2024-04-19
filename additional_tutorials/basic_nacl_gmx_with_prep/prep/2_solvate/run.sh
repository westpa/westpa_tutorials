#!/bin/bash

module purge
module load gcc/8.2.0
module load openmpi/4.0.3
module load gromacs/2021.2

gmx editconf \
  -f ../1_pdb2gmx/nacl_no_solvent_processed.gro\
  -c\
  -d 1.2\
  -bt octahedron\
  -o nacl_no_solvent_with_box.gro

gmx solvate \
  -cp nacl_no_solvent_with_box.gro\
  -cs spc216.gro\
  -p ../1_pdb2gmx/topol.top\
  -o nacl_solvated.gro
