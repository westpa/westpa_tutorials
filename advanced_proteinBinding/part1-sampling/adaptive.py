from __future__ import print_function, division
import numpy
from west.propagators import WESTPropagator
from west.systems import WESTSystem
from westpa.binning import RectilinearBinMapper
from westpa.binning import FuncBinMapper
from westpa.binning import RecursiveBinMapper

import logging
log = logging.getLogger('westpa.rc')

PI = numpy.pi
from numpy import *
pcoord_dtype = numpy.float32
#THESE ARE THE FOUR THINGS YOU SHOULD CHANGE
bintargetcount=5 #number of walkers per bin
numberofdim=2  # number of dimensions
binsperdim=6   # excludes the minimum and maximum case. You will have binsperbin^numberofdim+numberofdim*3 bins total
pcoordlength=5 # lenth of the pcoord
PCA=False       # choose to do principal component analysis
maxcap=[22,inf]#these are in the order of the dimensions left is first dimension and right is second dimension
mincap=[18,0]
targetstate=[None, None]    #enter boundaries for target state or None if there is no target state in that dimension
targetstatedirection=-1  #if your target state is meant to be greater that the starting pcoor use 1 or else use -1
activetarget=0		#if no target state make this zero
splitIsolated=0     #choose 1 if you want to split the most isolated walker (this will add an extra bin)

#########
def function_map(coords, mask, output):
	varcoords=copy(coords)
	originalcoords=copy(coords)
	if PCA and len(output)>1:
		colavg=mean(coords, axis=0)
		for i in range(len(coords)):
			for j in range(len(coords[i])):
    	    			varcoords[i][j]=coords[i][j]-colavg[j]
		covcoords=cov(transpose(varcoords))
		eigval, eigvec=linalg.eigh(covcoords)
		eigvec=eigvec[:,argmax(absolute(eigvec),axis=1)]
		for i in range(len(eigvec)):
			if eigvec[i,i]<0:
				eigvec[:,i]=-1*eigvec[:,i]
		for i in range(numberofdim):
    			for j in range(len(output)):
    	    			coords[j][i]=dot(varcoords[j],eigvec[:,i])
	maxlist=[]
	minlist=[]
	difflist=[]
	orderedcoords=copy(originalcoords)
	for n in range(numberofdim):
		currentmax=amax(coords[:,n])
		currentmin=amin(coords[:,n])
		if maxcap[n]<currentmax:
                	currentmax=maxcap[n]
		if mincap[n]>currentmin:
                	currentmin=mincap[n]
		maxlist.append(currentmax)
		minlist.append(currentmin)
		temp=orderedcoords[:,n]
		temp.sort()
		difflist.append(0)
		maxdiff=0
		for i in range(1,len(temp)-1):
			if temp[i+1]<maxcap[n] and temp[i-1]>mincap[n]:
				if ((temp[i+1]-temp[i-1]))>maxdiff:
					difflist[n]=temp[i]
					maxdiff=(temp[i+1]-temp[i-1])	
	for i in range(len(output)):
		holder=2*numberofdim
		for n in range(numberofdim):
			if (activetarget==1) and targetstate[n] is not None:
				if (originalcoords[i,n]*targetstatedirection) >= (targetstate[n]*targetstatedirection):
					holder=binsperdim**numberofdim+numberofdim*3
			if (holder==binsperdim**numberofdim+numberofdim*2):
				n=numberofdim
			elif coords[i,n]>=maxlist[n] or originalcoords[i,n]>=maxcap[n]:
				holder= 2*n
				n=numberofdim
			elif coords[i,n]<=minlist[n] or originalcoords[i,n]<=mincap[n]:
				holder =2*n+1
				n=numberofdim
			elif coords[i,n]==difflist[n] and splitIsolated==1:
				holder=binsperdim**numberofdim+numberofdim*2+n
				n=numberofdim
		if holder==2*numberofdim:
			for j in range(numberofdim):
				holder = holder + (digitize(coords[i][j],linspace(minlist[j],maxlist[j],binsperdim+1))-1)*(binsperdim)**j
		output[i]=holder
	return output

class System(WESTSystem):
	def initialize(self):
		self.pcoord_ndim = numberofdim
		self.pcoord_len = pcoordlength
		self.pcoord_dtype = numpy.float32 
		self.bin_mapper = FuncBinMapper(function_map, binsperdim**numberofdim+numberofdim*(2+splitIsolated)+activetarget) #Changed binsperbin to binsperdim 
		self.bin_target_counts = numpy.empty((self.bin_mapper.nbins,), numpy.int_)
		self.bin_target_counts[...] = bintargetcount
