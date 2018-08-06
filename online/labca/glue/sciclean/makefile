SCILAB=/usr/lib/scilab-4.1

all:	sciclean.o

%.o: %.c
	$(CC) -c -O2 -I. -I$(SCILAB)/routines $^

clean:
	$(RM) sciclean.o
