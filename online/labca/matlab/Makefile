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


USR_INCLUDES += -I../../ezca -I../../glue
# install header file
#INC =

# build share library
SHARED_LIBRARIES = YES

USR_CPPFLAGS += -DMATLAB_APP
#USR_INCLUDES += -I$(MATLABDIR)/extern/include

MEXF := lcaGetNelem
MEXF += lcaGet
MEXF += lcaGetStatus
MEXF += lcaGetGraphicLimits
MEXF += lcaGetControlLimits
MEXF += lcaGetPrecision
MEXF += lcaGetUnits
MEXF += lcaPut
MEXF += lcaPutNoWait
MEXF += lcaGetRetryCount
MEXF += lcaSetRetryCount
MEXF += lcaGetTimeout
MEXF += lcaSetTimeout
MEXF += lcaSetSeverityWarnLevel
MEXF += lcaClear
MEXF += lcaSetMonitor
MEXF += lcaNewMonitorValue
MEXF += lcaNewMonitorWait
MEXF += lcaDelay
MEXF += lcaLastError
ifeq ($(CONFIG_ECDRGET),YES)
MEXF += ecget
endif

MEXTARGET=$(addsuffix $(MEXEXT),$(MEXF))

MATDOCS=$(wildcard $(addprefix $(TOP)/documentation/help/,$(MEXF:%=%.m) Contents.m))

SCRIPTS+=$(notdir $(MATDOCS))


#       Library to build:
#       lib$(LIBRARY).a  or   ..dll/..exp/..lib
#

# need additional libs
PROD_LIBS := mezcaglue ezcamt ca Com

PROD_LIBS_WIN32+= ezcamt ca Com

ca_DIR = $(EPICS_BASE_LIB)
Com_DIR = $(EPICS_BASE_LIB)

## USR_LIBS_WIN32 += libmx libmex

## libmx_DIR     := $(MATLABDIR)/extern/lib/$(MATLIB_SUBDIR)
## libmex_DIR    := $(MATLABDIR)/extern/lib/$(MATLIB_SUBDIR)
mezcaglue_DIR := $(INSTALL_LIB)
ezcamt_DIR    := $(INSTALL_LIB)


ifndef BASE_3_14
ifeq ($(OS_CLASS),solaris)
ACC_DEP_CFLAGS = -KPIC -v
CCC_DEP_CFLAGS = -KPIC -v
endif
endif


INSTALL_PROD=$(MEXTARGET:%=$(INSTALL_BIN)/%)
# install matlab executables and help files
# to a 'labca' subdir so 'help labca' lists
# the 'Contents.m' summary
INSTALL_BIN:=$(INSTALL_BIN)/labca

include $(TOP)/configure/RULES
PRODNAME=$(MEXTARGET)



$(notdir $(MATDOCS)):%.m:$(TOP)/documentation/help/%.m 
	$(CP) $^ $@

MEXLIBS = $(PROD_LDLIBS)

$(PRODNAME):%$(MEXEXT):../%.c $(PROD_DEPLIBS)
	@$(RM) $@
	$(MATLABDIR)/bin/$(MEX) $(MEXCXXFLAGS) $(USR_CPPFLAGS) $< $(INCLUDES) $(PRODDIR_LDFLAGS) $(MEXLIBS)

build:	$(MEXTARGET)


buildInstall:
	@echo matdocs $(MATDOCS)

#	EOF Makefile.Host
