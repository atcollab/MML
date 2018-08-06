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

USR_INCLUDES += -I../../ezca

# build share library
SHARED_LIBRARIES = YES

ifeq ($(MAKEFOR),MATLAB)
#PROD_HOST += gnelm
ifeq ($(OS_CLASS),WIN32)
#LIB_LIBS += libut libmx libmex
# $(addprefix) et al. can't deal with paths containing white space
# therefore, we assemble the list of dlls manually :-(
TARGET_LDFLAGS += $(MATLABDIR)/extern/lib/$(MATLIB_SUBDIR)/libut.lib
TARGET_LDFLAGS += $(MATLABDIR)/extern/lib/$(MATLIB_SUBDIR)/libmx.lib
TARGET_LDFLAGS += $(MATLABDIR)/extern/lib/$(MATLIB_SUBDIR)/libmex.lib
else
LIB_LIBS += mx mex ut
#CC         = $(MATLABDIR)/bin/mex -cxx
#CFLAGS=$(CPPFLAGS) $(INCLUDES) $(CTRLC_CFLAGS_$(CONFIG_USE_CTRLC))
endif
else
ifeq ($(OS_CLASS),WIN32)
USR_CPPFLAGS += -DFORDLL
LIB_LIBS += LibScilab
endif
endif


#
#	Contents of library: generic, special and for all systems
#

CTRLC_SRC_YES = ctrlC-polled.c

CTRLC_SRC_NO  = ctrlC-def.c
CTRLC_CFLAGS_NO = -DCTRLC_DISABLED

CFLAGS += $(CTRLC_CFLAGS_$(CONFIG_USE_CTRLC))

LIB_SRCS += ini.cc multiEzca.c $(CTRLC_SRC_$(CONFIG_USE_CTRLC))

ifeq ($(CONFIG_ECDRGET),YES)
PROD_SRCS += ecget.c
USR_CPPFLAGS += -DWITH_ECDRGET
endif

# for win32 they don't define LOADABLE_SHRLIBNAME :-(
ifeq ($(OS_CLASS),WIN32)
LOADABLE_PREFIX=
else
LOADABLE_PREFIX=LOADABLE_
endif

# on generic system
ifeq ($(MAKEFOR),MATLAB)
USR_CPPFLAGS += -DMATLAB_APP
USR_INCLUDES += -I$(MATLABDIR)/extern/include
LIB_SRCS += mglue.c
$(LOADABLE_PREFIX)LIBRARY_HOST := mezcaglue
#SCRIPTS+=mkmezca.m
else
USR_CPPFLAGS+=-DSCILAB_APP
USR_INCLUDES += -I$(SCILABDIR)/routines -I../sciclean
LIB_SRCS+= ezcaSciCint.c
LIB_SRCS+= sciclean.c
$(LOADABLE_PREFIX)LIBRARY_HOST := sezcaglue
SCRIPTS+=labca.sce
endif

gnelm_SRCS = gnelm.c
gnelm_LIBS = $($(LOADABLE_PREFIX)LIBRARY_HOST)
gnelm_LIBS += $(LIB_LIBS)
gnelm_LIBS += ca Com

ca_DIR = $(EPICS_BASE_LIB)
Com_DIR = $(EPICS_BASE_LIB)

#       Library to build:
#       lib$(LIBRARY).a  or   ..dll/..exp/..lib
#

# need additional libs
LIB_LIBS  +=ezcamt
SHRLIB_VERSION:=0
LOADABLE_SHRLIB_VERSION=0

# USR_LIBS_xxx doesn't work under EPICS 3.14.2 :-(
# USR_LIBS_WIN32 += libmx libmex
LIB_LIBS_WIN32 += ca Com

USR_SYS_LIBS_WIN32 += user32

# matlab tries to unload MEX files on exit;
# since we cannot exit ezca/CA cleanly, this
# might crash! These options enforce locking
# our library stack into memory..
#ACC_SHRLIB_LDFLAGS_YES+=-z nodelete
#CCC_SHRLIB_LDFLAGS_YES+=-z nodelete
#GCC_SHRLIB_LDFLAGS_YES+=-Wl,-z,nodelete
#G++_SHRLIB_LDFLAGS_YES+=-Wl,-z,nodelete

# these are not used since we pass the path manually (TARGET_LDFLAGS above)
libmx_DIR  := $(MATLABDIR)/extern/lib/$(MATLIB_SUBDIR)
libmex_DIR := $(MATLABDIR)/extern/lib/$(MATLIB_SUBDIR)
libut_DIR  := $(MATLABDIR)/extern/lib/$(MATLIB_SUBDIR)

mx_DIR  := $(MATLABDIR)/bin/$(MLBARCH)
mex_DIR := $(MATLABDIR)/bin/$(MLBARCH)
ut_DIR  := $(MATLABDIR)/bin/$(MLBARCH)

export LD_LIBRARY_PATH:=$(LD_LIBRARY_PATH):$(mx_DIR)

LibScilab_DIR:=$(SCILABDIR)/bin
mezcaglue_DIR:=$(INSTALL_LIB)

ezcamt_DIR := $(INSTALL_LIB)

ifndef BASE_3_14
ifeq ($(OS_CLASS),solaris)
ACC_DEP_CFLAGS = -KPIC -v
CCC_DEP_CFLAGS = -KPIC -v
endif
endif

ifeq ($(OS_CLASS),WIN32)
LIBSUB=bin
else
LIBSUB=lib
endif

include $(TOP)/configure/RULES


$($(LOADABLE_PREFIX)SHRLIBNAME): ../$($(LOADABLE_PREFIX)LIBRARY_HOST).def

mkmezca.m: ../mkmezca.m.tmpl
	sed -e 's/%%TARCH%%/$(T_A)/g' -e 's/%%ARCH%%/$(OS_CLASS)/g' -e 's$$%%EPICS_BASE%%$$$(EPICS_BASE)$$g' < $^ >$@

%.sce: ../%.sce.in
	$(RM) $@
	sed -e 's%THELIB%$(LIBSUB)/$(T_A)/$($(LOADABLE_PREFIX)SHRLIBNAME)%g' -e 's/THEFILE/$@/g' <$^ >$@

../%.def: ../%.def.in
	$(CPP) $(CPPFLAGS) -I$(SCILABDIR)/routines $< | sed -n -e '/LIBRARY[ ]*$($(notdir $@):%.def=%)/,$$p' > $@

ifneq ($(OS_CLASS),WIN32)
PRODNAME_LINKER=$(MATLABDIR)/bin/$(MEX) -f $(MATLABDIR)/bin/engopts.sh $(TARGET_LDFLAGS) $(USR_LDFLAGS) $(OP_SYS_LDFLAGS) -output $@
endif

#	EOF Makefile.Host
check_name:
	echo $($(LOADABLE_PREFIX)SHRLIBNAME)

sciclean.c: sciclean/sciclean.c
	ln -s $^ $@
