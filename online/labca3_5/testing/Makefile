#*************************************************************************
# Copyright (c) 2002 The University of Chicago, as Operator of Argonne
# National Laboratory.
# Copyright (c) 2002 The Regents of the University of California, as
# Operator of Los Alamos National Laboratory.
# This file is distributed subject to a Software License Agreement found
# in the file LICENSE that is included with this distribution. 
#*************************************************************************
#	Makefile.Host

TOP = ..
include $(TOP)/configure/CONFIG

# No need for RULES - and it 
# clashes with the realclean: target
# which has been present since 3.14.10...
#
#include $(TOP)/configure/RULES

install:: buildInstall

buildInstall:: build

build::lcaTest.m

#convert scilab test script to matlab
lcaTest.m:	lcaTest.sce
	@if ! sed -e 's$$//$$%$$' -e 's/\<sleep(1000[*]/pause(/g' -e's/mtlb_//g' -e"s/%nan/nan('double')/g" -e 's/%[ \t]*MATLABWARN/disp/' -e 's/\([ \t]then\)\([ \t]\|$$\)/\2/g' $< > $@ ;  then \
		echo "*** WARNING: Unable to create test script for MATLAB" ;  \
		echo "%*** WARNING: Unable to create test script for MATLAB" > $@ ;  \
	fi

clean::

realclean:: clean
	$(RM) lcaTest.m

#	EOF Makefile
