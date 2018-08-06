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
CMPLR = STRICT

# install header file
#INC = ezca.h

#
#	Contents of library: generic, special and for all systems
#

# on generic system
ezcamt_SRCS := ezca.c



#       Library to build:
#       lib$(LIBRARY).a  or   ..dll/..exp/..lib
#
# use different name for multi-threaded fit version
LIBRARY_HOST := ezcamt

# need additional libs

ezcamt_LIBS := ca Com
ca_DIR = $(EPICS_BASE_LIB)
Com_DIR = $(EPICS_BASE_LIB)


SHRLIB_VERSION:=0

GCC_DEP_CFLAGS += -Wno-format

include $(TOP)/configure/RULES

#	EOF Makefile.Host
