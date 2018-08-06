#Makefile at top of application tree
TOP = .
include $(TOP)/configure/CONFIG
DIRS += configure
DIRS += ezca
DIRS += glue
DIRS += documentation
ifeq ($(MAKEFOR),MATLAB)
DIRS += matlab
endif
DIRS += testing
include $(TOP)/configure/RULES_TOP

UNINSTALL_DIRS+=jar

tarclean: UNINSTALL_DIRS:=$(filter-out %jar %html %doc,$(UNINSTALL_DIRS))

tarclean: uninstall
