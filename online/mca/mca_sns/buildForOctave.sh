#!/bin/sh
#
# Provided by Eric Norum, APS, Dec. 2006

MEX="mkoctfile --mex" FLAGS="-DmexAtExit=atexit" make MEXOUT=mex install
rm -f Channel.o MCAError.o TestHash.cpp mca.o
