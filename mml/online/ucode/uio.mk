PROOT = /ctrl

PLIBDIR = $(PROOT)/local/lib
PSYSDIR = $(PROOT)/sys.programs
PBINDIR = $(PSYSDIR)/bin
PINCDIR = $(PSYSDIR)/Include

PLIBINC = -L$(PLIBDIR)

LIBS=	$(PLIBINC) \
	-lucode -lddr \
	-lutil \
	-lm

CFLAGS = -I$(PINCDIR)

YFLAGS = -d
OBJ = uio.o

uget: $(OBJ) uio.mk
	cc $(CFLAGS) -o uio $(OBJ) $(LIBS)
