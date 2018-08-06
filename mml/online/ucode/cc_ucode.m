function cc_ucode(fn)

% PLIBDIR = /ctrl/local/lib
% PSYSDIR = /ctrl/sys.programs
% PBINDIR = /ctrl/sys.programs/bin
% PINCDIR = /ctrl/sys.programs/Include
% 
% PLIBINC = -L$(PLIBDIR)
% 
% LIBS=	$(PLIBINC) \
% 	-lucode -lddr \
% 	-lutil \
% 	-lm
% 
% CFLAGS = -I$(PINCDIR)
% 
% YFLAGS = -d
% OBJ = uio.o
% 
% uget: $(OBJ) uio.mk
% 	cc $(CFLAGS) -o uio $(OBJ) $(LIBS)


mex getpvucode.c -L/ctrl/local/lib -lucode -lddr -lutil -lm -I/ctrl/sys.programs/Include 

%mex getpvucode.c mexfunc.obj u:\portmann\matlab\als\linkwin32\gplink32\Debug\gplink32.lib
%-Iz:\include\controls -Iu:\portmann\matlab\als\linkwin32\gplink32
