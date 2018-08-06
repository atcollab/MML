PROOT = /ctrl

PLIBDIR = $(PROOT)/local/lib
PSYSDIR = $(PROOT)/sys.programs
PBINDIR = $(PSYSDIR)/bin
PINCDIR = $(PSYSDIR)/Include 
#PINCDIR = /mnts/datafiles/sys.programs/Include

PLIBINC = -L$(PLIBDIR)

LIBS=	$(PLIBINC) \
	-lucode -lddr \
	-lutil \
	-lm

CFLAGS = -I$(PINCDIR)

YFLAGS = -d
OBJ = uputsp.o

uputsp: $(OBJ) uputsp.mk
	cc $(CFLAGS) -o uputsp $(OBJ) $(LIBS)
