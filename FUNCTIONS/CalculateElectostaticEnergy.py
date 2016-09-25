#!/usr/bin/python
from numpy import *
import math
import sys

def maplinalg(s): return map(linalg.norm,s)
def mapinverse(s): return map(inverse,s)
def inverse(s): return 1/s/1.889725989

file="CHARGES/charges" + str(sys.argv[1])
c=loadtxt("structure.xyz", skiprows=2, usecols=(1,2,3))
q=loadtxt(file, skiprows=2)

out=abs(c-c[:,None])
d=map(maplinalg,out)
d=map(mapinverse,d)
d=d*isfinite(d)
n=q*q[:,None]
print nansum(n*d)/2


