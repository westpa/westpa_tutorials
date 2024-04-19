#!/bin/bash
module purge
module load gcc/8.2.0
module load openmpi/4.0.3
module load gromacs/2021.2

gmx distance -f 3_min.gro -s 3_min.tpr 
 
