import sys
import h5py
import numpy


####### READ IN TAU FROM COMMAND LINE  #############
if len(sys.argv) == 2 :
   tau = float(sys.argv[1]) 
else :
   print "\n\nPLEASE, PROVIDE TAU (IN SECONDS) AS A COMMAND LINE ARGUMENT, E.G.:\n\n\t'python get_mean_rate.py 20e-12'\n\n\n"
   sys.exit()
###################################################################################
 


####### READ IN THE FLUX AT EVERY ITERATION #############
fluxanl              = h5py.File('fluxanl.h5')
flux		     = numpy.array(fluxanl['target_flux']['target_0']['flux'])
###########################################################################################



###### GET THE AVERAGE, WRITE OUT THE RATE AS A FUNCTION OF MOLECULAR TIME ####################
FileOut =  open("mean_rate.dat", "w")
print>>FileOut, "#molecular time [ns]\trate [1/s]\n"

for i in range(len(flux)) :
   if i <= 49 :
      flux_mean = sum(flux[0 : (i+1)])  /  (i+1)   
   else :
      flux_mean  = sum(flux[i - 49 : i+1])  / 50

   print>>FileOut, "{0:.3f}".format((i+1)/(1e-9/tau)), "\t\t", "{0:.8e}".format(flux_mean/tau)
###########################################################################################



