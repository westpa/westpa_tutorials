#!/usr/bin/env python

import numpy as np
from numpy.random import normal as random_normal

SEG_STATUS_COMPLETE = 2

PI = np.pi

coord_len = 21
coord_dtype = np.float32

A = 2
B = 10
C = 0.5
x0 = 1

# Implement a reflecting boundary at this x value
# (or None, for no reflection)
reflect_at = 10.0

coords = np.empty(coord_len, dtype=coord_dtype)

f = open('odld.crd', 'r')
coords[0] = f.readline()
f.close

twopi_by_A = 2 * PI / A
half_B = B / 2
sigma = 0.001 ** (0.5)
gradfactor = sigma * sigma / 2
all_displacements = np.zeros(coord_len, dtype=coord_dtype)

for istep in range(1, coord_len):
    x = coords[istep - 1]
    
    xarg = twopi_by_A * (x - x0)
    
    eCx = np.exp(C * x)
    eCx_less_one = eCx - 1.0

    all_displacements[istep] = displacements = random_normal(scale=sigma, size=(1,))
    grad = half_B / (eCx_less_one * eCx_less_one) * (twopi_by_A * eCx_less_one * np.sin(xarg) + C * eCx * np.cos(xarg))

    newx = x - gradfactor * grad + displacements

    if reflect_at is not None:
        # Anything that has moved beyond reflect_at must move back that much

        # boolean array of what to reflect
        to_reflect = newx > reflect_at

        # how far the things to reflect are beyond our boundary
        reflect_by = newx[to_reflect] - reflect_at

        # subtract twice how far they exceed the boundary by
        # puts them the same distance from the boundary, on the other side
        newx[to_reflect] -= 2 * reflect_by

    coords[istep] = newx

f = open('odld.rst', 'w')
f.write('{:12.8f}'.format(coords[coord_len-1])+'\n')
f.close

f = open('pcoords.dat', 'w')
for element in coords.flat:
    f.write('{:12.8f}'.format(element)+'\n')
f.close

f = open('displacements.dat', 'w')
for element in all_displacements.flat:
    f.write('{:12.8f}'.format(element)+'\n')
f.close

