CORE       = ../
#CORE       = /u/rl/yan/Zlib
SRC        = $(CORE)
LIB        = $(CORE)lib
ZLIB     = /u/rl/yan/Zlib/lib

INCLUDES   =  -I../usr/include -I/usr/lib/g++-include \
              -I$(CORE) \
              -I../usr/local \
	      -I/u/rl/yan/Zlib \
	      -I/u/ap/yunhai/aix/bbi/inc \



CFLAGS     = $(INCLUDES)

#COMPILE    = g++ -c -g
COMPILE    = g++ -c -O3
#COMPILE    = /u/ap/yunhai/mpich/bin/mpiCC -c -O3

#LIBRARIES  = -L$(ZLIB) -lZlib -L$(BBILIB) -lbbi
LIBRARIES  = -L$(LIB) -lZlib -L$(BBILIB) -lbbi

LFLAGS     = $(LIBRARIES)
LOAD       = g++ 
#LOAD       = /u/ap/yunhai/mpich/bin/mpiCC 

TEST_OBJ   = main.o

z      : $(TEST_OBJ) 
	$(LOAD) -o z $(TEST_OBJ) $(LFLAGS)

main.o : main.cpp 
	$(COMPILE) $(CFLAGS)  main.cpp 


