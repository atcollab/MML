Documentation and build/install instructions
can be found in the manual (documentation/manual.pdf).

Quick instructions:

RUN BINARY DISTRIBUTION

 - point your PATH to bin/<arch>
 - point your LD_LIBRARY_PATH to lib/<arch> (linux/solaris only)
 - note that the binary distribution has
       * channel-access linked into labca (linux/solaris)
       * channel-access DLLs in bin/win32-x86 (win32)
   if you build from source then the environment variable
   PATH (win32) / LD_LIBRARY_PATH (linux, solaris) must also
   point to your EPICS base bin/<arch> (win32) or
   lib/<arch> (linux, solaris)
 MATLAB:
  - start matlab; 
  -   addpath bin/<arch>/labca
  - ready to go, type e.g. help labca
  >>> if MATLAB aborts on errors (linux), this is most likely
      due to MATLAB run-time installation problems (see ReleaseNotes).
      Try setting LD_PRELOAD environment variable (prior to
      launching MATLAB):
        setenv LD_PRELOAD /usr/lib/libstdc++.so.5:/lib/libgcc_s.so.1
 SCILAB:
  - start scilab
  -   exec bin/<arch>/labca.sce
  - ready to go, type e.g. help lca
  

BUILD FROM SOURCE

 - edit configure/CONFIG and set target application
   (MAKEFOR=MATLAB  or MAKEFOR=SCILAB)
   and (optionally) the installation directory.
   You can also enable (experimental) support
   for Ctrl-C handling there. With this feature
   enabled, you can interrupt lcaGet/lcaPut by
   hitting Ctrl-C on the keyboard.
   
 - edit configure/RELEASE to point to your
    o EPICS base
    o MATLAB
    o SCILAB
   installation directories and (WIN32 only)
    o set MATLIB_SUBDIR to point to your compiler
      dependent libmx/libmex versions.
 - set EPICS_HOST_ARCH environment
   variable.
 - run GNU make from this directory.
    

T.S, 2006/4
