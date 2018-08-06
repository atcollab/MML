
.PHONY: default all clean prune lib  mon pp depend

.SILENT: clean prune

#--------------------------------------------------
SHELL            = /bin/sh
PROJECTDIR       = /u/ap/cho/work1/Projects/LINUX24/TAU3P
PROJECTLIB       = /u/ap/cho/work1/Projects/LINUX24/TAU3P/lib/LINUX24RH9/

INCDIRS  	 = -I$(PARMETIS_INCLUDE) \
		   -I$(NETCDF_INCLUDE) \
		   -I$(PROJECTDIR)/slacsupport/src \
                   -I$(PROJECTDIR)/nml/src \
		   -I$(PROJECTDIR)/meshformat/src \
                   -I$(PROJECTDIR)/distmesh/src \
                   -I$(PROJECTDIR)/monitors/src \
                   -I$(ZOLTAN_INCLUDE) \
		   -I$(SUPERLU_INCLUDE)

CCC              =  mpiCC
CCFLAGS		 =  -O2 -DNDEBUG  -Wall  -Wno-non-template-friend -MD

TAU3P_LIB	 =  libtau3p.a

LIBS		 =  	-ltau3p \
			-lsuperlu \
			-lnml \
			-lm   \
			-lmonitors \
			-ldistmesh \
			-lmeshformat \
			-lslacsupport \
			-lzoltan \
			-lparmetis -lmetis\
			-lnetcdf \
		    	-llapack -lblas  \
			-lfl 


LIBDIR		 =  -L$(PARMETIS_LIB) \
		    -L$(NETCDF_LIB) \
		    -L$(SUPERLU_LIB) \
		    -L$(ZOLTAN_LIB) \
                    -L$(PROJECTLIB) 

LDFLAGS		 =   $(LIBDIR) $(LIBS) 

#--------------------------------------------------
LIBSOURCES = \
	  BeamBoundExcitation.C	\
	  BeamLoading.C		\
	  Bunch.C		\
	  BunchMan.C		\
	  CurveMesh.C           \
	  GaussianBunch.C	\
	  OpenBoundary.C	\
	  PlaneCoords.C 	\
	  Tau3pField.C          \
	  Tau3pNodeList.C       \
	  TrajectoryMesh.C      \
          AEMatrixBuild.C       \
          AHMatrixBuild.C       \
          Application.C         \
          ApplicationMan.C      \
          BoundaryCondition.C   \
          BoundaryLoading.C     \
          Checkpoint.C          \
          DipoleLoading.C       \
          DualFace.C            \
          ESAnalytic.C          \
          ESolver.C             \
          ESolverMan.C          \
          Excitation.C          \
          GaussianPulse.C       \
          InPolyhedron.C        \
          LineInMesh.C          \
          LineMesh.C            \
          Loading.C             \
          LoadingMan.C          \
          MON_DOFBoundary.C     \
          MON_EProjOnLine.C     \
          MON_WakeField.C       \
          MON_WakeFieldDirect.C \
          Mode.C                \
          ModeAnalytic.C        \
          ModeAnalyticMan.C     \
          ModeCirc.C            \
          ModeCircTE.C          \
          ModeCircTM.C          \
          ModeCoax.C            \
          ModeCoaxTEM.C         \
          ModeNumerical.C       \
          ModeRect.C            \
          ModeRectTE.C          \
          ModeRectTM.C          \
          MonitorMan.C          \
          PlaneMesh.C           \
          PlaneOrientation.C    \
          PointInCell.C         \
          Polygon.C             \
          Pulse.C               \
          PulseMan.C            \
          RecordFile.C          \
          Restart.C             \
          SingleFreqPulse.C     \
          Sparameters.C         \
          T3P_BFieldMan.C       \
          T3P_EFieldMan.C       \
          TAU3PMesh.C		\
          TLFilter.C            \
          TLNoLoss.C            \
          TSLeapFrog.C          \
          TSLeapFrogFilter.C    \
          TSolver.C             \
          TSolverMan.C          \
          Tau3P.C               \
          TransmissionLine.C    \
          TypeDef.C             \
          WGBoundary.C          \
          angle.C               \
          bessel.C              \
          complex.C             \
          fcopy.C               \
          laguer.C              \
          zroots.C              

EXSOURCES  =  main.C              

MONSOURCES =                             \
          buildMON_FieldNodes.C          \
          buildMON_FieldNodeSurfaceNC.C  \
          buildMON_FieldNodeSurface.C    \
          buildPeakFields.C          

