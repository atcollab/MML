# ALS Simple Channel Access Makefile.linux
# changed for solaris 2.5 using Sunpro compiler
# and dynamic linking (libsca.a)

#CC = acc
#CC = /opt/SUNWspro/bin/cc
CC = gcc
#RELEASE = /home/als2/devel/als_std_epics/
RELEASE = /usr/local/EPICS_R3.13.5
BASE = $(RELEASE)/base
INCLUDES = $(BASE)/include
INCLUDE_JAVA = /vol/pub/java-1.2_01/include
INCLUDE_JAVA_SOLARIS = $(INCLUDE_JAVA)/solaris
#OS = sun4 
#OS = solaris
OS = Linux
DBG =
CFLAGS_SO =
#CFLAGS= -R.:/local/prod/lib:/opt/local/lib
#SUNOS_DIST = /home/als2/www/docs/epics_collaboration/sca/sunos
#SCA_DIST = /home/als2/www/docs/epics_collaboration/sca
#SOLARIS2_DIST = csg:~ftp/pub/als/epics/solaris2

all: info scaget scaput libsca.a  \
	sca3_example sca3a_example \
	group_test alias_test connect_test sca2test

libsca.a : Makefile.linux ./scalib.c ./scalib_private.h ./scalib_shared.h
	$(CC) $(DBG) $(CFLAGS_SO)  -I$(INCLUDES) -I. -c scalib.c -o libsca.o
	ar rcs libsca.a libsca.o

scaput : Makefile.linux ./scaput.c ./scaget.h ./scalib.h ./scalib_shared.h ./libsca.a
	rm -f core
	rm -f scaput
	$(CC) $(DBG) $(CFLAGS) -I. -o scaput ./scaput.c -L. -L$(BASE)/lib/$(OS)  -lsca -lca -lCom 

scaget : Makefile.linux ./scaget.c ./scaget.h ./scalib.h ./scalib_shared.h ./libsca.a
	rm -f core
	rm -f scaget
	$(CC) $(DBG) $(CFLAGS) -I. -o scaget ./scaget.c -L. -L$(BASE)/lib/$(OS) -lsca -lca -lCom 

sca3_example : Makefile.linux ./sca3_example.c ./scalib.h ./scalib_shared.h ./libsca.a
	rm -f core
	rm -f sca3_example
	$(CC) $(DBG) $(CFLAGS) -I. \
		-o sca3_example ./sca3_example.c \
		-L$(BASE)/lib/$(OS) -L. -lsca -lca -lCom

sca3a_example : Makefile.linux ./sca3_example.c ./scalib.h ./libsca.a
	rm -f core
	rm -f sca3a_example
	$(CC) $(DBG) $(CFLAGS) -DUSE_CACHE_PUT -I. \
		-o sca3a_example ./sca3_example.c \
		-L$(BASE)/lib/$(OS) -L. -lsca -lca -lCom

group_test : Makefile.linux ./group_test.c ./scalib.h ./scalib_shared.h ./libsca.a
	rm -f core
	rm -f group_test
	$(CC) $(DBG) $(CFLAGS) -I. \
		-o group_test ./group_test.c \
		-L$(BASE)/lib/$(OS) -L. -lsca -lca -lCom

index_example : Makefile.linux ./index_example.c ./scalib.h ./scalib_shared.h \
        ./libsca.a
	rm -f core
	rm -f index_example
	$(CC) $(DBG) $(CFLAGS) -I. \
        -o index_example ./index_example.c \
		-L$(BASE)/lib/$(OS) -L. -lsca -lca -lCom

indexa_example : Makefile.linux ./index_example.c ./scalib.h ./scalib_shared.h \
        ./libsca.a
	rm -f core
	rm -f indexa_example
	$(CC) $(DBG) $(CFLAGS) -DUSE_CACHE_PUT -I. \
        -o indexa_example ./index_example.c \
		-L$(BASE)/lib/$(OS) -L. -lsca -lca -lCom

sca2test : Makefile.linux ./sca2test.c ./scalib.h ./scalib_shared.h ./libsca.a
	rm -f core
	rm -f sca2test
	$(CC) $(DBG) $(CFLAGS) -I. \
        -o sca2test ./sca2test.c \
		-L$(BASE)/lib/$(OS) -L. -lsca -lca -lCom

alias_test : Makefile.linux ./alias_test.c ./scalib.h ./scalib_shared.h ./libsca.a
	rm -f core
	rm -f alias_test
	$(CC) $(DBG) $(CFLAGS) -I. \
        -o alias_test ./alias_test.c \
		-L$(BASE)/lib/$(OS) -L. -lsca -lca -lCom

connect_test : Makefile.linux ./connect_test.c ./scalib.h ./scalib_shared.h ./libsca.a
	rm -f core
	rm -f connect_test
	$(CC) $(DBG) $(CFLAGS) -I. \
        -o connect_test ./connect_test.c \
		-L$(BASE)/lib/$(OS) -L. -lsca -lca -lCom

test_compress : Makefile.linux ./test_compress.c ./scalib.h ./scalib_shared.h \
    ./libsca.a
	rm -f core
	rm -f test_compress
	$(CC) $(DBG) $(CFLAGS) -I. \
        -o test_compress ./test_compress.c \
		-L$(BASE)/lib/$(OS) -L. -lsca -lca -lCom

info:
	@echo "make DBG=-g    #for debug  mode"

clean:
	rm -f core
	rm -f libsca.a
	rm -f libsca.a
	rm -f scaget
	rm -f scaput

	rm -f sca3_time
	rm -f sca3_example
	rm -f sca3a_example
	rm -f index_example
	rm -f indexa_example
	rm -f group_test
	rm -f sca.tar
	rm -f sca.tar.gz

#include ../include/makelib
