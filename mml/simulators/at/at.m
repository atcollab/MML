%at - functions specific to the Accelerator Toolbox
%
% Written by Laurent S. Nadolski
%
% TODO finish comments
%
% Simulator/track
%
%   linepass
%   ringpass
%   atpass
%
% Simulator/element
%
%   aperture
%   buildBL11table
%   corrector
%   drift
%   hmonitor
%   marker
%   mDriftPass
%   mexpassmethod
%   mIdentityPass
%   monitor
%   multipole
%   passmethods
%   quadrupole
%   rbend
%   rbend2
%   rfcavity
%   sbend
%   sextupole
%   solenoid
%   vmonitor
%   wiggler
%   wigtable
%   WigTablePass
%
% atdemo
%   atslider
%   demoknob
%   elementpassdemo
%   findrespmdemo
%   latticedemo
%   linoptdemo
%   ohmienvelopedemo
%   sp3v81f
%   spear2
%   spear2rad
%   spear2resp
%   spear3
%   talk
%   trackingdemo
%
% Miscellaneous
%
%  atdiag
%  athelp
%  atmexall
%  atpath
%  atroot
%
% Atgui
%
%   dispfamvalues
%   intelem
%   intlat
%
% Atphysics
%
%   cavityoff
%   cavityon
%   findelemaddiffmatrix
%   findelemm44
%   findelemm66
%   findelemraddiffmatrix
%   findelemraddiffm
%   findm44
%   findm66
%   findmpoleraddiffmatrix
%   findorbit4
%   findorbit6
%   findorbit
%   findrespm
%   findspos
%   findsyncorbit
%   findthickmpoleraddiffm
%   findthinmpoleraddiffm
%   fitchrom2
%   fittune2
%   intfft
%   linopt
%   mcf
%   mcf2
%   mkSRotationMatrix
%   numdifparams
%   ohmienvelope
%   plotbeta
%   plotcod
%   private/lyap
%   radiationoff
%   radiationon
%   thickmpoleraddiffm
%   thinmpoleraddiffm
%   tunechrom
%   tunespaceplot
%   twissline
%   twissring
%
% Lattice
%
%   atelem
%   atindex
%   atparamgroup
%   buildlat
%   combinebypassmethod
%   combinelinear45
%   findcells
%   findtags
%   getcellstruct
%   insertelem0
%   insertelem_dev
%   insertindrift
%   isatelem
%   isatlattice
%   mergedrift
%   mkparamgroup
%   mksrollmat
%   mvelem
%   readmad
%   restoreparamgroup
%   reverse
%   rmelem0
%   saveparamgroup
%   setcellstruct
%   setparamgroup
%   setshift
%   settags
%   settilt
%   splitdrift
%   splitelem
% 
% Below is the result of the athelp command
%
% Physics Tools
% FINDMPOLERADDIFFMATIRX calculates radiation diffusion matrix of a multipole element
% FINDELEMRADDIFMAT calculates element 'radiation diffusion matrix' B
% RADIATIONON turns classical radiation  ON
% NUMDIFPARAMS (all caps) is a global variable in AT
% TWISSRING calculates linear optics functions for an UNCOUPLED ring
% FINDTHINMPOLERADDIFFM
% CAVITYON turns Cavities ON
% FINDM66 numerically finds the 6x6 transfer matrix of an accelerator lattice
% FINDSYNCORBIT finds closed orbit, synchronous with the RF cavity 
% TWISSLINE calculates linear optics functions for an UNCOUPLED transport line
% MKSROTATIONMATRIX(PSI) coordinate transformation matrix 
% FINDSPOS returns longitudinal positions of accelerator lattice elements.
% CAVITYOFF turns Cavities OFF
% MCF - Calculates momentum compaction factor (MCF) of RING
% FINDELEMM44 numerically finds the 4x4 transfer matrix of an element
% TUNESPACEPLOT draws a tune diagram
% FINDELEMRADDIFFM
% FITCHROM2 fits chromaticity  of THERING using 2 sextupole families
% FITTUNE2 fits linear tunes of THERING using 2 quadrupole families
% OHMIENVELOPE calculates equilibrium beam envelope in a 
% PLOTBETA plots UNCOUPLED! beta-functions
% TUNECHROM computes linear tunes and chromaticities for COUPLED or UNCOUPLED lattice
% FINDRESPM computes the change in the closed orbit due to parameter perturbations
% FINDORBIT6 finds closed orbit in the full 6-d phase space
% RADIATIONOFF turns classical radiation  OFF
% FINDELEMM66 numerically finds the 6x6 transfer matrix of an element
% FINDTHICKMPOLERADDIFFM
% FINDTHICKMPOLERADDIFFM
% MCF2(RING) calculates momentum compaction factor of RING versus energy
% LINOPT performs linear analysis of the COUPLED lattices
% FINDM44 numerically finds the 4x4 transfer matrix of an accelerator lattice
% PLOTCOD Closed Orbit Distortion
% INTFFT - calculate the tune from interpolated FFT of the trajectory.
% FINDORBIT is an alias to the orbit search functions:
% FINDORBIT4 finds closed orbit in the 4-d transverse phase 
% FINDTHINMPOLERADDIFFM
% 
% Lattice Tools
% SETTILT sets the entrance and exit misalignment matrixes
% SETCELLSTRUCT sets the field values of MATLAB cell array of structures
% INSERTELEM0 - quick and dirty:
% GETCELLSTRUCT retrieves the field values MATLAB cell array of structures 
% INSERTELEM0 inserts element(s) of zero length into a drift space
% RMELEM0 removes elements of length 0 from the accelerator lattice
%  PARAMETER GROUP in AT is a general way
% ISATELEM tests if an input argument is a valid AT element.
% ISATLATTICE tests if an input argument is a valid AT lattice.
% COMBINELINEAR45 combines adjacent  elements that use 4-by-5 PassMethods
%  INSERTINDRIFT inserts one or more elements into a drift element
% MKSROLLMAT - rotation matrix around s-axis
%  INSERTELEM inserts one or more elements inside another element
% ATINDEX extracts the information about element families and
% FINDCELLS performs a search on MATLAB cell arrays of structures
% READMAD reads the file output of MAD commands
% BUILDLAT places elements from FAMLIST into cell array THERING
% RESTOREPARAMGROUP restores the values of multiple physical 
% MVELEM(ELEMPOS, DIST) moves an element  located at ELEMPOS in THERING
% SAVEPARAMGROUP saves the values of multiple physical 
% COMBINEBYPASSMETHOD combines adjacent elements that have the same specified pass method
% SPLITDRIFT inserts an element into a drift space
% MERGEDRIFT removes a lattice element and merges the two adjacent drift spaces
% ATELEM makes a new AT element structure from another element, 
% SETTAGS assigns individual string tags to elements in lattice THERING
% SETSHIFT sets the misalignment vectors T1, T2 for elements
% FINDTAGS looks for string matches in 'Tag' field of AT lattice elements
% MKPARAMGROUP simplifies creation of AT parameter groups
% SETPARAMGROUP modifies a group of parameters
% REVERSE reverses the order of elements in a one-dimensional MATLAB ARRAY
% 
% AT Demos
% SPEAR2RAD example lattice definition file
% LINOPTDEMO script illustrates the use of LINOPT
% ATSLIDER is an example of a GUI control of multiple parameters in THERING
% SPEAR2RESP  example SPEAR2 lattice with orbit correctors and BPMS
% TALK
%  All the dipole and quadrupole lengths are effective lengths
% TRACKINGDEMO self-running tutorial
% LATTICEDEMO self-running tutorial
%  ===================== Injection Kickers and Drifts ============================================ 
% FINDRESPMDEMO response matrix demo
% SPEAR2 example lattice definition file
% DEMOKNOB illustrates the use of MATLAB GUI controls with AT
% ELEMENTPASSDEMO self-running tutorial
% OHMIENVELOPEDEMO illustrates the use of OHMIENVELOPE function


disp('type athelp');
