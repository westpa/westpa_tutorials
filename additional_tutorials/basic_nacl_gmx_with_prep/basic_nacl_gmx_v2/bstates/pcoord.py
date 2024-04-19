import mdtraj as md 
import numpy as np 
import argparse

# Create an argument parser
parser = argparse.ArgumentParser(description='Compute distances between Na and Cl atoms in a trajectory.')
parser.add_argument('traj_file', type=str, help='Path to the trajectory file')
parser.add_argument('top_file', type=str, help='Path to the topology file')

# Parse the command-line arguments
args = parser.parse_args()

trj=md.load(args.traj_file, top=args.top_file)
with open('pcoord.txt','w') as file:
    dist = md.compute_distances(trj, np.array([trj.top.select('resname Na'),trj.top.select('resname Cl')]).T)*10
    #file.write(str(dist))
    np.savetxt(file, dist, fmt='%d')
