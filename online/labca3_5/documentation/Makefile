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

# Broken: scilab 5 under windows executable is 'scilex' :-(
# but we have no T_A/OS_CLASS to test here
SCILAB=$(SCILABDIR)/bin/scilab

# Only scilab 5 can return a nonzero 'exit' code
#define scilab-lt-5
#	$(SCILAB) -nb -nw -e 'exit(sign(msscanf(getversion(),"scilab-%i")-5)+1)' >/dev/null 2>&1
#endef

TEST_D=perl -MExtUtils::Command -e test_d

HELP_AUTOGEN_CHAPTERS:=$(shell sed -n -e 's/\(.*[^b]subsection.*[{][ \t]*\)\(lca[a-zA-Z0-9]*\).*/\2/gp' manual.tex)

HELPS=$(patsubst %,help/%.html,$(HELP_AUTOGEN_CHAPTERS))

MHELPS=$(HELPS:%.html=%.m)

SCI5HELPS=$(patsubst %,xmlhelp/en_US/%.xml,$(HELP_AUTOGEN_CHAPTERS))
SCI5HELPS+=xmlhelp/en_US/Common.xml
SCI5HELPS+=xmlhelp/en_US/Error.xml

DOCS+=manual.pdf
MANHTMLS=$(wildcard manual/*)
HTMLS+=$(HELPS) help/whatis.htm $(MANHTMLS)

INSTALL_SCI5_HELPJAR=$(INSTALL_LOCATION)/jar/scilab_en_US_help.jar

$(INSTALL_HTML)/$(HTMLS_DIR)/%: %
	@echo "Installing HTML Help/Documentation $@"
	@$(INSTALL) -d -m 644 $< $(@D)

$(INSTALL_DOC)/%:%
	@echo "Installing PDF Documentation $@"
	@$(INSTALL) -d -m 644 $< $(@D)

install: buildInstall

buildInstall: build $(INSTALL_DOCS) $(INSTALL_HTMLS) $(INSTALL_SCI5_HELPJAR)

clean::

$(sort manual/index.html $(wildcard manual/*.html)): manual.aux
	latex2html -no_footnode -split 5 -link 1 manual.tex

$(HELPS): manual.aux
	$(TEST_D) help || $(MKDIR) help
	latex2html -no_footnode -split 5 -link 0 -no_navigation -no_antialias_text -long_titles 1 -dir help manual.tex

%.pdf %.aux: %.tex
	pdflatex $^
	pdflatex $^


help/whatis.htm: whatis.htm
	$(TEST_D) help || $(MKDIR) help
	$(RM) $@
	cp $< $@

help/Contents.m: Contents.m
	$(TEST_D) help || $(MKDIR) help
	$(RM) $@
	cp $< $@


# html->text, add leading '%' and remove long URLs, just leave filename
%.m:%.html
	$(RM) $@
	lynx -dump $^ | sed -e 's/^/%/g'  -e 's/\([0-9]*[.][ ]*\)\(file:\([^/]*[/]\)*\)\(.*\)\([.]html.*\)/\4 \1\4/g' > $@

build: manual/index.html $(MHELPS) help/Contents.m

# make again for the HTMLS wildcard expansion to find the newly created files
ifeq ($(MANHTMLS)xx,xx)
build:
	$(MAKE)
endif

xmlclean:
	$(RM)    xmlhelp/en_US/lca*.xml xmlhelp/en_US/master_help.xml
	$(RM) -r xmlhelp/en_US/scilab_en_US_help/
	$(RM) -r jar

# prepare '.sci' file based on '.m'. This must be hand-tuned
# to a xmlhelp/en_US/%.sci file which can be translated into xml by
# help_from_sci()
xmlhelp/en_US/%.sci: help/%.m
	sed -e '1s/^%/function /' -e '1,$$s#^%#//#' -e 's/References/See also/' -e '$$a\
endfunction' $^ > $@	
	# extract first sentence and insert into first line
	# insert as second line
	sed $@ -i -e "1a\// `sed $@ -e 's#^[/][/]##g' | tr '\n' ' ' | sed -e 's/\(.*Description[ \t]*\)\([^.]*[.]\)\(.*\)/\2/'`"


xmlhelp/en_US/lca%.xml: xmlhelp/en_US/lca%.sci
	$(RM) $@
	$(SCILAB) -nb -nw -e 'help_from_sci("$(@:%.xml=%.sci)","./xmlhelp/en_US"); quit;'

./jar/scilab_en_US_help.jar: $(SCI5HELPS)
	$(RM) $@
	$(SCILAB) -nb -nw -e 'xmltojar("xmlhelp/en_US","labCA"); quit'

$(INSTALL_LOCATION)/jar/scilab_en_US_help.jar: ./jar/scilab_en_US_help.jar $(INSTALL_LOCATION)/jar 
	@$(INSTALL) -d -m 644 $< $(@D)

$(INSTALL_LOCATION)/jar:
	-$(TEST_D) $@ || $(MKDIR) $@
	

.SECONDARY:

realclean:: clean xmlclean
	$(RM) -r help
	$(RM) -r manual 
	$(RM) *.aux *.dvi *.log *.pdf *.out *.ps
	$(RM) *~
test:
	echo $(SCI5HELPS)
