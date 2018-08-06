#*************************************************************************
# Copyright (c) 2002 The University of Chicago, as Operator of Argonne
# National Laboratory.
# Copyright (c) 2002 The Regents of the University of California, as
# Operator of Los Alamos National Laboratory.
# This file is distributed subject to a Software License Agreement found
# in the file LICENSE that is included with this distribution. 
#*************************************************************************
#
# Makefile,v 1.3 2002/08/02 15:38:41 jba Exp
#
TOP = ..
T_A = cheat
include $(TOP)/configure/CONFIG

HELPS+=help/lcaDebugOn.html
HELPS+=help/lcaGetControlLimits.html
HELPS+=help/lcaGetGraphicLimits.html
HELPS+=help/lcaGet.html
HELPS+=help/lcaGetNelem.html
HELPS+=help/lcaGetPrecision.html
HELPS+=help/lcaGetRetryCount.html
HELPS+=help/lcaGetStatus.html
HELPS+=help/lcaGetTimeout.html
HELPS+=help/lcaGetUnits.html
HELPS+=help/lcaPut.html
HELPS+=help/lcaPutNoWait.html
HELPS+=help/lcaSetSeverityWarnLevel.html
HELPS+=help/lcaClear.html
HELPS+=help/lcaSetMonitor.html
HELPS+=help/lcaNewMonitorValue.html
HELPS+=help/lcaNewMonitorWait.html
HELPS+=help/lcaDelay.html
HELPS+=help/lcaLastError.html

MHELPS=$(HELPS:%.html=%.m)

DOCS+=manual.pdf
MANHTMLS=$(wildcard manual/*)
HTMLS+=$(HELPS) help/whatis.htm $(MANHTMLS)

$(INSTALL_HTML)/$(HTMLS_DIR)/%: %
	@echo "Installing HTML Help/Documentation $@"
	@$(INSTALL) -d -m 644 $< $(@D)

$(INSTALL_DOC)/%:%
	@echo "Installing PDF Documentation $@"
	@$(INSTALL) -d -m 644 $< $(@D)

install: buildInstall

buildInstall: build $(INSTALL_DOCS) $(INSTALL_HTMLS)

clean::

$(sort manual/index.html $(wildcard manual/*.html)): manual.aux
	latex2html -no_footnode -split 5 -link 1 manual.tex

$(HELPS): manual.aux
	if [ ! -x help ] ; then mkdir help; fi
	latex2html -no_footnode -split 5 -link 0 -no_navigation -no_antialias_text -long_titles 1 -dir help manual.tex

%.pdf %.aux: %.tex
	pdflatex $^
	pdflatex $^


help/whatis.htm: whatis.htm
	if [ ! -x help ] ; then mkdir help; fi
	$(RM) $@
	cp $< $@

help/Contents.m: Contents.m
	if [ ! -x help ] ; then mkdir help; fi
	$(RM) $@
	cp $< $@


# html->text, add leading '%' and remove long URLs, just leave filename
%.m:%.html
	$(RM) $@
	lynx -dump $^ | sed -e 's/^/%/g'  -e 's/\([0-9]*[.][ ]*\)\(file:\([^/]*[/]\)*\)/\1/g'  > $@

build: manual/index.html $(MHELPS) help/Contents.m

# make again for the HTMLS wildcard expansion to find the newly created files
ifeq ($(MANHTMLS)xx,xx)
build:
	$(MAKE)
endif

.SECONDARY:

realclean::
	$(RM) -r help
	$(RM) -r manual 
	$(RM) *.aux *.dvi *.log *.pdf *.out *.ps
	$(RM) *~
