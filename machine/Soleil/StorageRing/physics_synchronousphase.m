function phis = physics_synchronousphase(eVRF,E,rho)
%  PHYSICS_SYNCHRONOUSPHASE - Compute  synchronous phase
%
%  INPUTS
%  1. eVRF - RF voltage in keV
%  2. E - Energy in GeV
%  3. rho - Curvature radius in meters 
%
%  OUPUTS
%  1. phis - synchronous phase
%
%  EXAMPLES
%  1. physics_synchronousphase(4000,2.75,5.36)*180/pi
%     is 13.65 degrees for Soleil
%
%  See Also  physics_RFacceptance, physics_quatumlifetime,
%  physics_energyloss

%
% Written by Laurent S. Nadolski

U0 = physics_energyloss(E,rho); % keV

phis = asin(U0./eVRF);