PPSOURCES =                       \
          getPtField.C            \
          maxFieldNodePoint.C     \
          maxFieldNodeSurface.C       

LIBOBJECTS         = $(LIBSOURCES:.C=.o)
EXOBJECTS         = $(EXSOURCES:.C=.o)
MONOBJECTS         = $(MONSOURCES:.C=.o)
PPOBJECTS         = $(PPSOURCES:.C=.o)

#--------------------------------------------------

.SECONDARY: $(LIBOBJECTS) $(EXOBJECTS) $(MONOBJECTS) $(PPOBJECTS) $(TAU3P_OBJS)

.INTERMEDIATE: $(TAU3P_LIB)

#--------------------------------------------------

.SUFFIXES: 

%.o : %.C
	$(CCC) $< -c $(CCFLAGS) $(INCDIRS) 


#--------------------------------------------------
default: lib tau3p

all:  tau3p mon pp

prune:
	-rm -f *.o *.a *~ core *.*~ 

clean: prune
	-rm -f *.d $(TAU3P_LIB) $(PROJECTLIB)/$(TAU3P_LIB) tau3p 

################################################################################
# lib

lib:  $(PROJECTLIB)/$(TAU3P_LIB)

$(TAU3P_LIB):  $(LIBOBJECTS)	
	ar vur $(TAU3P_LIB) $(LIBOBJECTS) 
	ranlib $(TAU3P_LIB)

$(PROJECTLIB)/$(TAU3P_LIB):  $(TAU3P_LIB)
	mkdir -p $(PROJECTLIB)
	cp $(TAU3P_LIB) $(PROJECTLIB) 

################################################################################
# tau3p
 
TAU3P_OBJS = \
	$(EXOBJECTS) \
	$(PROJECTLIB)/$(TAU3P_LIB) \
	$(PROJECTLIB)/libnml.a \
	$(PROJECTLIB)/libslacsupport.a \
	$(PROJECTLIB)/libdistmesh.a \
	$(PROJECTLIB)/libmeshformat.a 

tau3p: $(TAU3P_OBJS)
	$(CCC) -o tau3p $(EXOBJECTS) $(LDFLAGS)

################################################################################

mon: buildMON_FieldNodes buildMON_FieldNodeSurfaceNC buildMON_FieldNodeSurface buildPeakFields

BUILDMON_OBJS= \
	$(MONOBJECTS) \
	$(PROJECTLIB)/libnml.a \
	$(PROJECTLIB)/libslacsupport.a \
	$(PROJECTLIB)/libdistmesh.a \
	$(PROJECTLIB)/libmeshformat.a 

buildPeakFields: $(BUILDMON_OBJS)
	$(CCC) -o buildPeakFields buildPeakFields.o $(LDFLAGS)

buildMON_FieldNodes: $(BUILDMON_OBJS)
	$(CCC) -o buildMON_FieldNodes buildMON_FieldNodes.o $(LDFLAGS)

buildMON_FieldNodeSurfaceNC: $(BUILDMON_OBJS)
	$(CCC) -o buildMON_FieldNodeSurfaceNC buildMON_FieldNodeSurfaceNC.o $(LDFLAGS)

buildMON_FieldNodeSurface: $(BUILDMON_OBJS)
	$(CCC) -o buildMON_FieldNodeSurface buildMON_FieldNodeSurface.o $(LDFLAGS)

################################################################################
# pp postprocessing scripts

PP_OBJS= \
	$(PPOBJECTS) \
	$(PROJECTLIB)/libnml.a \
	$(PROJECTLIB)/libslacsupport.a \
	$(PROJECTLIB)/libdistmesh.a \
	$(PROJECTLIB)/libmeshformat.a 

pp: getPtField maxFieldNodePoint maxFieldNodeSurface 

getPtField: $(PP_OBJS)
	$(CCC) -o getPtField getPtField.o $(LDFLAGS)

maxFieldNodePoint: $(PP_OBJS)
	$(CCC) -o maxFieldNodePoint maxFieldNodePoint.o -L$(PROJECTLIB) -lslacsupport

maxFieldNodeSurface: $(PP_OBJS)
	$(CCC) -o maxFieldNodeSurface maxFieldNodeSurface.o $(LDFLAGS)

#--------------------------------------------------

sinclude *.d

#--------------------------------------------------

depend:
	 makedepend -- -MMD -- $(LIBSOURCES)

# DO NOT DELETE THIS LINE -- make depend depends on it.



