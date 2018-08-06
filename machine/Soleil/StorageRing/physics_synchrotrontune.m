function nus = physics_synchrotrontune(eVRF,E,rho)
%  PHYSICS_ENERGYLOSS - Computed synchrotron tune
%
%  INPUTS
%  1. E - Energy in GeV
%  2. eVRF - RF voltage in keV
%  3. rho - Curvature radius in meters 
%
%  OUPUTS
%  1. nus - synchrotron tune
%
%  EXAMPLES
%  1. physics_synchrotrontune(4000,2.75,5.36)
%
%  See Also  physics_RFacceptance, physics_quantumlifetime,
%  physics_energyloss, physics_synchronousphase

%
% Written by Laurent S. NAdolski
%
% rho 12.376 m for Booster
% rho 5.360  m for storagering


h     = getharmonicnumber;
alpha = getmcf('Model');
cosPhis = cos(physics_synchronousphase(eVRF,E,rho));
nus = sqrt(alpha*h*cosPhis/2/pi.*eVRF*1e-6/E);
