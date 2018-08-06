Dear Colleagues,
I have written a new version of the AT dipole fourth-order symplectic passmethods to 
include the second order fringe field effects and to do the symplectic integration 
through dipole body in the curvilinear coordinate properly. Please see the attached 
note for details. 

The limitations of the existing passmethod can be made obvious by deriving the second 
order Transport map of a dipole (using the attached M file findTransportMap). All 
elements of the map except those associated with the energy error are zero is using 
the passmethod BndMPoleSymplectic4Pass. 

Examining the code reveals that the passmethod does symplectic integration on Cartesian 
coordinates while the phase space variables are defined on the curvilinear coordinate 
system. This is corrected in the new passmethods. It is believed that the code Tracy has 
the same problem.

The existing version of BndMPoleSymplectic4Pass accounts for only the edge focusing effect 
(linear order). This is inadequate since the fringe field effects affect nonlinear dynamics.

Regards!
Xiaobiao


Usage of the Bend Passmethod Code

A. To compile to DLL with MS VC:
   (1) create a new empty Win32 DLL project.
   (2) import the four files by Menu - Project - Add Existing Item
   (3) add link libraries by Menu - Project - Properties, choose Linker - Input, add libmex.lib and libmx.lib to 'additional dependencies' row. 
   (4) compile. 
There may be differences depending on your machine's setup. 

B. To compile in Matlab with mex 
>> mex -c atlalib.c
>> mex -c atphylib.c
>> mex -l atlalib.obj atphyslib.obj BndMPoleSymplectic4E2Pass.c

C. (thanks to Laurent Nadolski) The compilation under Linux Redhat enterprise is done using the command
>> mex -ldl -DGLNX86  BndMPoleSymplectic4E2Pass.c atlalib.o atphyslib.o

D. I edited Andrei Terebilo's original code to put the revised algorithm in. The framework and the majority of the code lines are the same. 

E. I haven't tested the code in all possible ways of using it. If there are errors, please let me know. 

Xiaobiao Huang
xiahuang@slac.stanford.edu
   
8/28/2009
